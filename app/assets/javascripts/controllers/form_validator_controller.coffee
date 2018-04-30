application.register "form-validator", class extends Stimulus.Controller
  connect: ->
    for fieldElement in this.element.querySelectorAll('[data-validate-remote]')
      fieldElement.addEventListener 'change', (event) ->
        _element = event.target
        fetch(_element.dataset['validateRemote'], {
          method: 'post',
          body: "value=#{_element.value}",
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name=csrf-token]').content,
            'Content-type': 'application/x-www-form-urlencoded; charset=UTF-8'
          },
          credentials: 'same-origin'
        })
        .then((response) -> response.json())
        .then((json) ->
          formGroup = _element.closest('.form-group')
          if json.valid
            formGroup.classList.remove('is-invalid')
            formGroup.classList.add('is-valid')
          else
            formGroup.classList.add('is-invalid')
            formGroup.classList.remove('is-valid')
          message = formGroup.querySelector('.valid-message')
          unless message
            message = document.createElement('div')
            message.className = 'valid-message'
            formGroup.insertBefore(message, _element.nextSibling)
          message.textContent = json.message
        )
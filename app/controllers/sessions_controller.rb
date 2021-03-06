class SessionsController < ApplicationController
  include AuthPassword
  layout 'session'

  skip_before_action :require_site
  before_action :require_auth_password_enabled, only: [:create]

  def new
    if params[:return_to]
      session[:return_to] = URI(params[:return_to]).path
    end
  end

  def create
    user = User.where("lower(username) = lower(:login) or lower(email) = lower(:login)", login: params[:login]).first

    if user&.authenticate(params[:password])
      sign_in(user)
      redirect_to session.delete(:return_to) || root_path
    else
      @sign_in_error = true
      render 'update_form'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end

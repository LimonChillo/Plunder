class Users::RegistrationsController < Devise::RegistrationsController
 before_filter :configure_sign_up_params, only: [:create]
 before_filter :configure_account_update_params, only: [:update]

  def edit
    super
  end

  def update
    super
    @user.avatar = params[:avatar] if params[:avatar] != nil
    @user.save
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :location, :password, :password_confirmation)
    end
   end

  def configure_account_update_params
     devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :email, :location, :avatar, :password, :password_confirmation, :current_password)
    end
  end
end
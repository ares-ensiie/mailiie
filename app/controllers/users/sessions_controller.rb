class Users::SessionsController < Devise::SessionsController
  before_action :authenticate_user!, except: [:new, :create]
  layout false
  # before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    if params[:redirect_to].present?
      store_location_for(resource, params[:redirect_to])
    end
    super
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  # end
end
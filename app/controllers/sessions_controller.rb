class SessionsController < ApplicationController
  include Authentication
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

def create
  if User.count.zero?
    user = User.find_or_initialize_by(email_address: params[:email_address])
    if user.new_record?
      user.name = params[:email_address].split("@").first
      user.password = SecureRandom.hex(16)
      user.password_confirmation = user.password
      user.save!(validate: false)
    end
    start_new_session_for(user)
    flash[:notice] = "Logged in as #{user.name} (no admin defined)"
    redirect_to after_authentication_url

  else
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for(user)
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end
end



  def destroy
    terminate_session
    redirect_to new_session_path
  end
end

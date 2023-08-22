class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = "Invalid email/password combination"
      render :new, status: :unprocessable_entity, content_type: "text/html"
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end

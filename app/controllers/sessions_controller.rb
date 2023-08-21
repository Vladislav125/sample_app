class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authentificate(params[:session][:password])

    else
      flash.now[:danger] = "Invalid email/password combination"
      # render 'new'
      render :new, status: :unprocessable_entity, content_type: "text/html"
    end
  end

  def destroy
  end
end

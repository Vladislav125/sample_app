module SessionsHelper
  # осуществляет вход данного пользователя
  def log_in(user)
    session[:user_id] = user.id
  end

  # возвращает текущего вошедшего пользователя, если он есть
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # возвращает true, если пользователь зарегистрирован, иначе false
  def logged_in?
    !current_user.nil?
  end

  # осуществляет выход
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end

module SessionsHelper
  # осуществляет вход данного пользователя
  def log_in(user)
    session[:user_id] = user.id
  end

  # запоминает пользователя в постоянном сеансе
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # возвращает текущего вошедшего пользователя, если он есть
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # возвращает true, если пользователь зарегистрирован, иначе false
  def logged_in?
    !current_user.nil?
  end

  # закрывает постоянный сеанс
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # осуществляет выход
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # возвращает true, если данный пользователь является текущим
  def current_user?(user)
    user == current_user
  end

  # перенаправить по сохранённому адресу или на страницу по умолчанию
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # запоминает URL
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end

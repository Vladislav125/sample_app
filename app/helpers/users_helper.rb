module UsersHelper
  # Возвращвет граватар для данного пользователя
  def gravatar_for(user, options = { size: 120 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar" )
  end
end

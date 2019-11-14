module ApplicationHelper
  def full_title(page_title)
    base_title = "MOTO SNS"
    if page_title.blank?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: 'gravatar')
  end
end

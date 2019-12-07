module ApplicationHelper
  def full_title(page_title)
    base_title = "MOTO SNS"
    if page_title.blank?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def avatar_url(user)
    return user.image if user.image
    gravatar_id = Digest::MD5.hexdigest(user.email).downcase
    "https://www.gravatar.com/avatar/#{gravatar_id}.jpg"
  end
end

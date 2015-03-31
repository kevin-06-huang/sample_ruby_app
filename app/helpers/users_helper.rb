module UsersHelper
  # by default, helper methods are available in any view, it is a matter
  # of convention and convenience that we chose to put the gravatar_for
  # method in the helpers for Users controller; this is in listing 7.9
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
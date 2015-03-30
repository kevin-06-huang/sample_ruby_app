module ApplicationHelper
  #this is a full title helper method we define on our own to provide the full title
  #section 4.1
  def full_title(page_title = '')
    
    base_title = "Ruby on Rails Tutorial Sample App"

    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end

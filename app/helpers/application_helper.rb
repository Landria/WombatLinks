module ApplicationHelper
  def title page_title
    content_for(:title) { page_title }
  end

  def description
    t 'site.description'
  end

  def keywords
    t 'site.keywords'
  end
end

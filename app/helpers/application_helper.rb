module ApplicationHelper
  def title_tag(page_title)
    content_tag :title, [page_title, 'Lolgramz'].
                         reject { |x| x.to_s.strip.blank? }.
                         join(' - ')
  end
  
  # Returns HTML for <meta> tags that belong on every page. To override
  # this for a specific view, add to the top of that view:
  #
  #     <% content_for :meta_tags, '<meta ... />' %>
  def meta_tags(page_specific_tags='')
    html = tag(:meta, :charset => 'utf-8')

    if page_specific_tags.present?
      html << page_specific_tags
    end
    
    html << csrf_meta_tag.to_s

    html
  end
  
  # Returns HTML for <link> tags that belong on a page.
  # to set values for this, call:
  #
  # content_for :stylesheets, stylesheet_link_tag('foo', ...)
  def stylesheet_tags
    content_for :stylesheets
  end
  
  # Returns HTML for <script> tags that belong on a page.
  # to set values for this, call:
  #
  # content_for :javascripts, javascript_include_tag('foo', ...)
  def javascript_tags
    content_for :javascripts
  end
end

class RemoteLinkRenderer < WillPaginate::LinkRenderer
  def prepare(collection, options, template)
    @remote = options.delete(:remote) || {}
    super
  end

  protected
    def page_link(page, text, attributes = {})
      @template.link_to_remote(text, {:url => url_for(page), :before => "Element.show('spinner')", :success => "Element.hide('spinner')", :method => :get}.merge(@remote).except(:authenticity_token), attributes)
    end
end

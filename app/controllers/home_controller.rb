class HomeController < ApplicationController
  layout 'frontend'

  def index
    session[:filter_type] = nil
    session[:filter_query] = nil
    Rails.cache.delete('total_stats')
  end
end

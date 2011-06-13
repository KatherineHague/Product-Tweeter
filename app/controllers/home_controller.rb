class HomeController < ApplicationController
  
  around_filter :shopify_session, :except => 'welcome'
  
  def welcome
    current_host = "#{request.host}#{':' + request.port.to_s if request.port != 80}"
    @callback_url = "http://#{current_host}/login/finalize"
  end
  
  def index
    if params[:id]
      shop = ShopifyAPI::Shop.current
      product = ShopifyAPI::Product.find(params[:id])
      status = "#{product.title} now available for $#{product.price_range} at {#shop.name} http://#{shop.domain}/products/#{product.handle}"
      redirect_to "http://twitter.com/intent/tweet?status=#{ERB::Util.u(status)}"
    else
      # get 3 products
      @products = ShopifyAPI::Product.find(:all, :params => {:limit => 3})

      # get latest 3 orders
      @orders   = ShopifyAPI::Order.find(:all, :params => {:limit => 3, :order => "created_at DESC" })
    end
  end
  
end
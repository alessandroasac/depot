class StoreController < ApplicationController
  def index
    session[:counter] = 0 if session[:counter].nil?
    session[:counter] += 1
    @products = Product.order(:title)
  end
end

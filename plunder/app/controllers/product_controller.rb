class ProductController < ApplicationController
  def show
  	@product = Product.all
  end

  def edit
  end
end

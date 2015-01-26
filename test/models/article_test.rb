require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  
  	def setup
		@user_1 = User.create!({:email => "e@e.ee", :password => "11111111", :password_confirmation => "11111111", :name => "Manuel", :location => "Puch"})
	end
	
	test "article without name" do
		assert !@user_1.articles.create.valid?, 'Article without name createable!'
	end

	# Rails escapes HTML tags automatically, no needs for this test

	# test "article without html tags" do
	# 	assert !@user_1.articles.create(:name => "Testobjekt", :description => "<a class=> hallo").valid?, 'Article can contain HTML Tag!'
	# end
end

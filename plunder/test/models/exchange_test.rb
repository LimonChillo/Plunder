require 'test_helper'

class ExchangeTest < ActiveSupport::TestCase
   
   	def setup
	end
	
	test "exchange without user" do
		assert !Exchange.create(:article_id_1 => 1, :article_id_2 => 2, :user_2 => 1, :user_1_accept => "unset", :user_2_accept => "unset" ).valid?, 'Exchange without user createable!'
	end

	test "exchange without article" do
		assert !Exchange.create(:article_id_2 => 1, :user_1 => 1, :user_2 => 2, :user_1_accept => "unset", :user_2_accept => "unset" ).valid?, 'Exchange without article createable!'
	end

	test "accept not in given state" do		
		assert !Exchange.create(:article_id_1 => 1, :article_id_2 => 3, :user_1 => 5, :user_2 => 7, :user_1_accept => "not", :user_2_accept => "unset" ).valid?, 'Wrong state for a accept creatable'
		assert Exchange.create(:article_id_1 => 2, :article_id_2 => 4, :user_1 => 6, :user_2 => 8, :user_1_accept => "unset", :user_2_accept => "unset" ).valid?, 'Exchange not createable'

	end

	test "exchange with yourself" do
		assert !Exchange.create(:article_id_2 => 1, :article_id_2 => 2, :user_1 => 1, :user_2 => 1, :user_1_accept => "unset", :user_2_accept => "unset" ).valid?, 'Exchange with same user possible!'
	end

	test "exchange same articles" do
		assert !Exchange.create(:article_id_1 => 1, :article_id_2 => 1, :user_2 => 2, :user_2 => 1, :user_1_accept => "unset", :user_2_accept => "unset" ).valid?, 'Exchange with same article possible!'
	end

end

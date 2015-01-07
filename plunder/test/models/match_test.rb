require 'test_helper'

class MatchTest < ActiveSupport::TestCase
   	
   	def setup
	end
	
	test "match without favorite" do
		assert !Match.create(:user_id => 2).valid?, 'Match without Favorite createable!'
	end

	test "match without user" do
		assert !Match.create(:favorite_id => 2).valid?, 'Match without User createable!'
	end

	test "user matches same article twice" do
		Match.create(:user_id => 2, :favorite_id => 2)
		
		assert Match.create(:user_id => 1, :favorite_id => 2).valid?, 'User matches article not possible'
		assert !Match.create(:user_id => 2, :favorite_id => 2).valid?, 'User matches same article twice createable!'
	end
end

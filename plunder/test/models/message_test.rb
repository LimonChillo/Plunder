require 'test_helper'

class MessageTest < ActiveSupport::TestCase
def setup
	end
	
	test "message without sender" do
		assert !Message.create(:text => "Hallo Test").valid?, 'Message without Sender createable!'
	end

	test "message without text" do
		assert !Message.create(:sender => 2).valid?, 'Message without text createable!'
	end

	test "article without html tags" do
		assert !Message.create(:sender => 2, :text => "<a class=> hallo").valid?, 'Article can contain HTML Tag!'
	end

end

class AboutController < ApplicationController
  skip_before_action :authenticate_user!

  def legal
  end
end

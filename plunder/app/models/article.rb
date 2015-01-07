class Article < ActiveRecord::Base
  has_many :matches
  
  has_many :users, :through => :matches
  belongs_to :user

  has_attached_file :avatar, :styles => { :large => "600x600", :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  #crop_attached_file :avatar
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  validates :name,
            :presence => true

end

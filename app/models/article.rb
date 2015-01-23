class Article < ActiveRecord::Base
  has_many :matches, :dependent => :destroy
  has_many :users, :through => :matches
  belongs_to :user

  has_attached_file :avatar, :styles => { :large => "600x600", :medium => "300x300#", :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
  
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates :name, :presence => true
  validates :description,
    :format => { :without => /<(.|\n)*?>/, :message => 'No HTML Tags allowed in description. ' }
end
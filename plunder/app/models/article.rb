class Article < ActiveRecord::Base
	has_many :matches
  has_many :users, :through => :matches
  belongs_to :user

  has_attached_file :avatar, :styles => { :large => "600x600", :medium => "300x300#", :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  #crop_attached_file :avatar
  #after_crop :reprocess_avatar, :if => :cropping?

  # def cropping?(id = 0)
  #   !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  # end


  # def self.reprocess_avatar
  #   #Article.where(:id => params[:id]).first.update_avatar(:crop_x => nil)



  #   crop_x = nil
  #   redirect_to random_article_path
  # end
end

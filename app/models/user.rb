class User < ActiveRecord::Base
  has_many :articles, :dependent => :destroy
  has_many :matches, :dependent => :destroy
  has_many :exchanges, as: :exchange_owner, :dependent => :destroy

  has_many :favorites, :through => :matches, :source => :favorite

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  scope :by_id, ->(id) {
    where(id: id).first
  }

  scope :avatar, ->(id, size) {
    if size == ":thumb"
      where(id: id).first.avatar.url(:thumb)
    else
      where(id: id).first.avatar.url(:medium)
    end
  }

  def self.avatar1 (size)
    if size == ":thumb"
      avatar = avatar.url(:thumb)
    else
      avatar = avatar.url(:medium)
    end
    return avatar
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)

    user = signed_in_resource ? signed_in_resource : identity.user

    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
end
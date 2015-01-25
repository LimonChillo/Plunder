class Exchange < ActiveRecord::Base

	belongs_to :exchange_owner, :polymorphic => true

	validates :user_1, :presence => true
	validates :user_2, :presence => true
	validates :article_id_1, :presence => true
	validates :article_id_2, :presence => true
	validates :user_1_accept,
    :presence => true,
		:inclusion => { :in => ["accepted", "rejected", "unset"] }
	validates :user_2_accept,
    :presence => true,
		:inclusion => { :in => ["accepted", "rejected", "unset"] }
	validate :no_self_exchange
	validate :no_same_articles

  private
    def no_self_exchange
      errors.add(:user_1, 'No Exchange with yourself!') if user_1 == user_2
    end

    def no_same_articles
      errors.add(:article_id_1, 'No Exchange with same articles!') if article_id_1 == article_id_2
    end
end
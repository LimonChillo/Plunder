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

  scope :actual, ->(id1, id2) {  
      where(article_id_1: [id1,id2], article_id_2: [id1,id2]).first
  }

  def self.matched_users(my_id)
    (Exchange.where(user_1: my_id).distinct.pluck(:user_2) | Exchange.where(user_2: my_id).distinct.pluck(:user_1)).sort!
  end

  def self.with_this_user(my_id, other_id)
    Exchange.where(user_1: [other_id, my_id], user_2: [other_id, my_id]).sort
  end

  def self.get_state(ex, current)
    if ex.user_1_accept == "accepted" && ex.user_2_accept == "unset" && ex.user_1 == current
      state = "iAccepted"
    elsif ex.user_1_accept == "accepted" && ex.user_2_accept == "unset"
      state = "accepted"
    elsif ex.user_1_accept == "rejected" && ex.user_2_accept == "unset" && ex.user_1 == current
      state = "iRejected"
    elsif ex.user_1_accept == "rejected" && ex.user_2_accept == "unset"
      state = "rejected"
    elsif ex.user_1_accept == "accepted" && ex.user_2_accept == "accepted"
      state = "bothAccepted"
    elsif ex.user_1_accept == "rejected" && ex.user_2_accept == "rejected"
      state = "bothRejected"
    else
      state = "neutral"
    end

    return state
  end

  def self.get_users_article(ex, current)
    if ex.user_1 == current
      my_article = ex.article_id_1
      other_article = ex.article_id_2
    else
      my_article = ex.article_id_2
      other_article = ex.article_id_1
    end

    return Article.find(my_article), Article.find(other_article)
  end

  def self.state_handler(ex, state, action, current, other_user, my_article, other_article)
    case state
    when "accepted"
      if action == "yes"
        ex.update_attributes(:user_2_accept => "accepted")
      else
        ex.update_attributes(:user_1_accept => "rejected", :user_1 => current, :user_2 => otherUser, :article_id_1 => my_article, :article_id_2 => other_article)
      end
    when "iAccepted"
      ex.update_attributes(:user_1_accept => "rejected")
    when "iRejected"
      ex.update_attributes(:user_1_accept => "accepted")
    when "bothAccepted"
      ex.update_attributes(:user_1_accept => "rejected", :user_2_accept => "unset", :user_1 => current_user.id, :user_2 => otherUser, :article_id_1 => my_article, :article_id_2 => other_article)
    when "neutral"
      if action == "yes"
        ex.update_attributes(:user_1_accept => "accepted", :user_1 => current, :user_2 => other_user, :article_id_1 => my_article, :article_id_2 => other_article)
      else
        ex.update_attributes(:user_1_accept => "rejected", :user_1 => current, :user_2 => other_user, :article_id_1 => my_article, :article_id_2 => other_article)
      end
    end
  end

  private
    def no_self_exchange
      errors.add(:user_1, 'No Exchange with yourself!') if user_1 == user_2
    end

    def no_same_articles
      errors.add(:article_id_1, 'No Exchange with same articles!') if article_id_1 == article_id_2
    end
end
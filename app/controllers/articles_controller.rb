class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @articles = Article.all
    respond_with(@articles)
  end

  def show
    respond_with(@article)
  end

  def new
    @article = Article.new
    respond_with(@article)

  end

  def edit
  end

  def create
    @article = Article.new(article_params.merge(:user_id => current_user.id))
    @article.save
    #render :action => 'crop'
    respond_with(@article)
  end

  def update
    @article.update(article_params)
    #respond_with(@article)
    @article.avatar = params[:avatar] if params[:avatar] != nil
    @article.save
    #if params[:article][:avatar].blank?
      respond_with(@article)
    #elsif params[:crop_x] == nil
    #  render :action => 'crop', :id => params[:id], :crop_x => params[:article][:crop_x]
    #end


  end

  def crop
    params.require(:article).permit(:crop_x, :crop_y, :crop_w, :crop_h)
    article = Article.where(:id => params[:id]).first
    for attribute in params[:article]
      article.update_attributes(attribute[0] => attribute[1])
    end

    if article.crop_x != nil
      article.avatar.reprocess!
      article.crop_x = nil
      article.save
      #Article.reprocess_avatar
    else
      redirect_to random_article_path
    end
  end

  # def reprocess_avatar
  #   avatar.reprocess!
  #   crop_x = nil
  #   redirect_to random_article_path
  # end

  def destroy
    @article.destroy
    respond_with(@article)
  end

  #def crop_attached_file

  #end


  def random
    othersArticles = Article.where.not(:user_id => current_user.id)
    matchedByMe = Match.where(:user_id => current_user.id).pluck(:favorite_id)

    @random_article = othersArticles.where.not(:id => matchedByMe).order("RANDOM()").first

  end

  def like
    # favorite Others article and like it
    current_user.favorites << Article.find(params[:id])
    if params[:choice] == "yes"
      current_match = Match.where(:user_id => current_user).where(:favorite_id => params[:id]).first
      current_match.like = true
      current_match.save

      #add Exchange Items
      add_exchange_items current_match
    end

    go_back
  end

  def matches

    @currentUser = current_user.id
    # Alle eigenen Artikel
    ownProducts = Article.where(:user_id => @currentUser)

    # Ids aller Artikel die ich like
    likedFavoriteIds = Match.where(:like => true, :user_id => @currentUser).pluck(:favorite_id)
    # Alle Artikel die ich like
    favoritedProducts = Article.where(:id => likedFavoriteIds)
    # Alle User von denen ich Artikel like
    favoritedUsers = User.joins(:articles).where(:articles => {:id => favoritedProducts}).distinct

    # Ids aller User die Artikel von mir liken
    likeingUsersIds = Match.where(:like => true, :favorite_id => ownProducts).pluck(:user_id)
    # Alle User die Artikel von mir liken
    likeingUser = User.where(:id => likeingUsersIds)


    # Alle User mit denen ich Matches habe
    @matchedUsers = (favoritedUsers & likeingUser)

    # Alle Produkte von gematchen Usern
    #producstFromMatchedUser = Article.joins(:users).where(:user => {:id => @matchedUsers})

    # Inhalt soll ein User mit allen Matches sein
    @matches = []

    # Schleife über alle User mit matches
    @matchedUsers.each do |matchedUser|

      # Alle Produkte eines Users
      productsFromMatchedUser = Article.where(:user_id => matchedUser)

      # Ids aller Produkte die dieser User liked
      likeingFavoriteIds = Match.where(:like => true, :user_id => matchedUser).pluck(:favorite_id)

      likeingFavoriteIds_1 = Exchange.where(:user_1 => current_user).where(:user_2 => matchedUser).pluck(:article_id_1)
      likeingFavoriteIds_2 = Exchange.where(:user_2 => current_user).where(:user_1 => matchedUser).pluck(:article_id_2)

      likedFavoriteIds_1 = Exchange.where(:user_1 => current_user).where(:user_2 => matchedUser).pluck(:article_id_2)
      likedFavoriteIds_2 = Exchange.where(:user_2 => current_user).where(:user_1 => matchedUser).pluck(:article_id_1)

      likeingFavoriteIds = likeingFavoriteIds_1 + likeingFavoriteIds_2
      likedFavoriteIds = likedFavoriteIds_1 + likedFavoriteIds_2      

      # Alle Produkte die der User liked
      likeingProducts = Article.where(:id => likeingFavoriteIds)

      # Alle Produkte die ich von diesem User like
      myMatches = (productsFromMatchedUser & favoritedProducts)

      # Alle Produkte die der User von mir liked
      otherMatches = (ownProducts & likeingProducts)

      # Inhalt sollen alle gegenüberstellungen von Artikeln sein
      array = []

      # Doppelte Schleife zur gegenüberstellung aller Artikel
      

      myMatches.each do |my|
        otherMatches.each do |other|



          #---------- State Handling ---------------------------

          # actualExchange = Exchange.where(:article_id_1 => [my.id,other.id], :article_id_2 => [my.id,other.id])

          # Feststellung welcher User ich bin, und welcher der andere ist.

          actualExchange = actual_exchange_method my.id, other.id

          # setzen der states
          if actualExchange.user_1_accept == "accepted" && actualExchange.user_2_accept == "unset" && actualExchange.user_1 == current_user.id
            state = "iAccepted"
          elsif actualExchange.user_1_accept == "accepted" && actualExchange.user_2_accept == "unset"
            state = "accepted"
          elsif actualExchange.user_1_accept == "rejected" && actualExchange.user_2_accept == "unset" && actualExchange.user_1 == current_user.id
            state = "iRejected"
          elsif actualExchange.user_1_accept == "rejected" && actualExchange.user_2_accept == "unset"
            state = "rejected"
          elsif actualExchange.user_1_accept == "accepted" && actualExchange.user_2_accept == "accepted"
            state = "bothAccepted"
          elsif actualExchange.user_1_accept == "rejected" && actualExchange.user_2_accept == "rejected"
            state = "bothRejected"
          else
            state = "neutral"
          end


          #----------------------------------------
          # Weitergabe des Matching Paares als Hash
          hash = { :other => my, :my => other, :state => state}
          array.push(hash)

        end
      end

      @matches.push(array)

    end
  end

  def exchange_handler

    action = params[:choice]
    state = params[:state]
    id1 = params[:id1]
    id2 = params[:id2]

    actualExchange = actual_exchange_method id1, id2

    if actualExchange.user_1 == current_user.id
      otherUser = actualExchange.user_2
    else
      otherUser = actualExchange.user_1
    end

    case state
    when "accepted"
      if action == "yes"
        actualExchange.update_attributes(:user_2_accept => "accepted")
      else
        actualExchange.update_attributes(:user_1_accept => "rejected", :user_1 => current_user.id, :user_2 => otherUser)
      end
    when "rejected"
      # Remove Match
      # IMPLEMENT
    when "iAccepted"
      # Undo Acception
      actualExchange.update_attributes(:user_1_accept => "unset")
    when "iRejected"
      # Undo Rejection
      actualExchange.update_attributes(:user_1_accept => "unset")
    when "bothAccepted"
      if action == "yes"
        #IMPLEMENT
      else
        actualExchange.update_attributes(:user_1_accept => "rejected", :user_2_accept => "unset", :user_1 => current_user.id, :user_2 => otherUser)
      end
    when "neutral"
      if action == "yes"
        actualExchange.update_attributes(:user_1_accept => "accepted", :user_1 => current_user.id, :user_2 => otherUser)
      else
        actualExchange.update_attributes(:user_1_accept => "rejected", :user_1 => current_user.id, :user_2 => otherUser)
      end

    else
    end

    go_back
  end

  def delete_match 
    id1 = params[:id1]
    id2 = params[:id2]
    id3 = params[:id3]


    Exchange.where(:article_id_1 => [id1,id2], :article_id_2 => [id1,id2]).first.destroy

    go_back
  end


  private

  def actual_exchange_method(my_id, other_id)

    return Exchange.where(:article_id_1 => [my_id,other_id], :article_id_2 => [my_id,other_id]).first

  end

   def go_back
    session[:return_to] ||= request.referer
    redirect_to session.delete(:return_to)
  end

  def add_exchange_items(current_match)
    # get my Articles that the other user liked
    userOfMatch = Article.where(:id => current_match.favorite_id).pluck(:user_id).first
    matchesOfOtherUser = Match.where(:user_id => userOfMatch).where(:like => true).all.pluck(:favorite_id)
    myMatchedArticlesByOtherUser = Article.where(:id => matchesOfOtherUser).where(:user_id => current_user.id).all

    # if other User has not liked any of my Articles go back
    if myMatchedArticlesByOtherUser == nil
      go_back
    end

    # get the other user's Articles I liked
    myMatches = Match.where(:user_id => current_user.id).where(:like => true).all.pluck(:favorite_id)
    otherUsersArticlesILiked = Article.where(:user_id => userOfMatch).where(:id => myMatches)

    # if I have not liked any of Other's Articles go back
    if otherUsersArticlesILiked == nil
      go_back
    end

    # iterate through my Articles combine with the Other's i just liked
    myMatchedArticlesByOtherUser.each do |myArticle|
      Exchange.create(
                      :article_id_1 => myArticle.id,
                      :article_id_2 => current_match.favorite_id,
                      :user_1 => current_user.id,
                      :user_2 => userOfMatch,
                      :user_1_accept => "unset",
                      :user_2_accept => "unset"
                      )
    end

  end

  # Führt je nach Status und gedrückten Button, Datenbankoperationen aus


    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:name, :user_id, :avatar, :description, :shippable, :crop_x)
    end
end

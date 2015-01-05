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
    #article_params
    @article = Article.new(article_params.merge(:user_id => current_user.id))
    @article.save
    respond_with(@article)
  end

  def update
    @article.update(article_params)
    respond_with(@article)
  end

  def destroy
    @article.destroy
    respond_with(@article)
  end


  def goBack
    session[:return_to] ||= request.referer
    redirect_to session.delete(:return_to)
  end

  def addExchangeItems (currentMatch)
    # get my Articles that the other user liked
    userOfMatch = Article.where(:id => currentMatch.favorite_id).pluck(:user_id).first
    matchesOfOtherUser = Match.where(:user_id => userOfMatch).where(:like => true).all.pluck(:favorite_id)
    myMatchedArticlesByOtherUser = Article.where(:id => matchesOfOtherUser).where(:user_id => current_user.id).all

    # if other User has not liked any of my Articles go back
    if myMatchedArticlesByOtherUser == nil
      goBack
    end

    # get the other user's Articles I liked
    myMatches = Match.where(:user_id => current_user.id).where(:like => true).all.pluck(:favorite_id)
    otherUsersArticlesILiked = Article.where(:user_id => userOfMatch).where(:id => myMatches)

    # if I have not liked any of Other's Articles go back
    if otherUsersArticlesILiked == nil
      goBack
    end

    # iterate through my Articles combine with the Other's i just liked
    myMatchedArticlesByOtherUser.each do |myArticle|
      Exchange.create(
                      :article_id_1 => myArticle.id,
                      :article_id_2 => currentMatch.favorite_id,
                      :user_1 => current_user.id,
                      :user_2 => userOfMatch,
                      :accept_1 => 3,
                      :accept_2 => 3
                      )
    end

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

          #   # Feststellung welcher User ich bin, und welcher der andere ist.
          #   if actualExchange.user_1 == current_user
          #     user_1 = actualExchange.user_1
          #     user_2 = actualExchange.user_2
          #   else
          #     user_1 = actualExchange.user_2
          #     user_2 = actualExchange.user_1
          #   end
          actualExchange = actualExchangeMethod my.id other.id

          # setzen der states
          if actualExchange.accept_1 == 1 && actualExchange.accept_2 == 3
            state = "iAccepted"
          elsif actualExchange.accept_2 == 1 && actualExchange.accept_1 == 3
            state = "accepted"
          elsif actualExchange.accept_1 == 2 && actualExchange.accept_2 == 3
            state = "iRejected"
          elsif actualExchange.accept_2 == 2 && actualExchange.accept_2 == 3
            state = "rejected"
          elsif actualExchange.accept_1 == 1 && actualExchange.accept_2 == 1
            state = "bothAccepted"
          elsif actualExchange.accept_1 == 2 && actualExchange.accept_2 == 2
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


  def actualExchangeMethod (my_id, other_id)

    actualExchange = Exchange.where(:article_id_1 => [my_id,other_id], :article_id_2 => [my_id,other_id])

    # Feststellung welcher User ich bin, und welcher der andere ist. Membervariablen werden Klassenweit geändert
    # if actualExchange.user_1 == current_user
    #   @user_1 = actualExchange.user_1
    #   @user_2 = actualExchange.user_2
    # else
    #   @user_1 = actualExchange.user_2
    #   @user_2 = actualExchange.user_1
    # end

    # return actualExchange

  end

  # Führt je nach Status und gedrückten Button, Datenbankoperationen aus
  def exchangeHandler

    action = params[:action]
    state = params[:state]
    id1 = params[:id1]
    id2 = params[:id2]

    actualExchange = actualExchangeMethod id1 id2

    case state
    when "accepted"
      if action == "yes"
        actualExchange.update_attribute(:accept_2 => 1)
      else
        actualExchange.update_attribute(:accept_2 => 2)
      end
    when "rejected"
      # Remove Match
      # IMPLEMENT
    when "iAccepted"
      # Undo Acception
      actualExchange.update_attribute(:accept_1 => 3)
    when "iRejected"
      # Undo Rejection
      actualExchange.update_attribute(:accept_1 => 3)
    when "bothAccepted"
      if action == "yes"
        #IMPLEMENT
      else
        actualExchange.update_attribute(:accept_1 => 3)
      end
    when "neutral"
      if action == "yes"
        actualExchange.update_attribute(:accept_1 => 1)
      else
        actualExchange.update_attribute(:accept_1 => 2)
      end

    else
    end

  session[:return_to] ||= request.referer
  redirect_to session.delete(:return_to)

  end


  def random
    othersArticles = Article.where.not(:user_id => current_user.id)
    matchedByMe = Match.where(:user_id => current_user.id).pluck(:favorite_id)

    @random_article = othersArticles.where.not(:id => matchedByMe).order("RANDOM()").first

    #@random_article = Article.joins("LEFT OUTER JOIN matches ON articles.id = matches.favorite_id ").all.distinct #.order("RANDOM()")

  end

  def like
    # favorite Others article and like it
    current_user.favorites << Article.find(params[:id])
    currentMatch = Match.where(:user_id => current_user).where(:favorite_id => params[:id]).first
    currentMatch.like = true
    currentMatch.save


    #add Exchange Items
    addExchangeItems currentMatch




    goBack
  end



  private
    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:name, :description, :shippable)
    end
end

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

  def matches
    @currentUser = params[:id]
    ownProducts = Article.where(:user_id => @currentUser)

    likedFavoriteIds = Match.where(:like => true, :user_id => @currentUser).pluck(:favorite_id)
    favoritedProducts = Article.where(:id => likedFavoriteIds)
    favoritedUsers = User.joins(:articles).where(:articles => {:id => favoritedProducts}).distinct

    likeingUsersIds = Match.where(:like => true, :favorite_id => ownProducts).pluck(:user_id)
    likeingUser = User.where(:id => likeingUsersIds)

    #producstFromLikingUser = Article.join(:users).where(:user => {:id => likeingUsersIds}).all

    matchedUsers = (favoritedUsers & likeingUser)

    producstFromMatchedUser = Article.joins(:users).where(:user => {:id => matchedUsers})


    @matches = matchedUsers

    @matchedUsers = (favoritedUsers & likeingUser)

    #productsFromMatchedUser = Article.joins(:users).where(:user => {:id => @matchedUsers})

    @matches = []

    @matchedUsers.each do |matchedUser|

      productsFromMatchedUser = Article.where(:user_id => matchedUser)

      likeingFavoriteIds = Match.where(:like => true, :user_id => matchedUser).pluck(:favorite_id)
      likeingProducts = Article.where(:id => likeingFavoriteIds)

      myMatches = (productsFromMatchedUser & favoritedProducts)

      otherMatches = (ownProducts & likeingProducts)

      array = []

      myMatches.each do |my|
        otherMatches.each do |other|

          hash = { :other => my, :my => other}
          array.push(hash)

        end
      end

      @matches.push(array)

    end



  end

  def random
    othersArticles = Article.where.not(:user_id => current_user.id)
    matchedByMe = Match.where(:user_id => current_user.id).pluck(:favorite_id)

    @random_article = othersArticles.where.not(:id => matchedByMe).order("RANDOM()").first

    #@random_article = Article.joins("LEFT OUTER JOIN matches ON articles.id = matches.favorite_id ").all.distinct #.order("RANDOM()")

  end

  def like

    @article = Article.find(params[:id])
  end

  private
    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:name, :description, :shippable)
    end
end

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
    @article = Article.new(article_params)
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

  # FAV
  # def matches
  #   @matches = Article.find_by_id(params[:id]).partners.all
  # end

  def matches
    currentUser = params[:id]
    ownProducts = Article.where(:user_id => currentUser)

    likedFavoriteIds = Match.where(:like => true, :user_id => currentUser).pluck(:favorite_id)
    favoritedProducts = Article.where(:id => likedFavoriteIds)
    favoritedUsers = User.joins(:articles).where(:articles => {:id => favoritedProducts}).distinct

    likeingUsersIds = Match.where(:like => true, :favorite_id => ownProducts).pluck(:user_id)
    likeingUser = User.where(:id => likeingUsersIds)
    
    #producstFromLikingUser = Article.join(:users).where(:user => {:id => likeingUsersIds}).all

    matchedUsers = (favoritedUsers & likeingUser)

    producstFromMatchedUser = Article.joins(:users).where(:user => {:id => matchedUsers})






















    @matches = matchedUsers
  end

  private
    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:name, :description, :shippable)
    end
end

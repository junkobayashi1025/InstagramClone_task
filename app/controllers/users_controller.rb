class UsersController < ApplicationController
  before_action :authenticate_user, only: [:index]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :favorite]
  before_action :current_user?, only: [:edit]

  def index
   @users = User.all.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
    else
     render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id)
      flash[:success] = "ユーザー「#{@user.name}」を更新しました"
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def destroy
    if @user.destroy
    redirect_to new_session_path
    flash[:danger] = "ユーザー「#{@user.name}」を削除しました"
    end
  end

  def favorite
    @likes = @user.like_posts
  end

  private
  def set_user
   @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation,
                                 :profile_photo, :profile_photo_cache)
  end

  def current_user?
    @user = User.find(params[:id])
    if @user != current_user
    flash[:danger] = "閲覧権限がありません"
    redirect_to users_path
    end
  end

end

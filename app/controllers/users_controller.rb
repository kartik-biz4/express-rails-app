class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]                                        
  
  def new
    @user = User.new    
  end

  def show
    user_id = params[:id]
    @user = User.find(user_id)
    @microposts = @user.microposts.paginate(page: params[:page], :per_page => 5)
  end

  def create
    user_check = User.find_by_email(params[:email])
    if user_check.present?
      flash[:danger] = "User already exists!"
    end
    @user = User.new(params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar))
    Rails.logger.info(@user.errors.inspect) 
    if @user.save
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def index
    @users = User.all.paginate(page: params[:page], :per_page => 5)
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

end

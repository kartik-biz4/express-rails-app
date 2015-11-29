class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save      
      redirect_to root_url
    else
      @feed_items = []
      render 'static_content/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to request.referrer || root_url
  end

  def new
    @micropost = Micropost.new
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end
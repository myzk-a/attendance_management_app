class UsersController < ApplicationController
  include SessionsHelper

  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user,   only: [:edit, :update, :show]
  before_action :admin_user,     only: [:new, :create, :destroy]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params_new)
    if @user.save
      flash[:success] = "ユーザーを登録しました。"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find_by(id: params[:id])
    @is_name_read_only  = true
    @is_email_read_only = true
    if(current_user.admin?)
      if(current_user?(@user))
        @is_email_read_only = false
      else
        @is_name_read_only = false
      end
    end
  end
  
  def update
    @user = User.find_by(id: params[:id])
    if @user.update_attributes(user_params_update)
      flash[:success] = "設定を変更しました"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    user = User.find_by(id: params[:id])
    if !user.admin?
      User.find_by(id: params[:id]).destroy
      flash[:success] = "ユーザーを削除しました"
    end
    redirect_to users_url
  end
  
  
  private
  
    def user_params_new
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def user_params_update
      if current_user.admin?
        user = User.find_by(id: params[:id])
        if current_user?(user)
          params.require(:user).permit(:email, :password, :password_confirmation)
        else
          if params[:user][:password_reset]
            params[:user][:password] = "password"
            params[:user][:password_confirmation] = "password"
            params.require(:user).permit(:name, :password, :password_confirmation)
          else
            params.require(:user).permit(:name)
          end
        end
      else
        params.require(:user).permit(:password, :password_confirmation)
      end
    end
    
    # beforeアクション

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless (current_user?(@user) || current_user.admin?)
    end

end

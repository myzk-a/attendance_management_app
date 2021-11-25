class UsersController < ApplicationController
  include SessionsHelper

  before_action :logged_in_user
  before_action :correct_user,      only: [:edit, :update, :show]
  before_action :admin_user,        only: [:new, :create, :destroy, :import]
  before_action :password_presence, only: [:update]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @works = Work.where(user_id: @user.id)
  end
  
  def new
    @user = User.new
    set_new_page_form_is_indicate
  end
  
  def create
    @user = User.new(user_params_new)
    if @user.save
      flash[:success] = "ユーザーを登録しました。"
      redirect_to @user
    else
      set_new_page_form_is_indicate
      render 'new'
    end
  end
  
  def edit
    @user = User.find_by(id: params[:id])
    set_edit_page_title
    set_edit_page_form_is_indicate
  end
  
  def update
    @user = User.find_by(id: params[:id])
    if @user.update_attributes(user_params_update)
      flash[:success] = "設定を変更しました"
      redirect_to @user
    else
      set_edit_page_title
      set_edit_page_form_is_indicate
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

  def import
    load_csv(User, users_url, signup_url)
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

    def set_edit_page_title
      if current_user.admin?
        if current_user.id == @user.id
          @title = "設定の変更"
        else
          @title = "ユーザー名の変更"
        end
      else
        @title = "パスワードの変更"
      end
    end

    def set_edit_page_form_is_indicate
      if current_user.admin?
        if current_user.id == @user.id
          @is_name_read_only  = true
          @is_email_read_only = false
        else
          @is_name_read_only  = false
          @is_email_read_only = true
        end
      else
        @is_name_read_only  = true
        @is_email_read_only = true
      end
      current_user?(@user) ? @input_password = true : @input_password = false
      (current_user.admin? && @user.id != current_user.id) ? @reset_password = true : @reset_password = false
    end

    def set_new_page_form_is_indicate
      @is_name_read_only = false
      @is_email_read_only = false
      @input_password = true
      @reset_password = false
    end

    # beforeアクション
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless (current_user?(@user) || current_user.admin?)
    end

    #一般ユーザーのパスワード更新時に更新後パスワードが入力されているか確認
    def password_presence
      unless current_user.admin?
        if params[:user][:password] == ""
          @user = User.find_by(id: params[:id])
          flash[:new_password_not_presence] = "パスワードが入力されていません。"
          redirect_to edit_user_path(@user)
        end
      end
    end

end

class UsersController < ApplicationController
  layout 'boxed'
  
  before_filter :select_user , :only =>[:edit,:update,:show,:destroy]

  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.admin = true if User.count==0 #make the first user admin
    if @user.save
      created_message(@user)
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    fail User::PermissionDenied unless @user.can_be_updated?(current_user)
  end
  
  def update
    fail User::PermissionDenied unless @user.can_be_updated?(current_user)
    if @user.update_attributes(params[:user])
      updated_message(@user)
      redirect_to @user
    else
      render :action => 'edit'
    end
  end
  def show
    render 
  end
  
  def index
    @users=User.all(:order => "points desc")
  end

  def destroy
    deleted_message(@user)
    @user.destroy
    redirect_to users_url
  end
  
  private 
  
  def select_user
    @user = User.find(params[:id])
  end
  
end

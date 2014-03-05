class UserSessionsController < ApplicationController
  layout 'boxed'
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = t('actions.logged_in',:name=>@user_session.record.displayed_name)
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = t('actions.logged_out')
    redirect_to root_url
  end
end

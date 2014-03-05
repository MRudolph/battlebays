# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

filter_parameter_logging :password

helper_method :current_user

private

  rescue_from User::NotLoggedIn ,:with => :not_logged_in_page
  rescue_from User::PermissionDenied ,:with => :permission_denied_page
  rescue_from ActiveRecord::RecordNotFound ,:with => :not_found_page
  
def current_user_session
  return @current_user_session if defined?(@current_user_session)
  @current_user_session = UserSession.find
end

def current_user
  return @current_user if defined?(@current_user)
  @current_user = current_user_session && current_user_session.record
end

def current_user!
  current_user || fail(User::NotLoggedIn)
end





  def error_page(body,footer=nil,title=t('errors.500'),status=500)
     render :file => '/layouts/error',:locals=>{:body => body,:footer=>footer,:title=>title}, :status => status,:layout=>true
  end
  
  def not_logged_in_page
    @user_session= UserSession.new
    render :file => '/errors/not_logged_in',:status=> :unauthorized,:layout=>'error'
  end
  def not_found_page(exception)
    render :file => '/errors/not_found',:status=> :not_found,:layout=>'error',:locals=>{:exception => exception }
  end
  def permission_denied_page(exception)
    render :file => '/errors/permission_denied',:status=> :permission_denied,:layout=>'error',:locals=>{:exception => exception }
  end
  
  def created_message(target)
    type= target.class.human_name
    if target.respond_to?(:title_for_messages)
      flash[:notice]= t('actions.created_with_title',:type=>type,:title=>target.title_for_messages)
    else
      flash[:notice]= t('actions.created_without_title',:type=>type)
    end
  end
  def updated_message(target)
    type= target.class.human_name
    if target.respond_to?(:title_for_messages)
      flash[:notice]= t('actions.updated_with_title',:type=>type,:title=>target.title_for_messages)
    else
      flash[:notice]= t('actions.updated_without_title',:type=>type)
    end
  end
  def deleted_message(target)
    type= target.class.human_name
    if target.respond_to?(:title_for_messages)
      flash[:notice]= t('actions.deleted_with_title',:type=>type,:title=>target.title_for_messages)
    else
      flash[:notice]= t('actions.deleted_without_title',:type=>type)
    end
  end
end


class PagesController < ApplicationController
  before_filter :"current_user!",:only=>[:new,:edit,:create]
  before_filter :select_page, :only=>[:edit,:show,:update,:destroy]
  def new
    @page=Page.new
    render :layout=>'boxed'
  end
	
  def index
    @pages=Page.recent
    render :layout=>'boxed'
  end

  def edit
    
  end

  def create
    @page = Page.new(params[:page])
    @page.user = current_user
    
    respond_to do |format|
      if @page.save
        flash[:notice] = 'Du solltest gleich die erste Kachel erstellen.'
        format.html { redirect_to(edit_page_path(@page)) }
      else
        format.html { render :action => "new",:layout=>'boxed' }
      end
    end
  end
  
  def show
    
  end
  
  def destroy
    if @page.can_be_deleted?(current_user)
      deleted_message(@page)
      @page.destroy
    else
      flash[:error] = "Du kannst diese Kachel nicht löschen!"
    end
    redirect_to(:action => :index)
  end
  private
  def select_page
    @page = Page.find(params[:id])
  end
end

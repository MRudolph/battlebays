class TilesController < ApplicationController
  layout 'boxed'
  before_filter :select_tile, :only => [:show,:edit,:update,:destroy]
  def show
    redirect_to @tile.page,:anchor =>TilesHelper.coordinate_id(@tile.x,@tile.y)
  end

  def new
    @tile = Tile.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tile }
    end
  end
  
  
  def edit
     Tile.find(:all,:conditions=>{:image_file_name=>nil })
  end
  
  def create
    @tile = Tile.new(params[:tile])
    @tile.user = current_user
    respond_to do |format|
      if @tile.can_be_created?(current_user) && @tile.save
        format.html { redirect_to :back }
      else
	fail 
      end
    end
  end
  
  def update
    case @tile.classify
    when :reserved
      if params[:tile][:image] #upload
        ok=@tile.can_be_uploaded?(current_user)
        fail User::PermissionDenied unless ok
        @tile.image = params[:tile][:image]
        @tile.activated=@tile.can_be_activated?(current_user) #activate automatically if possible
        if @tile.save
          redirect_to :action=>:show
        else
          @tile.image=nil if @tile.errors.on(:image)
          render :file=>'tiles/edit',:id=>@tile.id,:layout=>'boxed'
       end
      end
    when :uploaded,:activated
      if params[:tile][:activated] #aktivieren/deaktivieren
        ok=@tile.can_be_activated?(current_user)
        fail User::PermissionDenied unless ok
        @tile.activated=params[:tile][:activated]
        @tile.save!
      end		
    end
  end
  
  def destroy
    fail User::PermissionDenied unless @tile.can_be_deleted?(current_user)
    @page=@tile.page
    @tile.destroy
    redirect_to edit_page_path(@page)
  end
  
  private 
  def select_tile
    @tile = Tile.find(params[:id])
  end
  
end

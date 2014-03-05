module TilesHelper
  def classify_tile t
    case t
      when Tile then t.classify
      when true then :reservable
      else :blank
    end
  end
  def is_owner? tile,user
    tile.is_a?(Tile) && tile.user==user
  end
  
  def self.coordinate_id x,y
    "#{x}x#{y}"
  end
  
  def coordinate_id x,y
    TilesHelper.coordinate_id x,y
  end

  def render_table tt,layout,page,&b
    render :partial => "/tiles/tables/#{layout}",:locals => {:table=>tt,:page=>page,:block=>b}
  end


  def link_to_tile_on_page(tile,&b)
    link_to render_table(tile.surroundings,'show_mini',tile.page,&b),page_path(tile.page,:anchor=>coordinate_id(tile.x,tile.y))
  end

  def tilemap_css(w,h)
    dim=[w,h]
    name= "tilemap#{w}x#{h}"
    unless (@csslist||=[]).include?(dim)
      @csslist << dim  
      render :partial=>'/tiles/tables/tilemap_css',:locals=>{:w=>w,:h=>h,:name=>name}
    end
    name
  end
  def remaining_time_of tile
    t=tile.remaining_time
    "<div class='remaining'>" +
      if t>0
        "noch #{distance_of_time_in_words(t,0,true)}"
      else
        "Zeit abgelaufen"
      end +
    "</div>"
  end
#####################################
### haml-tags
#####################################
  def tile_action_box(tile=nil,&b)

    haml_tag :table, {:class=>:"action-box"} do
      if (tile.is_a?(Tile) && (tile.points>0))
        haml_tag :tr do
          haml_tag :td,{:class=>:points} do
            haml_concat tile.points
          end
        end
      end
      haml_tag :tr do
        haml_tag :td,{:class=>:main}, &b
      end
      if (tile.is_a?(Tile))
        haml_tag :tr do
          haml_tag :td,{:class=>:owner} do
            haml_concat user_text_link(tile.user)
          end
        end
      end

    end  
  end
  
  def tile_tag(col,row,tile,show_image =true,style=nil,&b)
    c=classify_tile(tile)
    own = tile.user_id==current_user.id rescue nil
    attrs={:id=>coordinate_id(col,row),:class=>"tile #{c}#{own.nil? ? '' : ' '+ (own ? 'own' : 'foreign')}" }
    attrs[:style]= "background:url(#{tile.image.url(style)}) no-repeat" if show_image  && tile.is_a?(Tile) && tile.image.file?  
    haml_tag :td,attrs,&b
  end
  

  #def render_tile(tile,col,row,page,mode) 
  #  c=classify_tile tile
  #  own=is_owner? tile,current_user
  #  render :partial => "/tiles/#{mode}/#{c}", :locals => {:x=>col,:y=>row,:page=>page,:tile=>tile,:own=>own}
  #end
end

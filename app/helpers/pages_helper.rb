=begin
module TileTableProcessor
  def self.fill tt,page,user=current_user
    left,right,top,bottom=tt.left,tt.right,tt.top,tt.bottom
    (left..right).each do |x|
      (top..bottom).each do |y|
	if tt[x,y].nil?
	  t=page.tiles.new({:x=>x,:y=>y})
          tt[x,y]= t.can_be_created?(user) 
	  t.destroy
	end
      end
    end
    #TODO
    #tt.vertical_range = top..bottom
    #tt.horizontal_range = left..right
  end
  
  def self.create_row tt,row,page,user=current_user
    left,right=tt.left,tt.right
    result=false
    (left..right).each do |x|
      t=page.tiles.new({:x=>x,:y=>row})
      tt[x,row]=res=t.can_be_created?(user)
      result||=res
    end
    result
  end
  def self.create_col tt,col,page,user=current_user
    top,bottom=tt.top,tt.bottom
    result=false
    (top..bottom).each do |y|
      t=page.tiles.new({:x=>col,:y=>y})
      tt[col,y]=res=t.can_be_created?(user)
      result||=res
    end
    result
  end
  def self.expand tt,page,user=current_user,limit=1
    catch :complete do
      offset=tt.top
      (1..limit).each do |x|
        throw :complete unless create_row(tt,offset-x,page,user)
      end
    end
    catch :complete do
      offset=tt.bottom
      (1..limit).each do |x|
        throw :complete unless create_row(tt,offset+x,page,user)
      end
    end    
    catch :complete do
      offset=tt.left
      (1..limit).each do |x| 
        throw :complete unless create_col(tt,offset-x,page,user)
      end
    end    
    catch :complete do
      offset=tt.right
      (1..limit).each do |x| 
        throw :complete unless create_col(tt,offset+x,page,user)
      end
    end   
  end
  
  def self.create_reservations tt,page,user=current_user
    fill tt, page,user
    expand tt,page,user,1
  end
  
end
=end

module PagesHelper
  #def create_reservations_for_page tt,page,user=current_user
  #  TileTableProcessor.create_reservations tt,page,user
  #end
  def create_reservations_for_page existing_tiles
    table=ReservationTileTable.new
    table.store_tiles existing_tiles
    table
  end
end

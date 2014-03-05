class ReservationTileTable < TileTable
  def []=x,y,value
    old=self[x,y]
    
    super
    return if old==value
    if value.is_a?(Tile)
      case value.classify
      when :reserved,:uploaded then set_around(x,y) {|old| old.is_a?(Tile) ? old : false}
      when :activated then set_around(x,y) {|old| (old.nil? || old)}
      end
    end
  end
  def set_around(x,y,&b)
    self[x-1,y]=yield(self[x-1,y])
    self[x+1,y]=yield(self[x+1,y])
    self[x,y-1]=yield(self[x,y-1])
    self[x,y+1]=yield(self[x,y+1])
  end
  def store_tiles tiles
    super
    self[0,0]=true if empty?
  end
end


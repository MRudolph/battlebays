 class Range  

   def intersection(other)  
     raise ArgumentError, 'value must be a Range' unless other.kind_of?(Range)  
     min, max = first, exclude_end? ? max : last  
     other_min, other_max = other.first, other.exclude_end? ? other.max : other.last  
     new_min = self === other_min ? other_min : other === min ? min : nil  
     new_max = self === other_max ? other_max : other === max ? max : nil  
     new_min && new_max ? new_min..new_max : nil  
   end  
   def offset x
     Range.new(self.begin+x,self.end+x,self.exclude_end? )
   end
   

   alias_method :&, :intersection  
 end 
 
class TileTable

   class Row
     include Enumerable
     attr_reader :table,:row
     def initialize(table,row)
       @table,@row=table,row
     end
     def each
       (@table.left..@table.right).each { |x| yield(@table[x,@row]) }
     end
     def each_with_column
       (@table.left..@table.right).each { |x| yield(@table[x,@row],x) }
     end
     def length
      @table.right-@table.left+1
     end
   end


  def initialize
    @xoffset=nil
    @yoffset=nil
    @content=NArray.object(0,0) #empty array
  end
  def empty?
    @content.total==0
  end
  def []x,y
    case
      when empty? then nil
      when x<@xoffset then nil
      when y<@yoffset then nil
      else @content[x-@xoffset,y-@yoffset] rescue nil
      end
  end
  
  def in_table?(x,y)
    ((x>=@xoffset) && (x<@xoffset+@content.shape[0])) && ((y>=@yoffset) && (y<@yoffset+@content.shape[1]))
  end
  
  def []=x,y,value
    case
      when empty?
        @content=NArray.object(1,1)
	@xoffset=x
	@yoffset=y
	@content[0,0]=value
      when in_table?(x,y)
        @content[x-@xoffset,y-@yoffset]=value
      else
	new_left,new_right=[left,x,right].minmax
	new_top,new_bottom=[top,y,bottom].minmax
	resize!(new_left,new_top,new_right,new_bottom)
	@content[x-@xoffset,y-@yoffset]=value
    end
  end
  
  def left;@xoffset;end
  def right;@xoffset+@content.shape[0]-1;end
  def top;@yoffset;end
  def bottom;@yoffset+@content.shape[1]-1;end
  def width;@content.shape[0];end
  def height;@content.shape[1];end
  def resize!(left,top,right,bottom)
     unless empty?
       keepx=(left..right) & (self.left .. self.right)
       keepy=(top..bottom) & (self.top .. self.bottom)
       keep= (keepx && keepy) ? @content[keepx.offset(-self.left),keepy.offset(-self.top)] : nil
     else
       keep=nil
     end
     @content=NArray.object(right-left+1,bottom-top+1)
     @xoffset=left
     @yoffset=top
     @content[keepx.offset(-left),keepy.offset(-top)] =keep if keep
     self
  end
  
  def ensure_minimal_size
    self[0,0]=nil if empty?
  end
  
  def store_tiles tiles
    #x1,x2=tiles.minmax{|t1,t2| t1.x<=> t2.x}
    #y1,y2=tiles.minmax{|t1,t2| t1.y<=> t2.y}
    #resize!(x1.x,y1.y,x2.x,y2.y)
    tiles.each do |tile|
      x,y=tile.x,tile.y
      self[x,y]=tile
    end
    self
  end

  def each_row
    (top..bottom).each { |y| yield(Row.new(self,y))}
  end
  def keep! &b
    l,r,t,b=left,right,top,bottom
    l+=1 while (l<r) && (t..b).none?{|y| yield(self[l,y]) }
    r-=1 while (l<r) && (t..b).none?{|y| yield(self[r,y]) }
    t+=1 while (t<b) && (l..r).none?{|x| yield(self[x,t]) }
    b-=1 while (t<b) && (l..r).none?{|x| yield(self[x,b]) }
    resize!(l,t,r,b)
  end
end

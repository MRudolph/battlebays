class Tile < ActiveRecord::Base
  
  belongs_to :page,:touch=>true
  belongs_to :user


  has_attached_file :image,
			             :url  => "/assets/tiles/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/tiles/:id/:style/:basename.:extension",
		              :styles => { :mini => "50x50>"}
  attr_protected :user_id,:activated,:points,:activated_at
  attr_readonly :x,:y,:page_id
  
##########################Validations
  validates_uniqueness_of :x,:scope => [:y, :page_id]
  validate :dimensions_must_be_right
  validates_presence_of :page
  validate_on_create :no_picture_on_create
##########################Callbacks
  before_save :calculate_points
  after_save :update_user_points
  after_destroy :update_user_points


##########################Scopes
  named_scope :next_to, lambda{|x,y| {:conditions => [ "(x=:x AND (y=:y-1 OR y=:y+1)) OR (y=:y AND  (x=:x-1 OR x=:x+1))",{:x=>x,:y=>y}] } }
  named_scope :around, lambda{|x,y| {:conditions => [ "x>=? AND x<=? AND  y>=? AND y<=?",x-1,x+1,y-1,y+1] } } do
    def to_tile_table(x,y)
      a=TileTable.new
      a.resize!(x-1,y-1,x+1,y+1)
      each {|tile| a[tile.x,tile.y]=tile }
      a
    end
  end

  named_scope :on_page,lambda{|pid| {:conditions => {:page_id => pid }}} 
  named_scope :by_user,lambda{|uid| {:conditions => {:user_id => uid.is_a?(User) ? uid.id : uid }}} 
  named_scope :activated, {:conditions => ["(activated_at IS NOT NULL) AND (image_file_name IS NOT NULL)"]}
  named_scope :inactive, {:conditions => ["(activated_at IS NULL) OR (image_file_name IS NULL)"]}

  named_scope :with_no_image, {:conditions => ["image_file_name IS NULL"] }
  named_scope :with_an_image, {:conditions => ["image_file_name IS NOT NULL "] }
  named_scope :recent,{:conditions => ["(activated_at IS NOT NULL) AND (image_file_name IS NOT NULL)"],:order=>"activated_at desc"} 
  named_scope :with_points, {:conditions => ["points > 0"]}
  named_scope :statistic do
    def uploaded_hours
      count( :group=>"strftime('%H',activated_at)" ) 
    end
    def created_hours
      count( :group=>"strftime('%H',created_at)" ) 
    end
    def hours
      created_result=Array.new(24,0)
      created_hours.each {|h,c| created_result[h.to_i]=c if h }
      uploaded_result=Array.new(24,0)
      uploaded_hours.each {|h,c| uploaded_result[h.to_i]=c if h }
      {:created=>created_result,:uploaded=>uploaded_result,:max=>[created_result.max,uploaded_result.max].max}
    end
  end
  named_scope :with_drawing_time,{:conditions => ["(activated_at IS NOT NULL) AND (created_at IS NOT NULL)"] } do
    def average_drawing_time(*args)
      x=all(*args)
      p x.map {|y| y.id }
      x.sum{|y| y.drawing_time.to_f/x.length}
    end
  end
  def classify
    case
      when !image.file? then :reserved
      when image.file? && !activated then :uploaded
      when image.file? && activated then :activated
    end
  end

  def drawing_time
    self.activated_at-self.created_at rescue nil
  end


  def dimensions_must_be_right
    return true unless image.file? #nur reservierung
    
    begin
      geom = Geometry.from_file image.to_file
      w,h=page.width,page.height
      errors.add(:image,errors.generate_message(:image,:wrong_dimensions,{:width=>w,:height=>h})) unless  (geom.width==w) &&(geom.height==h)
    rescue Paperclip::NotIdentifiedByImageMagickError
      errors.add(:image,errors.generate_message(:image,:no_image))
    end
  end
  
  
  def no_picture_on_create
    errors.add(:image,t('tiles.must_reserve')) if image.file?
  end
  
  def neighbours
    Tile.on_page(page_id).next_to(x,y)
  end 

  def surroundings
    Tile.on_page(page_id).around(x,y).to_tile_table(x,y)
  end




  def activated
    !!activated_at
  end
  
  def activated= value
    p value
    self.activated_at = (value ? Time.now : nil)
  end

  def remaining_time(from=Time.now)
    return nil unless :reserved==classify
    rem=self.created_at-from+3.days 
    rem < 0 ? 0 : rem
  end
#================================================================
  def can_be_deleted?(user)
    return true if user.try(:admin)||self.page.moderators.include?(user) #admins or moderators can delete pictures every time
    case classify
    when :reserved
      (self.user == user) || #user can delete his tiles
      (user && remaining_time==0) #any user can delete if time expired
    when :uploaded
      (self.user == user) #not actived tiles can be withdrawn
    end
  end

  def can_be_uploaded?(user)
    (!image.file? || !activated) && (self.user == user) #owner can upload pictures
  end
  def can_be_edited?(user)
     (self.user == user) || user.try(:admin)||self.page.moderators.include?(user)
  end

  def can_be_created?(user)
     page.tile_can_be_created?(self,user)
  end
  
  def can_be_activated?(user)
     page.tile_can_be_activated?(self,user)
  end

#===================================================================
  private
  def calculate_points
    self.points=page.tile_calculate_points(self)
    true
  end
  
  def update_user_points
    user.update_points! if user
    true
  end
end

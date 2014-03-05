class Page < ActiveRecord::Base
  include Rules::PageTile
  has_many :tiles
  belongs_to :user
  has_many :users,:through=>:tiles
  attr_readonly :width,:height,:rules,:user_id
  
  serialize :rules,Hash

  validate_on_create :check_rules
  before_save :create_rules
  validates_presence_of :title
  validates_numericality_of :width, :only_integer => true
  validates_inclusion_of :width, :in => 150..600
  validates_numericality_of :height, :only_integer => true
  validates_inclusion_of :height, :in => 150..600
  
  named_scope :recent,{:order => "updated_at desc"}
  def settings= value
    fail unless new_record?
    r={}
    min,max=parse_limit(value[:limit][:left]),parse_limit(value[:limit][:right])
    r[:horz] = {:enabled=>true,:min=>min,:max=>max} if min || max
    min,max=parse_limit(value[:limit][:top]),parse_limit(value[:limit][:botttom])
    r[:vert] = {:enabled=>true,:min=>min,:max=>max} if min || max
  end
  
  def settings
  end
  
  def check_rules
  end
  
  def create_rules
    rules ||= {}
  end
  
  def tile_table
    a=TileTable.new
    a.store_tiles tiles.all
    a.ensure_minimal_size
    a
  end
  

  def moderators
    [user]
  end

  def can_be_deleted?(user)
    (self.user == user) || user.try(:admin)
  end
  def can_be_updated?(user)
    true
  end

  def mini_dimensions
    dim=[width,height]
    factor=50.0/dim.max
    dim.map!{|x| (x*factor).round }
  end
  
  def moderated
    rules && rules[moderated]
  end

  def moderated=val
    rules||={}
    rules[:moderated]=!!val
  end
private

  def parse_limit txt
    case txt
      when "nil" then nil
      when /[0-9]+/ then txt.to_i
    end
  end
  

  

  
end

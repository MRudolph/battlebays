class User < ActiveRecord::Base
  class NotLoggedIn < StandardError;end
  class PermissionDenied < StandardError;end
  acts_as_authentic
  attr_protected :points,:admin
  attr_readonly :username
  named_scope :better_than, lambda { |points| {:conditions =>["points > :p",{:p=>points}]}}
  named_scope :worse_than, lambda { |points| {:conditions =>["points < :p",{:p=>points}] }}
  named_scope :with_score, lambda { |points| {:conditions =>["points = :p", {:p=>points}] }}
  named_scope :other_than, lambda {|user| {:conditions=>["id<>:id",{:id=>user.id}]}}

  has_attached_file :photo,:styles => { :profile => "150x200>",
                                                       :thumb => "45x60>"  },
			             :url  => "/assets/users/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension"
  
  has_many :tiles, :dependent=>:nullify
  has_many :pages
  has_many :contributed_pages,:source=>:page,:through=>:tiles,:uniq=>true
  
  def can_be_deleted?(user)
    (user==self) || (user.try(:admin))
  end
  def can_be_updated?(user)
    (user==self) || (user.try(:admin))
  end
  
  
  def recent_tiles(limit)
    Tile.by_user(self).recent.all(:limit=>limit)
  end
  
  def point_distribution
    tiles.with_points.count(:group=>:points)
  end

  def rank
    User.better_than(points).count(:points,:distinct=>true)+1
  end
  def on_better_rank
    User.with_score(User.better_than(points).minimum(:points))
  end
  def on_worse_rank
    User.with_score(User.worse_than(points).maximum(:points))
  end  
  def on_same_rank
    User.with_score(points).other_than(self)
  end
  
  def displayed_name
    shown? ? shown : username
  end

  def update_points!
    self.points = tiles.sum(:points)
    self.save!
  end
  
end

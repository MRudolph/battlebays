class Article < ActiveRecord::Base

  
  belongs_to :user
  attr_protected :user_id
  validates_length_of :title,:within => 3..200
  validates_length_of :content,:within => 3..100_000
  def can_be_created?(user)
    can_be_updated?(user)
  end
  def can_be_updated?(user)
    user.try(:admin)
  end
  def can_be_deleted?(user)
    can_be_updated?(user)
  end
end

module UsersHelper

  def user_text_link (user)
    if user
      link_to h(user.displayed_name), user
    else
      t('users.missing')
    end
  end
  
  def user_photo_link(user,size=nil)
    if user
      link_to image_tag(user.photo.url(size),:title=>user.displayed_name),user
    else
      ""
    end
  end

  def create_groups_from_sorted_users(users,n=3)
    return [] if users.empty?
    result=[]
    current_users=[]
    current_score=nil
    users.each do |user|
      current_score=user.points if current_score.nil?
      if current_score == user.points
        current_users << user
      else
        result << current_users
        return result if result.length==n
        current_users=[user]
        current_score=user.points
      end
    end
    result << current_users
    result
  end
end

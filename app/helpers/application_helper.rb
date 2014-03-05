# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def parent_layout(layout)
    @content_for_layout = self.output_buffer
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def context_menu_for resource
    render :partial=>'layouts/context',:object=>resource
  end

  def boxed_error_messages_for obj
    render :partial=>'errors/boxed_error',:object=>obj
  end

end

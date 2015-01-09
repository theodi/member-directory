class DocumentRenderer
  def initialize
    unless @view
      @view = ActionView::Base.new(ActionController::Base.view_paths, {})
      class << @view
        include ApplicationHelper
      end
    end
    @view
  end

  def terms_and_conditions(member)
    presenter = IndividualPresenter.new(member)
    @view.render :partial => 'devise/registrations/individual_terms', locals: { member: presenter }, layout: 'layouts/email_attachment'
  end

end

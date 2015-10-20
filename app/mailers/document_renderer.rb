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
    @view.render :partial => partial(member), locals: { member: presenter }, layout: 'layouts/email_attachment'
  end

  def partial(member)
    case
    when member.individual?
      'devise/registrations/individual_terms'
    when member.student?
      'devise/registrations/student_terms'
    end
  end
end

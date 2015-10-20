class DocumentRenderer
  attr_reader :member

  def initialize(member)
    @member = member
    unless @view
      @view = ActionView::Base.new(ActionController::Base.view_paths, {})
      class << @view
        include ApplicationHelper
      end
    end
    @view
  end

  def terms_and_conditions
    presenter = IndividualPresenter.new(member)
    @view.render :partial => partial, locals: { member: presenter }, layout: 'layouts/email_attachment'
  end

  def partial
    case
    when member.individual?
      'devise/registrations/individual_terms'
    when member.student?
      'devise/registrations/student_terms'
    end
  end
end

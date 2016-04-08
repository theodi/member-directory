module DeviseMailerHelper

  def member_account_link(member)
    if member.reset_password_token
      link_to 'your member account', edit_password_url(member, :reset_password_token => member.reset_password_token)
    else
      link_to 'your member account', new_member_session_url(membership_number: member.membership_number)
    end
  end

end

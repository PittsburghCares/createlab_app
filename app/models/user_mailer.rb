class UserMailer < ActionMailer::Base
  def signup_notification(user)
    send_to_self = true
    setup_email(user,send_to_self)
    @subject    += 'Account activation request.'
    @body[:url]  = "http://#{self.default_url_options[:host]}/activate/#{user.activation_code}"
  end

  def activation(user)
    send_to_self = false
    setup_email(user,send_to_self)
    @subject    += 'Your account has been activated.'
    @body[:url]  = "http://#{self.default_url_options[:host]}/management"
  end

  def forgot_password(user)
    send_to_self = false
    setup_email(user,send_to_self)
    @subject    += 'You have requested to change your password.'
    @body[:url]  = "http://#{self.default_url_options[:host]}/reset_password/#{user.password_reset_code}" 
  end

  def reset_password(user)
    send_to_self = false
    setup_email(user,send_to_self)
    @subject    += 'Your password has been reset.'
  end

  protected
    def setup_email(user, send_to_self)
      @recipients  = send_to_self ? $main_outgoing_email : "#{user.email}"
      @from        = $main_outgoing_email
      @subject     = $organization_name + " - "
      @sent_on     = Time.now
      @body[:user] = user
    end
end

class Mailer < ActionMailer::Base
  def contact_message(name,sender_email,message,project,receiver_email)
    send_to_self = true
    setup_email(name,sender_email,message,project,receiver_email,send_to_self)
    @subject    += "#{ActionController::Base.helpers.sanitize(name)} has sent an inquiry about #{ActionController::Base.helpers.sanitize(project)}"
    @body[:message]  = message
    @name = name
    @project 	   = project
    @sender_email = sender_email
    @receiver_email = receiver_email
  end

  protected
    def setup_email(name,sender_email,message,project,receiver_email,send_to_self)
      @recipients  = send_to_self ? receiver_email : "#{user.email}"
      @from        = sender_email
      @subject     = ""
      @sent_on     = Time.now
    end
end

class MemberMailer < ActionMailer::Base
  #include AMQPQueue::Mailer

  #default from: ENV['SYSTEM_MAIL_FROM']
    default from: 'example@peatio.com'


  def notify_signin(member_id)
    member = Member.find member_id
    mail to: member.email
  end
end

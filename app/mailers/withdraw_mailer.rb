class WithdrawMailer < ActionMailer::Base
  #include AMQPQueue::Mailer

  #default from: ENV['SYSTEM_MAIL_FROM']
   default from: 'example@peatio.com'

  def withdraw_state(withdraw_id)
    @withdraw = Withdraw.find withdraw_id
    mail :to => @withdraw.member.email
  end
end

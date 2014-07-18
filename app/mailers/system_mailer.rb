class SystemMailer < ActionMailer::Base
  #include AMQPQueue::Mailer

  #default from: ENV["SYSTEM_MAIL_FROM"], to: ENV["SYSTEM_MAIL_TO"]
  default from: 'example@peatio.com', to: 'example@peatio.com'

  def balance_warning(amount, balance)
    @amount = amount
    @balance = balance
    mail :subject => "satoshi balance warning"
  end

  def trade_execute_error(payload, error, backtrace)
    @payload   = payload
    @error     = error
    @backtrace = backtrace
    mail subject: "Trade execute error: #{@error}"
  end

end

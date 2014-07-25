module Concerns
  module OrderCreation
    extend ActiveSupport::Concern

    def order_params(order)
      params[order][:bid] = params[:bid]
      params[order][:ask] = params[:ask]
      params[order][:state] = Order::WAIT
      params[order][:currency] = params[:market]
      params[order][:member_id] = current_user.id
      params[order][:volume] = params[order][:origin_volume]
      params[order][:source] = 'Web'
      params.require(order).permit(
        :bid, :ask, :currency, :price, :source,
        :state, :origin_volume, :volume, :member_id, :ord_type)
    end

    def order_submit
      begin
        if  ( check_credit > 0 ) || is_admin?
          Ordering.new(@order).submit
          render status: 200, json: success_result
        else
          render status: 500, json: credit_error_result(@order)
        end 
      rescue
        Rails.logger.warn "Member id=#{current_user.id} failed to submit order: #{$!}"
        Rails.logger.warn params.inspect
        #Rails.logger.warn $!.backtrace[0,20].join("\n")
        render status: 500, json: error_result(@order.errors)
      end
    end

    def success_result
      Jbuilder.encode do |json|
        json.result true
        json.message I18n.t("private.markets.show.success")
      end
    end

    def error_result(args)
      Jbuilder.encode do |json|
        json.result false
        json.message 'I18n.t("private.markets.show.error")'
        json.errors args
      end
    end

    def credit_error_result(args)
      Jbuilder.encode do |json|
        json.result false
        json.message 'you have not sufficient credit balance .'
        json.errors args
      end
    end

    def check_credit
      if !current_user.credits.blank?
          if params[:controller]=='private/order_asks'
            btc_credit =  calculate_btc_credit
            return btc_credit
          else
             ltc_credit =  calculate_ltc_credit
             return ltc_credit
          end
      else
        return 0
      end
    end


 def calculate_btc_credit
  btc_credit = current_user.credits.collect{ |p| p.amount if p.currency=="btc"}.try(:flatten).try(:compact).try(:sum)
  btc_credit =  (btc_credit - current_user.accounts.last.balance)
  return btc_credit

 end

  def calculate_ltc_credit
    ltc_credit =  current_user.credits.collect{ |p| p.amount if p.currency=="ltc"}.try(:flatten).try(:compact).try(:sum)
    ltc_credit =  (ltc_credit - current_user.accounts.first.balance)
    return ltc_credit

 end

  end
end

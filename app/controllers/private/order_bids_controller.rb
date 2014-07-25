module Private
  class OrderBidsController < BaseController
    include Concerns::OrderCreation

    def create
    	#if !current_user.credits.blank?
          @order = OrderBid.new(order_params(:order_bid))
          order_submit
      # else
      # 	redirect_to :back,alert: ('You have not suffiecient credit balance') and return

      #end
    end
  end
end

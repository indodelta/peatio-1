class CreditsController < ApplicationController

  def new
  	@credit = Credit.new
  end
  def create
  	current_user.credits.create(params[:credit].permit!)
  	redirect_to :back,notice: ('credit sucessfully created') and return
  end

  def delete
  	@credit=Credit.find(params[:id])
  	@credit.destroy
  	redirect_to :back,notice: ('credit sucessfully Deleted') and return
  end
end

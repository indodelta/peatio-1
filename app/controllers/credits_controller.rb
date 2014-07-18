class CreditsController < ApplicationController

  def new
  	@credit = Credit.new
  end
  def create
  	current_user.credits.create(params[:credit].permit!)
  	redirect_to :back,notice: ('credit sucessfully created') and return
  end
end

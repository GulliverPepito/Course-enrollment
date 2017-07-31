class UsersController < ApplicationController
  def update
  	@user = current_user
  	message = if @user.update_attributes(user_params)
  		"Saved data!"
  	else 
  		"Unable to save data!"
  	end
  	redirect_to root_url, notice: message
  end

  private

  	def user_params
  		params.require(:user).permit(
  			:manual_first_name, :manual_last_name
  		)
  	end
end

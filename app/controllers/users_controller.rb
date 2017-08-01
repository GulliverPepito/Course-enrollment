class UsersController < ApplicationController
  def update
  	@user = current_user
  	if verify_recaptcha(model: @user) && @user.update_attributes(user_params)
      message = if @user.repo_order
          "Updated data!"
        else
          @user.setup_repository
          "Creating repository!"
        end
  	else
  		message = "Unable to save data!"
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

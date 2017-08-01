# frozen_string_literal: true

class UsersController < ApplicationController
  def update
    @user = current_user
    if verify_recaptcha(model: @user) && @user.update_attributes(user_params)
      message = @user.repo_order ? 'Updated data!' : 'Creating repository!'
      @user.setup_repository
    else
      message = 'Unable to save data!'
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

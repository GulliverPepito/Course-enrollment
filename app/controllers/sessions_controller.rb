class SessionsController < ApplicationController

	def create
		render :plain => request.env['omniauth.auth']
	end
end

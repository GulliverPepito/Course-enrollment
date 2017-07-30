class SessionsController < ApplicationController

	def create
		auth = request.env['omniauth.auth']
		unless @auth = Identity.find_from_hash(auth)
			# Create a new user or add an auth to existing user, depending on
			# whether there ir already a user signed in
			@auth = Identity.create_from_hash(auth, current_user)
		end
		# Log the authorizing user in
		self.current_user = @auth.user

		render :plain => "Hi #{current_user.name} (#{current_user.nickname})"
	end
end

Rails.application.config.middleware.use OmniAuth::Builder do
	provider :github, Rails.application.secrets.GITHUB_CLIENT_ID, Rails.application.secrets.GITHUB_CLIENT_SECRET
	provider :google_oauth2, Rails.application.secrets.GOOGLE_CLIENT_ID, Rails.application.secrets.GOOGLE_CLIENT_SECRET,
	{
		name: 'google',
		prompt: 'select_account',
		hd: 'uc.cl',
		skip_jwt: true,
		verify_iss: false
	}
end

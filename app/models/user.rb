class User < ApplicationRecord
	has_many :identities

	def self.create_from_hash!(hash)
		if hash['provider'] == 'github'
			create(User.github_attributes(hash))
		elsif hash['provider'] == 'google'
			create(User.google_attributes(hash))
		end
	end

	def update_from_hash!(hash)
		if hash['provider'] == 'github'
			update(User.github_attributes(hash))
		elsif hash['provider'] == 'google'
			update(User.google_attributes(hash))
		end
	end

	private

		def self.github_attributes(hash)
			{
				:github_nickname => hash['info']['nickname'],
				:github_name => hash['info']['name'],
				:github_email => hash['info']['email'],
				:github_image_url => hash['info']['image'],
				:github_token => hash['credentials']['token']
			}
		end

		def self.google_attributes(hash)
			{
				:google_name => hash['info']['name'],
				:google_email => hash['info']['email'],
				:google_image => hash['info']['image'],
				:google_token => hash['credentials']['token']
			}
		end
end

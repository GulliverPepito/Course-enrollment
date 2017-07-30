class User < ApplicationRecord
	has_many :identities

	def self.create_from_hash!(hash)
		logger.debug hash.to_yaml
		create(
			:nickname => hash['info']['nickname'],
			:name => hash['info']['name'],
			:email => hash['info']['email'],
			:image_url => hash['info']['image'],
			:token => hash['credentials']['token']
		)
	end
end

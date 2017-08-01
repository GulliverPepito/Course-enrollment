class User < ApplicationRecord
	include ApplicationHelper

	has_many :identities, :dependent => :destroy

	def setup_repository
		# Protect this
		if !self.repo_ready && self.update_attributes(:repo_order => true)
			Thread.new do
				fullname = "#{manual_first_name} #{manual_last_name}"
				status, repo_name, repo_url = create_repository(github_nickname, fullname)
				return unless status == 201
				status, content = import_repository(github_nickname)
				return unless status == 201
				status, content = add_collaborator(github_nickname)
				return unless status == 201
				self.update_attributes(
					:repo_ready => true,
					:repo_name => repo_name,
					:repo_url => repo_url,
				)
			end
		end
	end

	def ready_for_repo_creation
		self.google_email && self.github_nickname && !self.repo_order
	end

	def creating_repo
		self.google_email && self.github_nickname && self.repo_order && !self.repo_ready
	end

	def repo_is_ready
		self.google_email && self.github_nickname && self.repo_order && self.repo_ready
	end

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

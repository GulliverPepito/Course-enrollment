require 'net/http'
require 'uri'
require 'json'

module ApplicationHelper

	GITHUB_OAUTH_TOKEN = Rails.application.secrets.GITHUB_OAUTH_TOKEN
	COURSE_ORGANIZATION = Rails.configuration.COURSE_ORGANIZATION
	TEMPLATE_URL = Rails.configuration.TEMPLATE_URL

	def create_repository(student_username, student_fullname)
		# https://developer.github.com/v3/repos/#create
		uri = "https://api.github.com/orgs/#{COURSE_ORGANIZATION}/repos"
		header = {
			'Authorization': "token #{GITHUB_OAUTH_TOKEN}",
			'Content-Type': 'application/json',
		}
		body = {
			'name': repo_name(student_username),
			'description': "Repositorio para #{student_fullname}",
			'private': true,
			'has_projects': false,
			'has_wiki': false,
		}
		status, content = http_request_to(uri: uri, method: 'post', header: header, body: body)
		return status, content.fetch("full_name"), content.fetch("html_url")
	end

	def import_repository(student_username)
		# https://developer.github.com/v3/migration/source_imports/#start-an-import
		student_repository = repo_name(student_username)
		uri = "https://api.github.com/repos/#{COURSE_ORGANIZATION}/#{student_repository}/import"
		header = {
			'Accept': 'application/vnd.github.barred-rock-preview',
			'Authorization': "token #{GITHUB_OAUTH_TOKEN}",
			'Content-Type': 'application/json',
		}
		body = {
			'vcs_url': TEMPLATE_URL,
			'vcs': 'git',
		}
		status, content = http_request_to(uri: uri, method: 'put', header: header, body: body)
		return status, content
	end

	def add_collaborator(student_username)
		# https://developer.github.com/v3/repos/collaborators/#add-user-as-a-collaborator
		student_repository = repo_name(student_username)
		uri = "https://api.github.com/repos/#{COURSE_ORGANIZATION}/#{student_repository}/collaborators/#{student_username}"
		header = {
			'Accept': 'application/vnd.github.swamp-thing-preview+json',
			'Authorization': "token #{GITHUB_OAUTH_TOKEN}",
			'Content-Type': 'application/json',
		}
		body = {
			'permission': 'push'
		}
		status, content = http_request_to(uri: uri, method: 'put', header: header, body: body)
		return status, content
	end

	private

		def http_request_to(uri:, method: 'get', header: {}, body: {})
			# Resource identification
			uri = URI.parse(uri)
			# HTTP objects
			http = Net::HTTP.new(uri.host, uri.port)
			http.use_ssl = (uri.scheme == "https")
			request = case method
				when 'get'
					Net::HTTP::Get.new(uri.request_uri, header)
				when 'post'
					Net::HTTP::Post.new(uri.request_uri, header)
				when 'put'
					Net::HTTP::Put.new(uri.request_uri, header)
				when 'delete'
					Net::HTTP::Delete.new(uri.request_uri, header)
				when 'patch'
					Net::HTTP::Patch.new(uri.request_uri, header)
				else
					raise "Unknown method (Use 'get', 'post', 'put', 'delete', 'patch')"
				end
			request.body = body.to_json
			# Process response
			if method == 'put'
			end
			response = http.request(request)
			if method == 'put'
			end
			return response.code.to_i, JSON.parse(response.body)
		end

		def repo_name(student_username)
			"#{student_username}-iic2233-2017-2"
		end
end

# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

module ApplicationHelper
  GITHUB_OAUTH_TOKEN = Rails.application.secrets.GITHUB_OAUTH_TOKEN
  GITHUB_ORG = Rails.configuration.custom['github']['organization']
  GITHUB_ORG_TYPE = Rails.configuration.custom['github']['organization_type']
  GITHUB_MEMBER_TEMPLATE = Rails.configuration.custom['github']['template_url']
  GITHUB_REPO_OPTIONS = Rails.configuration.custom['github']['repository']
  # rubocop:disable MethodLength
  def create_repository(student_username, student_fullname)
    # https://developer.github.com/v3/repos/#create
    uri = if GITHUB_ORG_TYPE == 'organization'
            "https://api.github.com/orgs/#{GITHUB_ORG}/repos"
          else
            'https://api.github.com/user/repos'
          end
    header = {
      'Authorization': "token #{GITHUB_OAUTH_TOKEN}",
      'Content-Type': 'application/json',
    }
    body = {
      'name': repo_name(student_username),
      'description': repo_description(student_fullname),
      'private': GITHUB_REPO_OPTIONS['private'],
      'has_projects': GITHUB_REPO_OPTIONS['has_projects'],
      'has_wiki': GITHUB_REPO_OPTIONS['has_wiki'],
    }
    # rubocop:disable LineLength
    s, c = http_request_to(uri: uri, http_method: 'post', header: header, body: body)
    # rubocop:enable LineLength
    [s, c.fetch('full_name'), c.fetch('html_url')]
  end
  # rubocop:enable MethodLength

  def import_repository(student_username)
    # https://developer.github.com/v3/migration/source_imports/#start-an-import
    student_repository = repo_name(student_username)
    uri = format("https://api.github.com/repos/#{owner}/#{repo}/import",
                 owner: GITHUB_ORG,
                 repo: student_repository)
    header = {
      'Accept': 'application/vnd.github.barred-rock-preview',
      'Authorization': "token #{GITHUB_OAUTH_TOKEN}",
      'Content-Type': 'application/json',
    }
    body = {
      'vcs_url': GITHUB_MEMBER_TEMPLATE,
      'vcs': 'git',
    }
    http_request_to(uri: uri, http_method: 'put', header: header, body: body)
  end

  def add_collaborator(student_username)
    # https://developer.github.com/v3/repos/collaborators/#add-user-as-a-collaborator
    student_repository = repo_name(student_username)
    # rubocop:disable LineLength
    uri = format("https://api.github.com/repos/#{owner}/#{repo}/collaborators/#{username}",
                 owner: GITHUB_ORG,
                 repo: student_repository,
                 username: student_username)
    # rubocop:enable LineLength
    header = {
      'Accept': 'application/vnd.github.swamp-thing-preview+json',
      'Authorization': "token #{GITHUB_OAUTH_TOKEN}",
      'Content-Type': 'application/json',
    }
    body = {
      'permission': GITHUB_REPO_OPTIONS['member_permission'],
    }
    http_request_to(uri: uri, http_method: 'put', header: header, body: body)
  end

  private

    def http_request_to(uri:, http_method: 'get', header: {}, body: {})
      # Resource identification
      uri = URI.parse(uri)
      # HTTP objects
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')
      request = request_object(http_method, uri, header)
      request.body = body.to_json
      response = http.request(request)
      [response.code.to_i, JSON.parse(response.body)]
    end

    def request_object(http_method, uri, header)
      case http_method
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
        raise 'Unknown HTTP method'
      end
    end

    def repo_name(student_username)
      format("#{prefix}#{student_username}#{suffix}",
             prefix: GITHUB_REPO_OPTIONS['name']['prefix'],
             student_username: student_username,
             suffix: GITHUB_REPO_OPTIONS['name']['suffix'])
    end

    def repo_description(student_fullname)
      format("#{prefix}#{student_fullname}#{suffix}",
             prefix: GITHUB_REPO_OPTIONS['description']['prefix'],
             student_fullname: student_fullname,
             suffix: GITHUB_REPO_OPTIONS['description']['suffix'])
    end
end

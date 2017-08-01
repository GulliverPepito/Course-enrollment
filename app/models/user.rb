# frozen_string_literal: true

class User < ApplicationRecord
  include ApplicationHelper

  has_many :identities, dependent: :destroy

  def setup_repository
    return false unless !repo_order && update_attributes(repo_order: true)
    setup_repository_in_background
    true
  end

  # rubocop:disable Metrics/AbcSize
  def setup_repository_in_background
    Thread.new do
      fullname = "#{manual_first_name} #{manual_last_name}"
      status, repo_name, repo_url = create_repository(github_nickname, fullname)
      return unless status == 201
      status, = import_repository(github_nickname)
      return unless status == 201
      status, = add_collaborator(github_nickname)
      return unless status == 201
      sleep 10
      update_attributes(
        repo_ready: true,
        repo_name: repo_name,
        repo_url: repo_url
      )
    end
  end
  # rubocop:enable Metrics/AbcSize

  def ready_for_repo_creation
    google_email && github_nickname && !repo_order
  end

  def creating_repo
    google_email && github_nickname && repo_order && !repo_ready
  end

  def repo_is_ready
    google_email && github_nickname && repo_order && repo_ready
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

  def self.github_attributes(hash)
    {
      github_nickname: hash['info']['nickname'],
      github_name: hash['info']['name'],
      github_email: hash['info']['email'],
      github_image_url: hash['info']['image'],
      github_token: hash['credentials']['token'],
    }
  end

  def self.google_attributes(hash)
    {
      google_name: hash['info']['name'],
      google_email: hash['info']['email'],
      google_image: hash['info']['image'],
      google_token: hash['credentials']['token'],
    }
  end
end

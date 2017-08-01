# frozen_string_literal: true

class Identity < ApplicationRecord
  belongs_to :user
  validates :user_id, :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def self.find_from_hash(hash)
    find_by(provider: hash['provider'], uid: hash['uid'])
  end

  def self.create_from_hash(hash, user = nil)
    logger.debug hash.to_yaml
    if user
      user.update_from_hash!(hash)
    else
      user = User.create_from_hash!(hash)
    end
    Identity.create(
      user: user,
      uid: hash['uid'],
      provider: hash['provider']
    )
  end
end

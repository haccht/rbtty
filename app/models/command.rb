require 'securerandom'

class Command < ApplicationRecord
  validates :text, presence: true
  validates :uuid, uniqueness: true
  paginates_per 25

  before_create do
    self.uuid = SecureRandom.urlsafe_base64(16)
    self.accessed_at = Time.now
  end

  def to_param
    self.uuid
  end

  def gotty_url
    url = URI(ENV.fetch('GOTTY_URL') { 'http://127.0.0.1:8080' })
    url.query = "arg=#{self.uuid}"
    url.to_s
  end
end

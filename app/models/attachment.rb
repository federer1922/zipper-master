# frozen_string_literal: true

class Attachment < ApplicationRecord
  scope :with_current_user, ->(user) { where(user: user).order(created_at: :desc) }

  has_one_attached :file
  belongs_to :user

  paginates_per 5
end

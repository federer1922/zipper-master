# frozen_string_literal: true

class Attachment < ApplicationRecord
  has_one_attached :file
end

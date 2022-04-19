# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachment, type: :model do
  describe 'associations' do
    it { should have_one_attached(:file) }
    it { should belong_to(:user) }
  end
end

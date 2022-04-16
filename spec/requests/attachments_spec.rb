# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Attachments', type: :request do
  let(:original_file1) { fixture_file_upload(Rails.root.join('spec', 'data', 'old_macdonald.txt'), 'text/plain') }
  let(:original_file2) { fixture_file_upload(Rails.root.join('spec', 'data', '5_little_monkeys.txt'), 'text/plain') }

  describe 'GET /index' do
    it 'returns http success' do
      get root_path

      expect(response).to have_http_status(:success)
    end

    it 'has correct body' do
      post attachments_path, params: { attachment: { file: original_file1 } }
      post attachments_path, params: { attachment: { file: original_file2 } }

      get root_path

      attachment1 = Attachment.first
      attachment2 = Attachment.last

      expect(response.body).to include attachment1.name
      expect(response.body).to include attachment2.name
    end
  end

  describe 'GET /new' do
    it 'returns http success' do
      get new_attachment_path

      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    it 'shows notice' do
      post attachments_path, params: { attachment: { file: original_file1 } }

      expect(response).to have_http_status(:success)
      expect(flash[:notice]).to eq 'File successfully zipped'
    end

    it 'compresses file with password' do
      post attachments_path, params: { attachment: { file: original_file1 } }

      zipped_file_content = Attachment.last.file.download

      match_password = response.body.to_s.match(/Password:\n(.+)/)
      password = match_password[1]

      File.open('tmp/file.zip', 'wb') { |file| file.write(zipped_file_content) }

      `unzip -o -P #{password} tmp/file.zip -d tmp`

      decompressed_file_content = File.read('tmp/old_macdonald.txt')
      original_file1.rewind

      expect(decompressed_file_content).to eq original_file1.read
    end
  end
end

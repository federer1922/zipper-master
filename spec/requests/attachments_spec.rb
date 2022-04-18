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
      post attachments_path, params: { files: [original_file1], zip_name: 'zip1' }
      post attachments_path, params: { files: [original_file2], zip_name: 'zip2' }

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
    context 'with chosen files' do
      context 'without entered zip name' do
        it 'returns http success' do
          post attachments_path, params: { files: [original_file1, original_file2] }

          expect(response).to have_http_status(:success)
        end

        it 'creates a new Attachment' do
          expect do
            post attachments_path, params: { files: [original_file1, original_file2] }
          end.to change(Attachment, :count).by(1)
        end

        it 'shows notice' do
          post attachments_path, params: { files: [original_file1, original_file2] }

          expect(response).to have_http_status(:success)
          expect(flash[:notice]).to eq 'File successfully zipped'
        end

        it 'has default file name' do
          post attachments_path, params: { files: [original_file1, original_file2] }

          expect(Attachment.last.name).to eq 'files.zip'
        end

        it 'compresses mulitple files with password' do
          post attachments_path, params: { files: [original_file1, original_file2] }

          zipped_file_content = Attachment.last.file.download

          match_password = response.body.to_s.match(/Password:\n(.+)/)
          password = match_password[1]

          File.open('tmp/files.zip', 'wb') { |file| file.write(zipped_file_content) }

          `unzip -o -P #{password} tmp/files.zip -d tmp`

          decompressed_file1_content = File.read('tmp/old_macdonald.txt')
          decompressed_file2_content = File.read('tmp/5_little_monkeys.txt')
          original_file1.rewind
          original_file2.rewind

          expect(decompressed_file1_content).to eq original_file1.read
          expect(decompressed_file2_content).to eq original_file2.read
        end
      end

      context 'with entered zip name' do
        it 'creates a new Attachment' do
          expect do
            post attachments_path, params: { files: [original_file1, original_file2], zip_name: 'rhymes' }
          end.to change(Attachment, :count).by(1)
        end

        it 'has correct file name' do
          post attachments_path, params: { files: [original_file1, original_file2], zip_name: 'rhymes' }

          expect(Attachment.last.name).to eq 'rhymes.zip'
        end
      end
    end

    context 'without chosen files' do
      it 'returns http success' do
        post attachments_path, params: { files: nil }

        expect(response.status).to eq 422
      end

      it 'does not create a new Attachment' do
        expect do
          post attachments_path, params: { files: nil }
        end.to change(Attachment, :count).by(0)
      end

      it 'shows alert' do
        post attachments_path, params: { files: nil }

        expect(flash[:alert]).to eq 'Files must be chosen'
      end
    end
  end
end

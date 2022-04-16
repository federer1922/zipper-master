# frozen_string_literal: true

module AttachmentCreateService
  def self.call(file_paramas)
    tempfile = file_paramas[:file].tempfile
    file_name = file_paramas[:file].original_filename
    password = SecureRandom.base64(15)

    zip_string = Zip::OutputStream.write_buffer(
      ::StringIO.new, Zip::TraditionalEncrypter.new(password.to_s)
    ) do |out|
      out.put_next_entry(file_name)
      out.write tempfile.read
    end.string

    io_object = Tempfile.new('zip_file', binmode: true)
    io_object.write(zip_string)
    io_object.rewind

    attachment = Attachment.new
    attachment.file.attach(io: io_object, filename: "#{file_name}.zip")
    attachment.name = attachment.file.filename
    attachment.size = attachment.file.byte_size
    if attachment.save
      { success: true, password: password }
    else
      { success: false, alert: attachment.errors.full_messages.first }
    end
  ensure
    io_object.close
    io_object.unlink
  end
end

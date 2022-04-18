# frozen_string_literal: true

module AttachmentCreateService
  def self.call(files_params)
    files = files_params[:files]

    return { success: false, alert: 'Files must be chosen', http_status: 422 } if files.blank?

    tempfiles = []
    password = SecureRandom.base64(15)
    zip_name = files_params[:zip_name].blank? ? 'files' : files_params[:zip_name]

    files.each do |f|
      tempfiles << [f.tempfile, f.original_filename]
    end

    zip_string = Zip::OutputStream.write_buffer(
      ::StringIO.new, Zip::TraditionalEncrypter.new(password.to_s)
    ) do |out|
      tempfiles.each do |tempfile|
        out.put_next_entry(tempfile[1])
        out.write tempfile[0].read
      end
    end.string

    io_object = Tempfile.new('zip_file', binmode: true)
    io_object.write(zip_string)
    io_object.rewind

    attachment = Attachment.new
    attachment.file.attach(io: io_object, filename: "#{zip_name}.zip")
    attachment.name = attachment.file.filename
    attachment.size = attachment.file.byte_size

    success = attachment.save

    io_object.close
    io_object.unlink

    if success
      { success: success, password: password }
    else
      { success: success, alert: attachment.errors.full_messages.first, http_status: 422 }
    end
  end
end

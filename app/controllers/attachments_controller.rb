# frozen_string_literal: true

class AttachmentsController < ApplicationController
  def index
    @attachments = Attachment.all
  end

  def new
    @attachment = Attachment.new
  end

  def create
    @result = AttachmentCreateService.call(params)
    if @result[:success]
      flash.now[:notice] = 'File successfully zipped'
      render :password
    else
      flash.now[:alert] = @result[:alert]
      render :new, status: @result[:http_status]
    end
  end
end

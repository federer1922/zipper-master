# frozen_string_literal: true

class AttachmentsController < ApplicationController
  def index
    @attachments = Attachment.all
  end

  def new
    @attachment = Attachment.new
  end

  def create
    @attachment = AttachmentCreateService.call(params[:attachment])
    if @attachment[:success]
      flash.now[:notice] = 'File successfully zipped'
      render :password
    else
      flash.now[:alert] = @attachment[:alert]
      render :new
    end
  end
end

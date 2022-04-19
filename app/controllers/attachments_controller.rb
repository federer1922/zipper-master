# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @attachments = Attachment.where(user: current_user)
  end

  def new
    @attachment = Attachment.new
  end

  def create
    @result = AttachmentCreateService.call(params, current_user)
    if @result[:success]
      flash.now[:notice] = 'File successfully zipped'
      render :password
    else
      flash.now[:alert] = @result[:alert]
      render :new, status: @result[:http_status]
    end
  end
end

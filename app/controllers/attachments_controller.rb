# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @attachments = Attachment.with_current_user(current_user).page(params[:page])
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

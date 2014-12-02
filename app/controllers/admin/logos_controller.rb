class Admin::LogosController < ApplicationController

  layout 'admin'

  before_action :set_logo, only: [:edit, :update, :destroy]

  def new
    @logo = Logo.new
  end

  def create
    @logo = Logo.new(logo_params)
    if @logo.save
      redirect_to admin_application_images_path, notice: 'Logo successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @logo.update(logo_params)
      redirect_to admin_application_images_path, notice: 'Logo successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @logo.destroy
      redirect_to admin_application_images_path, notice: 'Logo successfully removed.'
    else
      redirect_to admin_application_images_path, notice: 'Could not remove logo.'
    end
  end

  protected

  def set_logo
    unless @logo = Logo.find_by(id: params[:id])
      redirect_to admin_application_images_path, notice: 'No logo found.'
    end
  end

  def logo_params
    params.require(:logo).permit(:image)
  end
  
end
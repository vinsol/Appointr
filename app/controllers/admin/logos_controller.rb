class Admin::LogosController < ApplicationController

  layout 'admin'

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
    @logo = Logo.find_by(id: params[:id])
    debugger
  end

  def update
    @logo = Logo.find_by(id: params[:id])
    if @logo.update(logo_params)
      redirect_to admin_application_images_path, notice: 'Logo successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    Logo.first.destroy
    redirect_to admin_application_images_path, notice: 'Logo successfully removed.'
  end

  protected

  def logo_params
    params.require(:logo).permit(:image)
  end
  
end
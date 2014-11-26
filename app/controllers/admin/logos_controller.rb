class Admin::LogosController < ApplicationController

  layout 'admin'

  def new
    @logo = Logo.new
  end

  def create
    @logo = Logo.new(logo_params)
    if @logo.save
      if Logo.all.count > 1
        Logo.first.destroy
      end
      redirect_to admin_application_images_path, notice: 'Logo successfully updated.'
    else
      render :new
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
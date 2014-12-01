class Admin::BackGroundsController < ApplicationController
  
  layout 'admin'

  before_action :set_back_ground, only: [:edit, :update, :destroy]

  def new
    @back_ground = BackGround.new
  end

  def create
    @back_ground = BackGround.new(back_ground_params)
    if @back_ground.save
      redirect_to admin_application_images_path, notice: 'Back Ground successfully createdc.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @back_ground.update(back_ground_params)
      redirect_to admin_application_images_path, notice: 'Back Ground successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @back_ground.destroy
      redirect_to admin_application_images_path, notice: 'Background successfully removed.'
    else
      redirect_to admin_application_images_path, notice: 'Could not remove background.'
    end
  end

  protected

  def set_back_ground
    unless @back_ground = BackGround.find_by(id: params[:id])
      redirect_to admin_application_images_path, notice: 'No background found.'
    end
  end

  def back_ground_params
    params.require(:back_ground).permit(:image)
  end
end
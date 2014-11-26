class Admin::BackGroundsController < ApplicationController
  
  layout 'admin'

  def new
    @back_ground = BackGround.new
  end

  def create
    @back_ground = BackGround.new(back_ground_params)
    if @back_ground.save
      if BackGround.all.count > 1
        BackGround.first.destroy
      end
      redirect_to admin_application_images_path, notice: 'Back Ground successfully updated.'
    else
      render :new
    end
  end

  def destroy
    BackGround.first.destroy
    redirect_to admin_application_images_path, notice: 'Back Ground successfully removed.'
  end

  protected

  def back_ground_params
    params.require(:back_ground).permit(:image)
  end
end
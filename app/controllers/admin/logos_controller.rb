class Admin::LogosController < Admin::BaseController

  before_action :load_logo, only: [:edit, :update, :destroy]

  def new
    @logo = Logo.new
  end

  def create
    @logo = Logo.new(logo_params)
    if @logo.save
      redirect_to admin_application_images_path, notice: 'Logo successfully created.'
    else
      @logo.errors[:image].clear
      render :new
      # [rai] why you need to clear flash(fixed)
    end
  end

  def edit
  end

  def update
    if params[:logo][:image] && @logo.update(logo_params)
      redirect_to admin_application_images_path, notice: 'Logo successfully updated.'
    else
      @logo.errors[:image].clear
      render :edit
    end
  end

  # [rai] sent the flash in if else block(fixed)
  def destroy
    if @logo.destroy
      flash[:notice] ='Logo successfully removed.'
    else
      flash[:alert] = 'Could not remove logo.'
    end
    redirect_to admin_application_images_path
  end

  # [rai] why not private(fixed)
  private
  # [rai] put two space indentation after private/private block(fixed)
    def load_logo
      unless @logo = Logo.find_by(id: params[:id])
        redirect_to admin_application_images_path, alert: 'No logo found.'
      end
    end

    def logo_params
      params.require(:logo).permit(:image)
    end
    
end
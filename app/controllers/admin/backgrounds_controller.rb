class Admin::BackgroundsController < Admin::BaseController

  before_action :load_background, only: [:edit, :update, :destroy]

  def new
    @background = Background.new
  end

  def create
    @background = Background.new(background_params)
    if @background.save
      redirect_to admin_application_images_path, notice: 'Back Ground successfully created.'
    else
      @background.errors[:image].clear
      render :new
    end
  end

  def edit
  end

  def update
    if params[:background][:image] && @background.update(background_params)
      redirect_to admin_application_images_path, notice: 'Back Ground successfully updated.'
    else
      @background.errors[:image].clear
      render :edit
    end
  end

  def destroy
    if @background.destroy
      flash[:notice] ='Background successfully removed.'
    else
      flash[:alert] = 'Could not remove Background.'
    end
    redirect_to admin_application_images_path
  end

  private

    def load_background
      unless @background = Background.find_by(id: params[:id])
        redirect_to admin_application_images_path, alert: 'No background found.'
      end
    end

    def background_params
      params.require(:background).permit(:image)
    end
end
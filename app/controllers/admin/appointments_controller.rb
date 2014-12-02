class Admin::AppointmentsController < ApplicationController

  def index
    @appointments = Appointment.all
  end

  def search
    if params[:search].empty?
      @appointments = Appointment.all
    else
      @appointments = Appointment.search Riddle::Query.escape(params[:search])
    end
  end

end
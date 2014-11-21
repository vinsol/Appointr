class AppointmentsController < ApplicationController
  def index
    @appointments = Appointment.select("staff_id, customer_id, '' AS title, date AS start, date AS end").where("date BETWEEN '#{ params[:start] }' AND '#{ params[:end] }'")
    @appointments.each { |appointment| appointment.title = "Staff: #{ appointment.staff.name } Customer: #{ appointment.customer.name }" }
    render json: @appointments
  end
end
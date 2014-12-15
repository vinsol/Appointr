require 'rails_helper'

RSpec.describe Appointment do
  describe 'Associations' do
    it { should belong_to(:customer)}
    it { should belong_to(:service)}
    it { should belong_to(:staff)}
  end

  describe 'Validations' do
    it { should validate_presence_of(:service) }
    it { should validate_presence_of(:customer) }
    it { should validate_presence_of(:start_at) }
    it { should validate_presence_of(:duration) }
  end

  describe '#end_at' do
    before do
      @appointment = Appointment.create(service_id: 1, staff_id: 2, customer_id: 5, start_at: Time.parse('11:00:00'), duration: 30)
    end
    it do 
      expect(@appointment.end_at).to eq(Time.parse('11:30:00'))
    end
  end

  describe '#appointment_time_not_in_past' do
    context 'when start_at is in past' do
      before do
        @appointment = Appointment.create(service_id: 1, staff_id: 2, customer_id: 5, start_at: Time.parse('2014-11-10T11:00:00'), duration: 30)
      end
      it do
        @appointment.send(:appointment_time_not_in_past)
        expect(@appointment.errors[:time]).to include('can not be in past.')
      end
    end
    context 'when start_at is not in past' do
      before do
        @appointment = Appointment.create(service_id: 1, staff_id: 2, customer_id: 5, start_at: Time.parse('2014-12-10T11:00:00'), duration: 30)
      end
      it do
        @appointment.send(:appointment_time_not_in_past)
        expect(@appointment.errors[:time]).to eql([])
      end
    end
  end

  describe '#ensure_duration_not_less_than_service_duration' do
    context 'when invalid' do
      before do
        Service.create(name: 'spa', duration: 30, enabled: true)
        @appointment = Appointment.create(service_id: Service.first.id, staff_id: 2, customer_id: 5, start_at: Time.parse('2014-11-10T11:00:00'), duration: 15)
      end
      it do
        @appointment.send(:ensure_duration_not_less_than_service_duration)
        expect(@appointment.errors[:duration]).to include('must be greater than or equal to 30')
      end
    end
    context 'when valid' do
      before do
        Service.create(name: 'spa', duration: 30, enabled: true)
        @appointment = Appointment.create(service_id: Service.first.id, staff_id: 2, customer_id: 5, start_at: Time.parse('2014-12-10T11:00:00'), duration: 30)
      end
      it do
        @appointment.send(:ensure_duration_not_less_than_service_duration)
        expect(@appointment.errors[:duration]).to eql([])
      end
    end
  end

  describe '#ensure_customer_has_no_prior_appointment_at_same_time' do
    context 'when invalid' do
      before do
        Customer.create(name: 'abcd', email: 'abcd@abcd.com', enabled: true)
        @availability = Availability.create(staff_id: 2, enabled: true, start_date: Date.today, end_date: (Date.today + 1.month), start_at: Time.parse('2014-12-10T10:00:00'), end_at: Time.parse('2014-12-10T22:00:00'))
        @first_appointment = Appointment.create(service_id: 1, staff_id: 2, customer_id: Customer.last.id, start_at: Time.parse('2014-12-10T11:00:00'), duration: 15)
        @second_appointment = Appointment.create(service_id: 1, staff_id: 2, customer_id: Customer.last.id, start_at: Time.parse('2014-12-10T11:00:00'), duration: 15)
      end
      it do
        debugger
        @second_appointment.send(:ensure_customer_has_no_prior_appointment_at_same_time)
        expect(@second_appointment.errors[:base]).to include('You already have an overlapping appointment for this time duration.')
      end
    end
    context 'when valid' do
      before do
        @appointment = Appointment.create(service_id: 1, staff_id: 2, customer_id: Customer.last.id, start_at: Time.parse('2014-12-10T11:00:00'), duration: 30)
      end
      it do
        @appointment.send(:ensure_customer_has_no_prior_appointment_at_same_time)
        expect(@appointment.errors[:base]).to eql([])
      end
    end
  end

  describe '#staff_allotable?' do
    context 'when staff not available' do
      before do
        @staff = Staff.create(name: 'abcd', email: 'abcd@abcd.com', enabled: true, designation: 'advc', service_ids: [1])
        @availability = Availability.create(staff_id: 2, enabled: true, start_date: Date.today, end_date: Date.today, start_at: Time.parse('2014-12-10T10:00:00'), end_at: Time.parse('2014-12-10T22:00:00'))
        @first_appointment = Appointment.create(service_id: 1, staff_id: 2, customer_id: 5, start_at: Time.parse('2014-12-10T11:00:00'), duration: 15)
        @second_appointment = Appointment.create(service_id: 1, staff_id: 2, customer_id: 5, start_at: Time.parse('2014-12-10T11:00:00'), duration: 15)
      end
      it do
        @second_appointment.send(:staff_allotable?)
        expect(@appointment.errors[:base]).to include('No availability for this time duration for this staff.')
      end
    end
    context 'when staff is occupied' do
      before do
        @staff = Staff.create(name: 'abcd', email: 'abcd@abcd.com', enabled: true, designation: 'advc', service_ids: [1])
        @availability = Availability.create(staff_id: 2, enabled: true, start_date: Date.today, end_date: (Date.today + 1.month), start_at: Time.parse('2014-12-10T10:00:00'), end_at: Time.parse('2014-12-10T22:00:00'))
        @first_appointment = Appointment.create(service_id: 1, staff_id: 2, customer_id: 5, start_at: Time.parse('2014-12-10T11:00:00'), duration: 15)
        @second_appointment = Appointment.create(service_id: 1, staff_id: 2, customer_id: 5, start_at: Time.parse('2014-12-10T11:00:00'), duration: 15)
      end
      it do
        @second_appointment.send(:staff_allotable?)
        expect(@appointment.errors[:staff]).to include('is occupied.')
      end
    end
    context 'when valid' do
      before do
        @staff = Staff.create(name: 'abcd', email: 'abcd@abcd.com', enabled: true, designation: 'advc', service_ids: [1])
        @availability = Availability.create(staff_id: 2, enabled: true, start_date: Date.today, end_date: (Date.today + 1.month), start_at: Time.parse('2014-12-10T10:00:00'), end_at: Time.parse('2014-12-10T22:00:00'))
        @first_appointment = Appointment.create(service_id: 1, staff_id: 2, customer_id: 5, start_at: Time.parse('2014-12-10T11:00:00'), duration: 15)
        @second_appointment = Appointment.create(service_id: 1, staff_id: 2, customer_id: 5, start_at: Time.parse('2014-12-09T11:00:00'), duration: 15)
      end
      it do
        @second_appointment.send(:staff_allotable?)
        expect(@appointment.errors[:staff]).to eql([])
      end
    end
  end
end

require 'rails_helper'

describe Appointment do
  describe 'Associations' do
    it { should belong_to(:customer)}
    it { should belong_to(:service)}
    it { should belong_to(:staff)}
  end
  let(:service) { FactoryGirl.create(:service) }
  let(:staff) { FactoryGirl.create(:staff, services: [service]) }
  let(:availability) { FactoryGirl.create(:availability, services: [service], staff: staff) }
  let(:customer) { FactoryGirl.create(:customer) }

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

  describe '#ensure_duration_not_less_than_service_duration' do
    let(:valid_appointment) { FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer) }
    let(:invalid_appointment) { FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer, duration: 15) }

    context 'when invalid' do
      before do
        FactoryGirl.create(:availability, services: [service], staff: staff)
      end
      it do
        invalid_appointment.send(:ensure_duration_not_less_than_service_duration)
        expect(invalid_appointment.errors[:duration]).to include("must be greater than or equal to #{ service.duration }" )
      end
    end
    context 'when valid' do
      before do
        FactoryGirl.create(:availability, services: [service], staff: staff)
      end
      it do
        valid_appointment.send(:ensure_duration_not_less_than_service_duration)
        expect(valid_appointment.errors[:duration]).to eql([])
      end
    end
  end

  describe '#ensure_customer_has_no_prior_appointment_at_same_time' do

    let(:valid_appointment) { FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer, start_at: (Time.now + 1.day + 20.minutes)) }
    let(:invalid_appointment) { FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer, duration: 15) }


    context 'when invalid' do
      before do
        FactoryGirl.create(:availability, services: [service], staff: staff)
        @appointment = FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer)
      end
      it do
        invalid_appointment.send(:ensure_customer_has_no_prior_appointment_at_same_time)
        expect(invalid_appointment.errors[:base]).to include("You already have an overlapping appointment from #{ @appointment.start_at.strftime("%H:%M") } to #{ @appointment.end_at.strftime("%H:%M") }")
      end
    end
    context 'when valid' do
      before do
        FactoryGirl.create(:availability, services: [service], staff: staff)
        FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer)
      end
      it do
        valid_appointment.send(:ensure_customer_has_no_prior_appointment_at_same_time)
        expect(valid_appointment.errors[:base]).to eql([])
      end
    end
  end

  describe '#staff_allotable?' do

    let(:valid_appointment) { FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer, start_at: (Time.now + 1.day + 20.minutes)) }
    let(:appointment_for_staff_not_available) { FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer, duration: 15, start_at: (Time.now + 6.days + 20.minutes)) }
    let(:appointment_for_staff_occupied) { FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer, duration: 15) }
    
    context 'when staff not available' do
      before do
        FactoryGirl.create(:availability, services: [service], staff: staff)
      end
      it do
        appointment_for_staff_not_available.send(:staff_allotable?)
        expect(appointment_for_staff_not_available.errors[:base]).to include('No availability for this time duration for this staff.')
      end
    end
    context 'when staff is occupied' do
      before do
        FactoryGirl.create(:availability, services: [service], staff: staff)
        @appointment = FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer)
      end
      it do
        appointment_for_staff_occupied.send(:staff_allotable?)
        expect(appointment_for_staff_occupied.errors[:staff]).to include('is occupied.')
      end
    end
    context 'when valid' do
      before do
        FactoryGirl.create(:availability, services: [service], staff: staff)
        @appointment = FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer)
      end
      it do
        valid_appointment.send(:staff_allotable?)
        expect(valid_appointment.errors[:staff]).to eql([])
      end
    end
  end
end

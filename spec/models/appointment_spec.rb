require 'rails_helper'

describe Appointment do
  let(:service) { FactoryGirl.create(:service) }
  let(:staff) { FactoryGirl.create(:staff, services: [service]) }
  let(:availability) { FactoryGirl.create(:availability, services: [service], staff: staff) }
  let(:customer) { FactoryGirl.create(:customer) }

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

    let(:valid_appointment) { FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer, start_at: (Time.current + 1.day + 20.minutes)) }
    let(:invalid_appointment_one) { FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer) }
    let(:invalid_appointment_two) { FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer, start_at: (Time.current + 10.minutes)) }
    

    context 'when invalid' do
      before do
        FactoryGirl.create(:availability, services: [service], staff: staff)
        @appointment = FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer)
      end
      it do
        invalid_appointment_one.send(:ensure_customer_has_no_prior_appointment_at_same_time)
        invalid_appointment_two.send(:ensure_customer_has_no_prior_appointment_at_same_time)
        expect(invalid_appointment_one.errors[:base]).to include("You already have an overlapping appointment from #{ @appointment.start_at } to #{ @appointment.end_at }")
        expect(invalid_appointment_two.errors[:base]).to include("You already have an overlapping appointment from #{ @appointment.start_at } to #{ @appointment.end_at }")
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

    let(:valid_appointment) { FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer, start_at: (Time.current + 1.day + 20.minutes)) }
    let(:appointment_for_staff_not_available) { FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer, duration: 15, start_at: (Time.current + 6.days + 20.minutes)) }
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

  describe '#check_if_approved?' do
    context 'when approved' do
      before do
        FactoryGirl.create(:availability, services: [service], staff: staff)
        @appointment = FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer)
      end

      it do
        expect(@appointment.send(:check_if_approved?)).to eq(true)
      end
    end

    context 'when cancelled' do
      before do
        FactoryGirl.create(:availability, services: [service], staff: staff)
        @appointment = FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer)
        @appointment.cancel
      end

      it do
        expect(@appointment.send(:check_if_approved?)).to eq(false)
      end
    end

    context 'when attended' do
      before do
        FactoryGirl.create(:availability, services: [service], staff: staff)
        @appointment = FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer)
        @appointment.attend
      end

      it do
        expect(@appointment.send(:check_if_approved?)).to eq(false)
      end
    end

    context 'when missed' do
      before do
        FactoryGirl.create(:availability, services: [service], staff: staff)
        @appointment = FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer)
        @appointment.miss
      end

      it do
        expect(@appointment.send(:check_if_approved?)).to eq(false)
      end
    end
  end

  describe '#get_availabilities_for_service' do
    before do
      @availability = FactoryGirl.create(:availability, services: [service], staff: staff)
      @appointment  = FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer)  
    end

    it do
      expect(@appointment.send(:get_availabilities_for_service)).to eq([@availability])
    end
  end

  describe '#assign_staff' do
    context 'when availabilities are present' do
      before do
        @availability = FactoryGirl.create(:availability, services: [service], staff: staff)
        @appointment = FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer)    
      end
      it do
        expect(@appointment).to receive(:set_staff)
        @appointment.send(:assign_staff)
      end
    end

    context 'when availabilities are not present' do
      before do
        @appointment = FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer)    
      end
      it do
        expect(@appointment.send(:assign_staff)).to eq false
        expect(@appointment.errors[:base]).to include('No availability for this time duration.')
      end
    end
  end

  describe '#set_staff' do
    let(:valid_appointment) { FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer, start_at: (Time.current + 1.day + 20.minutes)) }
    let(:appointment_for_staff_occupied) { FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer, duration: 15) }

    context 'when staff booked' do
      before do
        @availability = FactoryGirl.create(:availability, services: [service], staff: staff)
        @appointment = FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer)
        appointment_for_staff_occupied.send :get_availabilities_for_service
      end

      it do
        appointment_for_staff_occupied.send(:set_staff)
        expect(appointment_for_staff_occupied.errors[:base]).to include('No staff available for this time duration')
      end
      it do
        expect(appointment_for_staff_occupied.send(:set_staff)).to eq(false)
      end
    end

    context 'when staff available' do
      before do
        @availability = FactoryGirl.create(:availability, services: [service], staff: staff)
        @appointment = FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer)
        valid_appointment.send :get_availabilities_for_service
      end

      it do
        valid_appointment.send(:set_staff)
        expect(valid_appointment.staff).to eq(staff)
      end
      it do
        expect(valid_appointment.send(:set_staff)).to eq(nil)
      end
    end
  end

  describe '#has_no_clashing_appointments?' do
    let(:valid_appointment) { FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer, start_at: (Time.current + 1.day + 20.minutes)) }
    let(:invalid_appointment) { FactoryGirl.build(:appointment, service: service, staff: staff, customer: customer, duration: 15) }
    
    context 'for customer' do
      context 'when no appointment clashes' do
        before do
          @availability = FactoryGirl.create(:availability, services: [service], staff: staff)
          @appointment = FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer)
        end

        it do
          expect(valid_appointment.send(:has_no_clashing_appointments?, customer)).to eq(true)
        end
      end
      context 'when clashing appointment present' do
        before do
          @availability = FactoryGirl.create(:availability, services: [service], staff: staff)
          @appointment = FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer)
        end

        it do
          expect(invalid_appointment.send(:has_no_clashing_appointments?, customer)).to eq(false)
        end
      end
    end
    context 'for staff' do
      context 'when no appointment clashes' do
        before do
          @availability = FactoryGirl.create(:availability, services: [service], staff: staff)
          @appointment = FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer)
        end

        it do
          expect(valid_appointment.send(:has_no_clashing_appointments?, staff)).to eq(true)
        end
      end
      context 'when clashing appointment present' do
        before do
          @availability = FactoryGirl.create(:availability, services: [service], staff: staff)
          @appointment = FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer)
        end

        it do
          expect(invalid_appointment.send(:has_no_clashing_appointments?, staff)).to eq(false)
        end
      end
    end
  end

  describe 'Mailers' do
    describe 'on appointment creation' do
      before do
        @availability = FactoryGirl.create(:availability, services: [service], staff: staff)
        @appointment = FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer)
      end

      it do
        expect(ActionMailer::Base.deliveries.last.to).to eq(['bar@gmail.com'])
      end
      it do
        expect(ActionMailer::Base.deliveries.last.from).to eq(['test.vinsol.ams@gmail.com'])
      end
      it do
        expect(ActionMailer::Base.deliveries.last.subject).to eq('Appointment Created')
      end
      it do
        expect(ActionMailer::Base.deliveries.last(2).first.to).to eq(['foo@gamil.com'])
      end
      it do
        expect(ActionMailer::Base.deliveries.last(2).first.from).to eq(['test.vinsol.ams@gmail.com'])
      end
      it do
        expect(ActionMailer::Base.deliveries.last(2).first.subject).to eq('Appointment Created')
      end
    end

    describe 'on appointment updation' do
      before do
        @availability = FactoryGirl.create(:availability, services: [service], staff: staff)
        @appointment = FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer)
        @appointment = Appointment.first
        @appointment.update(duration:45)
      end

      it do
        expect(ActionMailer::Base.deliveries.last.to).to eq(['bar@gmail.com'])
      end
      it do
        expect(ActionMailer::Base.deliveries.last.from).to eq(['test.vinsol.ams@gmail.com'])
      end
      it do
        expect(ActionMailer::Base.deliveries.last.subject).to eq('Appointment Edited')
      end
      it do
        expect(ActionMailer::Base.deliveries.last(2).first.to).to eq(['foo@gamil.com'])
      end
      it do
        expect(ActionMailer::Base.deliveries.last(2).first.from).to eq(['test.vinsol.ams@gmail.com'])
      end
      it do
        expect(ActionMailer::Base.deliveries.last(2).first.subject).to eq('Appointment Edited')
      end
    end

    describe 'on appointment cancelation' do
      before do
        @availability = FactoryGirl.create(:availability, services: [service], staff: staff)
        @appointment = FactoryGirl.create(:appointment, service: service, staff: staff, customer: customer)
        @appointment = Appointment.first
        @appointment.cancel
      end

      it do
        expect(ActionMailer::Base.deliveries.last.to).to eq(['bar@gmail.com'])
      end
      it do
        expect(ActionMailer::Base.deliveries.last.from).to eq(['test.vinsol.ams@gmail.com'])
      end
      it do
        expect(ActionMailer::Base.deliveries.last.subject).to eq('Appointment Cancelled')
      end
      it do
        expect(ActionMailer::Base.deliveries.last(2).first.to).to eq(['foo@gamil.com'])
      end
      it do
        expect(ActionMailer::Base.deliveries.last(2).first.from).to eq(['test.vinsol.ams@gmail.com'])
      end
      it do
        expect(ActionMailer::Base.deliveries.last(2).first.subject).to eq('Appointment Cancelled')
      end
    end
  end

end

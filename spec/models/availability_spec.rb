require 'rails_helper'
# validates :staff, presence: true
#   validates :services, presence: true
#   validates :enabled, inclusion: { in: [true, false] }
#   validate :check_end_time_greater_than_start_time
#   validate :check_check_for_past_dates
#   validate :check_for_past_dates
RSpec.describe Availability do
  describe 'Validations' do
    it { should validate_presence_of(:services) }
    it { should validate_presence_of(:staff) }
    it { should validate_inclusion_of(:enabled).in_array [true, false] }
  end

  describe 'Associations' do
    it { should belong_to(:staff) }
    it { should have_many(:availability_services).dependent(:restrict_with_error) }
    it { should have_many(:services).through(:availability_services) }
  end

  describe '#ensure_dates_are_valid' do
    context 'when valid' do
      before do
        @availability = Availability.create(staff_id: 2, enabled: true, start_date: Date.today, end_date: Date.today, start_at: Time.now, end_at: (Time.now + 5.minutes))
      end
      it ' should not add error message' do
        @availability.send(:ensure_dates_are_valid)
        expect(@availability.errors[:start_date]).to eql []
        expect(@availability.errors[:end_date]).to eql []
      end
    end
    context 'when start_date is invalid' do
      before do
        @availability = Availability.create(staff_id: 2, enabled: true, start_date: 'asdfc', end_date: Date.today, start_at: Time.now, end_at: (Time.now - 5.minutes))
      end
      it 'should add error message to start_date' do
        @availability.send(:ensure_dates_are_valid)
        expect(@availability.errors[:start_date]).to include('is invalid.')
      end
    end
    context 'when end_date is invalid' do
      before do
        @availability = Availability.create(staff_id: 2, enabled: true, start_date: Date.today, end_date: 'asdd', start_at: Time.now, end_at: (Time.now - 5.minutes))
      end
      it 'should add error message to end_date' do
        @availability.send(:ensure_dates_are_valid)
        expect(@availability.errors[:end_date]).to include('is invalid.')
      end
    end
  end

  describe '#ensure_end_at_greater_than_start_at' do
    context 'when valid' do
      before do
        @availability = Availability.create(staff_id: 2, enabled: true, start_date: Date.today, end_date: Date.today, start_at: Time.now, end_at: (Time.now + 5.minutes))
      end
      it ' should not add error message' do
        @availability.send(:ensure_end_at_greater_than_start_at)
        expect(@availability.errors[:base]).to eql []
      end
    end
    context 'when invalid' do
      before do
        @availability = Availability.create(staff_id: 2, enabled: true, start_date: Date.today, end_date: Date.today, start_at: Time.now, end_at: (Time.now - 5.minutes))
      end
      it 'should add error message' do
        @availability.send(:ensure_end_at_greater_than_start_at)
        expect(@availability.errors[:base]).to include('End time should be greater than start time.')
      end
    end
  end

  describe '#ensure_end_date_greater_than_start_date' do
    context 'when valid' do
      before do
        @availability = Availability.create(staff_id: 2, enabled: true, start_date: Date.today, end_date: Date.today + 2.days, start_at: Time.now, end_at: (Time.now + 5.minutes))
      end
      it ' should not add error message' do
        @availability.send(:ensure_end_date_greater_than_start_date)
        expect(@availability.errors[:base]).to eql []
      end
    end
    context 'when invalid' do
      before do
        @availability = Availability.create(staff_id: 2, enabled: true, start_date: Date.today, end_date: Date.today - 2.days, start_at: Time.now, end_at: (Time.now + 5.minutes))
      end
      it 'should add error message' do
        @availability.send(:ensure_end_date_greater_than_start_date)
        expect(@availability.errors[:base]).to include('End date should be greater than start date.')
      end
    end
  end
end
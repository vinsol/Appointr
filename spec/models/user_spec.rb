require 'rails_helper'

RSpec.describe User, :type => :model do
  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end

  describe '#downcase_email' do
    user = Customer.create(name: 'gaurav', email:'Gaurav@Vinsol.Com', designation: 'asdcacsdc', password: '11111111', password_confirmation: '11111111')
    it { expect(user.downcase_email).to eq('gaurav@vinsol.com') }
  end

  describe '.types' do
    it { expect(User.types).to eq(['Admin', 'Customer', 'Staff']) }
  end
end

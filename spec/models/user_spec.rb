require 'rails_helper'

RSpec.describe User, :type => :model do
  describe 'Validation' do
    # pending "add some examples to (or delete) #{__FILE__}"
    it { should validate_presence_of(:name) }

    it '#downcase_email' do
      user = Customer.create(name: 'gaurav', email:'Gaurav@Vinsol.Com', designation: 'asdcacsdc', password: '11111111', password_confirmation: '11111111')
      expect(user.downcase_email).to eq('gaurav@vinsol.com')
    end

    it '.types' do
      expect(User.types).to eq(['Admin', 'Customer', 'Staff'])
    end

  end
end

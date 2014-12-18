require 'rails_helper'

Rails.describe Staff do
  describe 'Validations' do
    it { should validate_presence_of(:designation) }
    it { should validate_presence_of(:services) }
    it 'should require a password' do
      Staff.create(name: 'gaurav', email:'Gaurav@Vinsol.Com', designation: 'asdcacsdc', password: '', password_confirmation: '11111111').should_not be_valid
    end
    it { should_not allow_value(' aaaaaaa').for(:password) }
    it { should_not allow_value('aaaaaaa ').for(:password) }
    it { should_not allow_value(' aaaaaa ').for(:password) }
    it { should_not allow_value('a aaaaaa').for(:password) }
    it { should_not allow_value('aa aaaaa').for(:password) }
    it { should allow_value('aaaaaaaa').for(:password) }
    it { should allow_value('aa234aaaaaa').for(:password) }
    it { should allow_value('123aaaaaaaa').for(:password) }
    it { should allow_value('1aaa2aaaaa3').for(:password) }
    it { should allow_value('aaaaaaaa123').for(:password) }
  end

  describe '#should_validate_password?' do
    it do
      staff = Staff.create(name: 'gaurav', email:'Gaurav@Vinsol.Com', designation: 'asdcacsdc', password: '', password_confirmation: '11111111')
      expect(staff.send(:should_validate_password?)).to eq(false)
    end
  end
end
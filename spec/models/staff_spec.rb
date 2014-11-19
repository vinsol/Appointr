require 'rails_helper'

Rails.describe Staff do
  describe 'Validations' do
    it { should validate_presence_of(:designation) }
    it { should validate_presence_of(:services) }
    it 'should require a password' do
      Staff.create(name: 'gaurav', email:'Gaurav@Vinsol.Com', designation: 'asdcacsdc', password: '', password_confirmation: '11111111').should_not be_valid
    end
    it { should allow_value(/\A[^\s]*\z/i).for(:password) }
  end

  it '#should_validate_password?' do
    staff = Staff.create(name: 'gaurav', email:'Gaurav@Vinsol.Com', designation: 'asdcacsdc', password: '', password_confirmation: '11111111')
    expect(staff.should_validate_password?).to eq(false)
  end

  it '#password_match?' do
    staff = Staff.create(name: 'gaurav', email:'Gaurav@Vinsol.Com', designation: 'asdcacsdc', password: '', password_confirmation: '11111111')
    expect(staff.password_match?).to eq(false)
  end
end
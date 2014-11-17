require 'rails_helper'

RSpec.describe Customer do
  describe 'Validations' do
    it { should validate_presence_of(:password) }
    # it { should_not allow_value(' aaaaaaa').for(:password) }
    # it { should_not allow_value('aaaaaaa ').for(:password) }
    # it { should_not allow_value(' aaaaaa ').for(:password) }
    # it { should_not allow_value('a aaaaaa').for(:password) }
    # it { should_not allow_value('aa aaaaa').for(:password) }
    it { should allow_value(/\A[^\s]*\z/i).for(:password) }
    
  end
end
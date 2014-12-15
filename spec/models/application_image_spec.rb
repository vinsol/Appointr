require 'rails_helper'

RSpec.describe ApplicationImage, :type => :model do
  describe '.types' do
    it { expect(ApplicationImage.types).to eq(['BackGround', 'Logo']) }
  end
end
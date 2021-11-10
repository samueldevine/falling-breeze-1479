require 'rails_helper'

RSpec.describe PlantPlot do
  describe 'relationships' do
    it { should belong_to(:plot) }
    it { should belong_to(:plant) }
  end
end

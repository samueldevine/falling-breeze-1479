require 'rails_helper'

RSpec.describe Garden do
  describe 'relationships' do
    it { should have_many(:plots) }
  end

  describe 'instance methods' do
    describe '#show_plants' do
      it 'returns a unique list of the gardens plants that take less than 100 days to harvest' do
        turing_garden = Garden.create(name: 'Turing Community Garden', organic: true)

        plot_1 = turing_garden.plots.create(number: 25, size: "Large", direction: "East")
        plot_2 = turing_garden.plots.create(number: 26, size: "Small", direction: "West")

        plant_1 = plot_1.plants.create(
          name: 'Cauliflower',
          description: 'Valuable, but slow-growing. Despite its pale color, the florets are packed with nutrients.',
          days_to_harvest: 12
        )
        plant_2 = plot_1.plants.create(
          name: 'Blueberry',
          description: 'A popular berry reported to have many health benefits. The blue skin has the highest nutrient concentration.',
          days_to_harvest: 13
        )
        plant_3 = plot_1.plants.create(
          name: 'Ancient Fruit',
          description: "It's been dormant for eons.",
          days_to_harvest: 101
        )

        # add duplicate plants to test for uniqueness
        plot_2.plants << plant_1
        plot_2.plants << plant_2

        expect(turing_garden.show_plants.length).to eq 2
        expect(turing_garden.show_plants).to include(plant_1)
        expect(turing_garden.show_plants).to include(plant_2)
        expect(turing_garden.show_plants).to_not include(plant_3)
      end
    end
  end
end

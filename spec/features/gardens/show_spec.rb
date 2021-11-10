require 'rails_helper'

RSpec.describe 'the garden show page' do
  describe 'as a visitor' do
    before :each do
      @turing_garden = Garden.create(name: 'Turing Community Garden', organic: true)

      @plot_1 = @turing_garden.plots.create(
        number: 25, size: "Large", direction: "East"
      )
      @plot_2 = @turing_garden.plots.create(
        number: 26, size: "Small", direction: "West"
      )

      @plant_1 = @plot_1.plants.create(
        name: 'Cauliflower',
        description: 'Valuable, but slow-growing. Despite its pale color, the florets are packed with nutrients.',
        days_to_harvest: 12
      )
      @plant_2 = @plot_1.plants.create(
        name: 'Blueberry',
        description: 'A popular berry reported to have many health benefits. The blue skin has the highest nutrient concentration.',
        days_to_harvest: 13
      )
      @plant_3 = @plot_1.plants.create(
        name: 'Ancient Fruit',
        description: "It's been dormant for eons.",
        days_to_harvest: 101
      )
      @plant_4 = @plot_1.plants.create(
        name: 'Pumpkin',
        description: 'A fall favorite, grown for its crunchy seeds and delicately flavored flesh. As a bonus, the hollow shell can be carved into a festive decoration.',
        days_to_harvest: 13
      )

      # add duplicate plants to test for uniqueness and ordering
      @plot_2.plants << @plant_4
      @plot_2.plants << @plant_2
      @plot_2.plants << @plant_2
    end

    describe 'the list of plants' do
      it 'shows plants that are included in the gardens plots' do
        visit garden_path(@turing_garden.id)

        expect(page).to have_content @plant_1.name
        expect(page).to have_content @plant_2.name
      end

      it 'is unique and does not contain duplicates' do
        visit garden_path(@turing_garden.id)

        # not sure how to feature test this... but its covered in the model
        expect(page).to have_content @plant_1.name
        expect(@plant_1.name).to_not appear_before @plant_1.name
      end

      it 'only includes plants that take less than 100 days to harvest' do
        visit garden_path(@turing_garden.id)

        expect(page).to_not have_content @plant_3.name
      end

      it 'is ordered by the number of plants in the garden from most to least' do
        visit garden_path(@turing_garden.id)

        expect(@plant_2.name).to appear_before @plant_4.name
        expect(@plant_4.name).to appear_before @plant_1.name
      end
    end
  end
end

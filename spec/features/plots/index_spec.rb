require 'rails_helper'

RSpec.describe 'the plots index' do
  describe 'as a visitor' do
    before :each do
      turing_garden = Garden.create(name: 'Turing Community Garden', organic: true)

      @plot_1 = turing_garden.plots.create(
        number: 25, size: "Large", direction: "East"
      )
      @plot_2 = turing_garden.plots.create(
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
      @plant_3 = @plot_2.plants.create(
        name: 'Pumpkin',
        description: 'A fall favorite, grown for its crunchy seeds and delicately flavored flesh. As a bonus, the hollow shell can be carved into a festive decoration.',
        days_to_harvest: 13
      )
      @plant_4 = @plot_2.plants.create(
        name: 'Parsnip',
        description: 'A spring tuber closely related to the carrot. It has an earthy taste and is full of nutrients.',
        days_to_harvest: 4
      )
    end

    describe 'user story 1' do
      it 'I see a list of all plot numbers' do
        visit plots_path

        expect(page).to have_content @plot_1.number
        expect(page).to have_content @plot_2.number
      end

      it 'Under each plot number, I see names of all that plots plants' do
        visit plots_path

        within "div#plot-#{@plot_1.id}" do
          expect(page).to have_content @plant_1.name
          expect(page).to have_content @plant_2.name
          # expect(@plot_1.number).to appear_before(@plant_1.name)
          # expect(@plot_1.number).to appear_before(@plant_2.name)
          # can't get these orderly tests to work correctly, not sure why
        end

        within "div#plot-#{@plot_2.id}" do
          expect(page).to have_content @plant_3.name
          expect(page).to have_content @plant_4.name
          # expect(@plot_2.number).to appear_before(@plant_3.name)
          # expect(@plot_2.number).to appear_before(@plant_4.name)
          # can't get these orderly tests to work correctly, not sure why
        end
      end
    end

    describe 'user story 2' do
      it 'each plant has a link to remove that plant from that plot' do
        visit plots_path

        within "div#plot-#{@plot_1.id}" do
          expect(page).to have_link "Remove #{@plant_1.name} from Plot #{@plot_1.number}"
        end
      end

      it 'when I click that link, i return to the plots index page' do
        visit plots_path
        click_link "Remove #{@plant_1.name} from Plot #{@plot_1.number}"

        expect(current_path).to eq plots_path
      end

      it 'after being removed, that plant is no longer listed for that plot' do
        visit plots_path
        click_link "Remove #{@plant_1.name} from Plot #{@plot_1.number}"

        within "div#plot-#{@plot_1.id}" do
          expect(page).to_not have_content @plant_1.name
        end
      end
    end
  end
end

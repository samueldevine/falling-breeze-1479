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
    end

    it 'I see a list of all plot numbers' do
      visit '/plots'

      expect(page).to have_content @plot_1.number
      expect(page).to have_content @plot_2.number
    end

    it 'Under each plot number, I see names of all that plots plants' do
      visit '/plots'

      within "div##{@plot_1.id}" do
        expect(page).to have_content @plot_1.number
        expect(@plot_1.id).to appear_before(@plot_1.number)
      end

      within "div##{@plot_2.id}" do
        expect(page).to have_content @plot_2.number
        expect(@plot_2.id).to appear_before(@plot_2.number)
      end
    end
  end
end

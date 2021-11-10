class Garden < ApplicationRecord
  has_many :plots

  def show_plants
    Plant.joins(plots: :garden)
      .where(gardens: {id: id})
      .where("plants.days_to_harvest < 100")
      .distinct
  end
end

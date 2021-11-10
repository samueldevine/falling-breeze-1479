class Garden < ApplicationRecord
  has_many :plots

  def show_plants
    Plant.joins(plots: :garden)
      .where(gardens: {id: id})
      .where("plants.days_to_harvest < 100")
      .group(:id)
      .order(Arel.sql('COUNT(plants.id) DESC'))
      .select(
        "plants.* as plant,
        COUNT(plants.id) as num_plants"
      )
  end
end

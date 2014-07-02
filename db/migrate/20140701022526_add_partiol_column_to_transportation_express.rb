class AddPartiolColumnToTransportationExpress < ActiveRecord::Migration
  def change
    add_column :transportation_expresses, :self_approved, :boolean
    add_column :transportation_expresses, :boss_approved, :boolean
  end
end

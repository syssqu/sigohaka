class AddColumnToTransportationExpress < ActiveRecord::Migration
  def change
    add_column :transportation_expresses, :freezed, :boolean
  end
end

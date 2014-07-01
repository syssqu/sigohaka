class AddColumnDayToTransportationExpress < ActiveRecord::Migration
  def change
    add_column :transportation_expresses, :day, :string
  end
end

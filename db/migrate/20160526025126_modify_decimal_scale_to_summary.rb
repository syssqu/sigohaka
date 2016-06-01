class ModifyDecimalScaleToSummary < ActiveRecord::Migration
  def change
    change_column :summary_attendances, :vacation, :decimal, :precision => 4, :scale => 2
  end
end

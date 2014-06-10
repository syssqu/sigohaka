class ModifyDecimalFromIntegerToKinmuPatterns < ActiveRecord::Migration
  def change
    change_column :kinmu_patterns, :break_time, :decimal, :precision => 4, :scale => 2
    change_column :kinmu_patterns, :work_time, :decimal, :precision => 4, :scale => 2
  end
end

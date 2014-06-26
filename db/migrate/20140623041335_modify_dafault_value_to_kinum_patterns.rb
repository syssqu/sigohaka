class ModifyDafaultValueToKinumPatterns < ActiveRecord::Migration
  def change
    change_column_default :kinmu_patterns, :break_time, 0.00
    change_column_default :kinmu_patterns, :work_time, 0.00
  end
end

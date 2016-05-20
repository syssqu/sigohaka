class ChangeColumnDefaultMidnightBreakTimeOfKinmuPattern < ActiveRecord::Migration
  def change
        change_column_default :kinmu_patterns, :midnight_break_time, 0.00
  end
end

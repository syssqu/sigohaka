class ChangeDatatypeMidnightBreakTimeOfKinmuPattern < ActiveRecord::Migration
  def change
    change_column :kinmu_patterns, :midnight_break_time, :string
    change_column :kinmu_patterns, :midnight_break_time, 'integer USING CAST(midnight_break_time AS integer)'
    change_column :kinmu_patterns, :midnight_break_time, :decimal, :precision => 4, :scale => 2

  end
end

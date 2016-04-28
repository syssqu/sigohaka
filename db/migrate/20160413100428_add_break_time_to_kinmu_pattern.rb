class AddBreakTimeToKinmuPattern < ActiveRecord::Migration
  def change
    add_column :kinmu_patterns, :midnight_break_time, :time
    add_column :kinmu_patterns, :sift, :boolean, default: false, null: false
  end
end

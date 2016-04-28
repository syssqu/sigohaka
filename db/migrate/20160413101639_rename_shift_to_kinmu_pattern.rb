class RenameShiftToKinmuPattern < ActiveRecord::Migration
  def change
    rename_column :kinmu_patterns, :sift, :shift
  end
end

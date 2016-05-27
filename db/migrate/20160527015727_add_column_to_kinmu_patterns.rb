class AddColumnToKinmuPatterns < ActiveRecord::Migration
  def change
    add_column :kinmu_patterns, :year, :string
    add_column :kinmu_patterns, :month, :string
  end
end

class AddCodeToKinmuPattern < ActiveRecord::Migration
  def change
    add_column :kinmu_patterns, :code, :string, limit:2
  end
end

class RenameTitokuToAttendance < ActiveRecord::Migration
  def change
     rename_column :attendances, :titoku, :tikoku
  end
end

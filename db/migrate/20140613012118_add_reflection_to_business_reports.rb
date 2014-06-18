class AddReflectionToBusinessReports < ActiveRecord::Migration
  def change
    add_column :business_reports, :reflection, :text
  end
end

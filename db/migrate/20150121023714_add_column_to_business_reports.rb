class AddColumnToBusinessReports < ActiveRecord::Migration
  def change
    add_column :business_reports, :freezed, :boolean
    add_column :business_reports, :self_approved, :boolean
    add_column :business_reports, :boss_approved, :boolean
    add_column :business_reports, :year, :string, limit:4
    add_column :business_reports, :month, :string, limit:2
  end
end

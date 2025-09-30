class CreateUnavailableDates < ActiveRecord::Migration[8.0]
  def change
    create_table :unavailable_dates do |t|
      t.string :user_name
      t.date :day

      t.timestamps
    end
  end
end
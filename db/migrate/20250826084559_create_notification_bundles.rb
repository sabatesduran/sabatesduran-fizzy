class CreateNotificationBundles < ActiveRecord::Migration[8.1]
  def change
    create_table :notification_bundles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :notification_bundles, %i[ user_id starts_at ends_at ]
    add_index :notification_bundles, %i[ user_id status ]
  end
end

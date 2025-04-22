class CreateMentions < ActiveRecord::Migration[8.1]
  def change
    create_table :mentions do |t|
      t.references :container, polymorphic: true, null: false, index: true
      t.references :mentionee, foreign_key: { to_table: :users }, null: false
      t.references :mentioner, foreign_key: { to_table: :users }, null: false

      t.timestamps
    end
  end
end

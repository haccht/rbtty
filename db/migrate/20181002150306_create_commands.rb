class CreateCommands < ActiveRecord::Migration[5.2]
  def change
    create_table :commands do |t|
      t.string :text, null: false
      t.string :uuid, null: false
      t.datetime :accessed_at, null: false

      t.timestamps
    end

    add_index :commands, :uuid, unique: true
  end
end

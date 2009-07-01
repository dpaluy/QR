class CreateProgams < ActiveRecord::Migration
  def self.up
    create_table :progams do |t|
      t.string :name
      t.string :key
      t.boolean :enable

      t.timestamps
    end
  end

  def self.down
    drop_table :progams
  end
end

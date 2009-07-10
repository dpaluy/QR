class CreatePrograms < ActiveRecord::Migration
  def self.up
    create_table :programs do |t|
      t.string :name
      t.string :key
      t.boolean :enable, :default => false

      t.timestamps
    end

	program = Program.new(:name => "Iron Man", :key => "1234")
	program.save!
  end

  def self.down
    drop_table :programs
  end
end

class CreateData < ActiveRecord::Migration[5.0]
  def change

    create_table :data do |t|
      t.string :description
      t.decimal :value
      t.integer :year
      t.references :imageable, polymorphic: true, index: true

      t.timestamps
    end

  end

end

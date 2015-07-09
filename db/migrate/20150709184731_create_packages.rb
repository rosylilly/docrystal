class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :hosting, null: false
      t.string :owner, null: false
      t.string :repo, null: false

      t.timestamps null: false
    end

    add_index :packages, %i(hosting owner repo), unique: true
  end
end

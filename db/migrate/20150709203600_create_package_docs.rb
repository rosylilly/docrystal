class CreatePackageDocs < ActiveRecord::Migration
  def change
    create_table :package_docs do |t|
      t.belongs_to :package, index: true, foreign_key: true, null: false
      t.string :name, null: true
      t.string :sha, null: false
      t.datetime :generated_at, null: true

      t.timestamps null: false
    end

    add_index :package_docs, %i(package_id name), unique: true
    add_index :package_docs, %i(package_id name sha), unique: true
  end
end

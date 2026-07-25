class CreateUrlMeta < ActiveRecord::Migration[8.1]
  def change
    create_table :url_meta do |t|
      t.string :title
      t.text :description
      t.json :thumb_data

      t.timestamps
    end
  end
end

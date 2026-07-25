class CreateCommentHierarchies < ActiveRecord::Migration[8.1]
  def change
    create_table :comment_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :comment_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "comment_anc_desc_idx"

    add_index :comment_hierarchies, [:descendant_id],
      name: "comment_desc_idx"
  end
end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_09_172224) do
  create_table "comment_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "comment_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "comment_desc_idx"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.text "body_html"
    t.integer "children_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.integer "depth_cached", default: 0, null: false
    t.datetime "discarded_at"
    t.string "federated_url"
    t.integer "fedipub_actor_id"
    t.integer "likes_count", default: 0, null: false
    t.integer "parent_id"
    t.integer "post_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["discarded_at"], name: "index_comments_on_discarded_at"
    t.index ["fedipub_actor_id"], name: "index_comments_on_fedipub_actor_id"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "fedipub_activities", force: :cascade do |t|
    t.string "action", null: false
    t.integer "actor_id", null: false
    t.string "cc"
    t.datetime "created_at", null: false
    t.integer "entity_id", null: false
    t.string "entity_type", null: false
    t.string "instrument"
    t.string "result"
    t.string "to"
    t.datetime "undone_at"
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.index ["actor_id"], name: "index_fedipub_activities_on_actor_id"
    t.index ["entity_type", "entity_id"], name: "index_fedipub_activities_on_entity"
    t.index ["uuid"], name: "index_fedipub_activities_on_uuid", unique: true
  end

  create_table "fedipub_actors", force: :cascade do |t|
    t.string "actor_type"
    t.datetime "created_at", null: false
    t.integer "entity_id"
    t.string "entity_type"
    t.json "extensions"
    t.string "federated_url"
    t.string "followers_url"
    t.string "followings_url"
    t.string "inbox_url"
    t.boolean "local", default: false, null: false
    t.string "name"
    t.string "outbox_url"
    t.text "private_key"
    t.string "profile_url"
    t.text "public_key"
    t.string "server"
    t.datetime "tombstoned_at"
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "uuid"
    t.index ["entity_type", "entity_id"], name: "index_fedipub_actors_on_entity", unique: true
    t.index ["federated_url"], name: "index_fedipub_actors_on_federated_url", unique: true
    t.index ["uuid"], name: "index_fedipub_actors_on_uuid", unique: true
  end

  create_table "fedipub_followings", force: :cascade do |t|
    t.integer "actor_id", null: false
    t.datetime "created_at", null: false
    t.string "federated_url"
    t.integer "status", default: 0
    t.integer "target_actor_id", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.index ["actor_id", "target_actor_id"], name: "index_fedipub_followings_on_actor_id_and_target_actor_id", unique: true
    t.index ["actor_id"], name: "index_fedipub_followings_on_actor_id"
    t.index ["target_actor_id"], name: "index_fedipub_followings_on_target_actor_id"
    t.index ["uuid"], name: "index_fedipub_followings_on_uuid", unique: true
  end

  create_table "fedipub_hosts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "domain", null: false
    t.string "nodeinfo_url"
    t.text "protocols", default: "[]"
    t.text "services", default: "{}"
    t.string "software_name"
    t.string "software_version"
    t.datetime "updated_at", null: false
    t.index ["domain"], name: "index_fedipub_hosts_on_domain", unique: true
  end

  create_table "flags", force: :cascade do |t|
    t.boolean "action_taken", default: false
    t.integer "actor_id", null: false
    t.string "actor_type", null: false
    t.datetime "created_at", null: false
    t.integer "flaggable_id", null: false
    t.string "flaggable_type", null: false
    t.text "summary"
    t.datetime "updated_at", null: false
    t.index ["actor_type", "actor_id"], name: "index_flags_on_actor"
    t.index ["flaggable_type", "flaggable_id"], name: "index_flags_on_flaggable"
  end

  create_table "follows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "follower_id", null: false
    t.string "follower_type", null: false
    t.integer "following_id", null: false
    t.string "following_type", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_type", "follower_id"], name: "index_follows_on_follower"
    t.index ["following_type", "following_id"], name: "index_follows_on_following"
  end

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "server"
    t.string "slug"
    t.boolean "supergroup", default: false
    t.datetime "updated_at", null: false
  end

  create_table "gutentag_taggings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "tag_id", null: false
    t.integer "taggable_id", null: false
    t.string "taggable_type", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_gutentag_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id", "tag_id"], name: "unique_taggings", unique: true
    t.index ["taggable_type", "taggable_id"], name: "index_gutentag_taggings_on_taggable_type_and_taggable_id"
  end

  create_table "gutentag_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "taggings_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_gutentag_tags_on_name", unique: true
    t.index ["taggings_count"], name: "index_gutentag_tags_on_taggings_count"
  end

  create_table "likes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "fedipub_actor_id"
    t.integer "likeable_id", null: false
    t.string "likeable_type", null: false
    t.datetime "updated_at", null: false
    t.index ["fedipub_actor_id"], name: "index_likes_on_fedipub_actor_id"
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "comments_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.text "description_cached"
    t.datetime "discarded_at"
    t.integer "dislikes_count", default: 0, null: false
    t.string "federated_url"
    t.integer "fedipub_actor_id"
    t.integer "group_id"
    t.integer "likes_count", default: 0, null: false
    t.datetime "modified_at"
    t.integer "modified_count", default: 0, null: false
    t.string "remote_image_url"
    t.datetime "scrapped_at"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "url_domain"
    t.integer "url_meta_id"
    t.integer "user_id"
    t.boolean "webmentioned", default: false
    t.index ["fedipub_actor_id"], name: "index_posts_on_fedipub_actor_id"
    t.index ["group_id"], name: "index_posts_on_group_id"
    t.index ["url_meta_id"], name: "index_posts_on_url_meta_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "value"
    t.string "var", null: false
    t.index ["var"], name: "index_settings_on_var", unique: true
  end

  create_table "url_meta", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.json "thumb_data"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false
    t.json "avatar_data"
    t.text "bio"
    t.integer "comments_count", default: 0, null: false
    t.integer "comments_karma", default: 0, null: false
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.string "display_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.integer "followers_count", default: 0, null: false
    t.integer "following_count", default: 0, null: false
    t.datetime "last_active_at"
    t.datetime "locked_at"
    t.integer "posts_count", default: 0, null: false
    t.integer "posts_karma", default: 0, null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.json "settings", default: {}
    t.boolean "silenced", default: false
    t.boolean "suspended", default: false
    t.string "unconfirmed_email"
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "fedipub_actors"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "fedipub_activities", "fedipub_actors", column: "actor_id"
  add_foreign_key "fedipub_followings", "fedipub_actors", column: "actor_id"
  add_foreign_key "fedipub_followings", "fedipub_actors", column: "target_actor_id"
  add_foreign_key "likes", "fedipub_actors"
  add_foreign_key "posts", "fedipub_actors"
  add_foreign_key "posts", "groups"
  add_foreign_key "posts", "url_meta", column: "url_meta_id"
  add_foreign_key "posts", "users"
end

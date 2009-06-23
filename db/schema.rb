# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090622171016) do

  create_table "bdrb_job_queues", :force => true do |t|
    t.text     "args"
    t.string   "worker_name"
    t.string   "worker_method"
    t.string   "job_key"
    t.integer  "taken"
    t.integer  "finished"
    t.integer  "timeout"
    t.integer  "priority"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.string   "tag"
    t.string   "submitter_info"
    t.string   "runner_info"
    t.string   "worker_key"
    t.datetime "scheduled_at"
  end

  create_table "conversions", :force => true do |t|
    t.integer  "video_id"
    t.integer  "profile_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "status"
    t.text     "log"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.string   "name"
    t.text     "command"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "extension"
  end

  create_table "thumbnails", :force => true do |t|
    t.integer  "video_id"
    t.integer  "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.binary   "image_file",         :limit => 2147483647
    t.binary   "image_small_file",   :limit => 2147483647
    t.binary   "image_thumb_file",   :limit => 2147483647
  end

  create_table "videos", :force => true do |t|
    t.string   "name"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.integer  "duration"
    t.string   "video_codec"
    t.integer  "video_bitrate",      :limit => 10, :precision => 10, :scale => 0
    t.integer  "video_frame_rate",   :limit => 10, :precision => 10, :scale => 0
    t.integer  "video_resolution"
    t.string   "audio_codec"
    t.integer  "audio_bitrate",      :limit => 10, :precision => 10, :scale => 0
    t.integer  "audio_sample_rate"
    t.integer  "audio_resolution"
    t.integer  "profile_id"
  end

end

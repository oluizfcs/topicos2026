require "shrine"
require "shrine/storage/file_system"
require "shrine/plugins/mongoid"

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new(
    "public", prefix: "uploads/cache"
  ),
  store: Shrine::Storage::FileSystem.new(
    "public", prefix: "uploads"
  )
}

Shrine.plugin :mongoid
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data

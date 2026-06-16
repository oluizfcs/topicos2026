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

Rails.application.config.to_prepare do
  Shrine.plugin :mongoid
  Shrine.plugin :cached_attachment_data
  Shrine.plugin :restore_cached_data
end
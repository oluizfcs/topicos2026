class ImageUploader < Shrine
  plugin :validation_helpers
  Attacher.validate do
    validate_max_size 5 * 1024 * 1024,
                      message: "deve ter menos de 5 MB"
    validate_mime_type %w[image/jpeg image/png image/webp],
                       message: "formato não suportado"
    validate_extension %w[jpg jpeg png webp],
                       message: "extensão inválida"
  end
end

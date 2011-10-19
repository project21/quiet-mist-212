CarrierWave.configure do |config|
  if Rails.env.production?
    config.root = Rails.root.join('tmp')
    config.cache_dir = 'uploads'
  end

  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => 'AKIAIFJHC2MLNJZOCIPA',       # required
    :aws_secret_access_key  => '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',       # required
    # :region                 => 'eu-west-1'  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'uploads.campusmachine.com'                     # required

  # TODO: change this!
  config.fog_public     = true                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  config.s3_use_ssl = false
end

class CampusUploader < CarrierWave::Uploader::Base
  # Choose what kind of storage to use for this uploader:
  if Rails.env.production? || Rails.env.staging?
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end

class PhotoUploader < CampusUploader
  include CarrierWave::RMagick
  process :resize_to_fill => [100, 100]
  convert :jpg

  # required to convert to jpg
  def filename
    return unless super
    super.chomp(File.extname(super)) + '.jpg'
  end

  # B
  # Include RMagick or ImageScience support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  # include CarrierWave::ImageScience

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end

# SSL no worky
module CarrierWave
  module Storage
    class Fog < Abstract
      class File
        def public_url
          if host = @uploader.fog_host
            "#{host}/#{path}"
          else
            "https://s3.amazonaws.com/#{@uploader.fog_directory}/#{path}"
          end
        end
      end
    end
  end
end

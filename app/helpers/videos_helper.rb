# app/helpers/videos_helper.rb
module VideosHelper
  # Extrait l'ID YouTube d'une URL
  def extract_youtube_id(url)
    return nil if url.blank?

    patterns = [
      /(?:youtube\.com\/watch\?v=|youtu\.be\/)([^&?\/]+)/,
      /youtube\.com\/embed\/([^&?\/]+)/,
      /youtube\.com\/v\/([^&?\/]+)/
    ]

    patterns.each do |pattern|
      match = url.match(pattern)
      return match[1] if match
    end

    nil
  end

  # Retourne une miniature YouTube fiable
  def youtube_thumbnail(url)
    video_id = extract_youtube_id(url)
    return nil unless video_id

    # hqdefault.jpg existe toujours
    "https://img.youtube.com/vi/#{video_id}/hqdefault.jpg"
  end
end

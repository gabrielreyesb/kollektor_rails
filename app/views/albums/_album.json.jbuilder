json.extract! album, :id, :name, :year, :genre_id, :author_id, :created_at, :updated_at
json.url album_url(album, format: :json)

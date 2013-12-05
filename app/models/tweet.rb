class Tweet
  include Mongoid::Document
  include Mongoid::Search
  field :status_id, type: String
  field :text, type: String
  field :retweet_count, type: Integer
  field :created_at, type: DateTime
  field :user_screen_name, type: String
  field :user_name, type: String
  field :user_avatar, type: String
  search_in :text
end


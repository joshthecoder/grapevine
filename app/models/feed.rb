class Feed
  include Mongoid::Document
  field :keywords, type: Array

  def top_tweets
    Tweet.full_text_search(keywords.join(' ')).desc(:retweet_count, :created_at).limit(10)
  end
end


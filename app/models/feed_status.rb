class FeedStatus
  include Mongoid::Document
  field :keywords_count, type: Integer, default: 0
  field :tweets_consumed, type: Integer, default: 0
  field :status, type: String, default: "offline"

  def self.instance
    first || create
  end
end

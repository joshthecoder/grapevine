class FeedStreamer
  def initialize
    @client = TweetStream::Client.new
    @client.on_timeline_status {|s| on_status(s)}
  end

  def start
    puts 'Starting...'
    @keywords = Feed.all.pluck(:keywords).flatten.uniq
    @client.filter(track: @keywords) unless @keywords.empty?
  end

  private

  def on_status(status)
    status = status.retweeted_status || status
    puts "#{status.text}"
    Tweet.create(
      status_id: status.id,
      text: status.text,
      retweet_count: status.retweet_count,
      created_at: status.created_at
    )
  end
end


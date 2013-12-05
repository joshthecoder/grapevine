class FeedStreamer
  def initialize
    @client = TweetStream::Client.new
    @client.on_timeline_status {|s| on_status(s)}
    @current_keywords = []
  end

  def start
    if needs_restart?
      @client.stop_stream
      @client.filter(track: @new_keywords)
      @current_keywords = @new_keywords
    end

    EM::Timer.new(30) { start }
  end

  private

  def needs_restart?
    (@new_keywords = Feed.all_keywords) != @current_keywords
  end

  def on_status(status)
    status = status.retweeted_status || status
    t = Tweet.find_or_create_by(status_id: status.id) do |t|
      t.text = status.text
      t.created_at = status.created_at
      t.user_screen_name = status.user.screen_name
      t.user_name = status.user.name
      t.user_avatar = status.user.profile_image_url
    end
    t.update_attribute(:retweet_count, status.retweet_count)
  end
end


class FeedStreamer
  def initialize
    @status = FeedStatus.instance
    @client = TweetStream::Client.new
    @client.on_timeline_status {|s| on_status(s)}
  end

  def start
    schedule_restart(30)
    load_keywords
    if @keywords.any?
      log_status "Working"
      @client.filter(track: @keywords)
    else
      log_status "Idle"
    end
  end

  def stop
    log_status "Stopped"
    @client.stop_stream
  end

  def schedule_restart(delay)
    EM::Timer.new(delay) {
      stop
    }
  end

  private

  def log_status(status)
    puts(status)
    @status.update_attribute(:status, status)
  end

  def on_status(status)
    status = status.retweeted_status || status
    puts "#{status.text}"
    Tweet.create(
      status_id: status.id,
      text: status.text,
      retweet_count: status.retweet_count,
      created_at: status.created_at
    )
    @status.inc(tweets_consumed: 1)
  end

  def load_keywords
    @keywords = Feed.all.pluck(:keywords).flatten.uniq
    @status.update_attribute(:keywords_count, @keywords.count)
  end
end


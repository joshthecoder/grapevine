require 'feed_streamer'

namespace :feed_streamer do
  desc "Start feed streamer"
  task :start => :environment do
    EM::run {
      FeedStreamer.new.start
    }
  end
end


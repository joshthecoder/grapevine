class FeedsController < ApplicationController
  before_action :load_feed, only: [:update, :tweets]

  def index
  end

  def create
    @feed = Feed.create(keywords: keywords)
    render json: @feed
  end

  def update
    @feed.update_attribute(:keywords, keywords)
    render json: @feed
  end

  def tweets
    render json: @feed.top_tweets
  end

  def status
    @status = FeedStatus.instance
    render "status", layout: "application"
  end

  private

  def load_feed
    @feed = Feed.find(params[:id])
  end

  def keywords
    params.require(:query).split
  end
end

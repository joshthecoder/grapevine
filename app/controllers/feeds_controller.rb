class FeedsController < ApplicationController
  before_action :load_feed, only: [:tweets]

  def index
  end

  def create
    @feed = Feed.create(keywords: params.require(:query).split) do |f|
      f.results = [{id: '123', text: 'works!'}]
    end
    render json: @feed
  end

  def tweets
    render json: @feed.top_tweets
  end

  private

  def load_feed
    @feed = Feed.find(params[:id])
  end
end

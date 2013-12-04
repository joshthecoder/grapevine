class FeedsController < ApplicationController
  def index
  end

  def create
    @feed = Feed.create(keywords: params.require(:query).split) do |f|
      f.results = [{id: '123', text: 'works!'}]
    end
    render json: @feed
  end
end

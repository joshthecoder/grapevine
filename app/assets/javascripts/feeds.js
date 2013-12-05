// --- Entities ---

var BaseModel = Backbone.Model.extend({
  parse: function(resp) {
    // Hack to make Backbone and MongoDB play nice.
    resp.id = resp._id.$oid;
    return resp;
  }
});

var Feed = BaseModel.extend({
  urlRoot: "/feeds"
});

var Tweet = BaseModel.extend({
});

var FeedTweets = Backbone.Collection.extend({
  model: Tweet,

  initialize: function(models, options) {
    this.feed = options.feed;
  },

  url: function() {
    return this.feed.url() + "/tweets";
  }
});


// --- Views ---

var FeedSearchView = Backbone.Marionette.ItemView.extend({
  template: "search",

  events: {
    "submit": "_onSubmit"
  },

  clear: function() {
    $("input").val("");
  },

  _onSubmit: function(e) {
    e.preventDefault();
    var query = this.$("input").val();
    query && this.trigger("feed:search", query);
  }
});

var TweetItemView = Backbone.Marionette.ItemView.extend({
  template: "tweet_item",

  templateHelpers: {
    autolink: function(text) {
      return new Handlebars.SafeString(twttr.txt.autoLink(twttr.txt.htmlEscape(text)));
    }
  }
});

var NoTweetsView = Backbone.Marionette.ItemView.extend({
  template: "no_tweets"
});

var TweetCollectionView = Backbone.Marionette.CollectionView.extend({
  itemView: TweetItemView,
  emptyView: NoTweetsView
});


// --- Controller ---
var FeedController = Marionette.Controller.extend({
  initialize: function() {
    this.feed = new Feed();
    this.tweets = new FeedTweets([], {feed: this.feed});
    _.bindAll(this, "refresh");
  },

  start: function() {
    this.showSearch();
  },

  showSearch: function() {
    this.searchView = new FeedSearchView({
      model: this.feed
    });
    this.listenTo(this.searchView, "feed:search", this.updateQuery);
    App.header.show(this.searchView);
  },

  showTweets: function() {
    this.tweetsView = new TweetCollectionView({
      collection: this.tweets
    });
    App.main.show(this.tweetsView);
  },

  updateQuery: function(query) {
    this.feed.save({query: query}, {success: this.refresh});
    this.searchView.clear();
    this.showTweets();
  },

  refresh: function() {
    this.tweets.fetch({reset: true});
    _.delay(this.refresh, 1000 * 10);
  }
});

App.addInitializer(function() {
  var ctrl = new FeedController();
  ctrl.start();
});


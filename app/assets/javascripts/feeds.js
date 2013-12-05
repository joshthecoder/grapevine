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

var FeedSearchView = Backbone.View.extend({
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


// --- Controller ---
var FeedController = Marionette.Controller.extend({
  initialize: function() {
    this.feed = new Feed();
    this.tweets = new FeedTweets([], {feed: this.feed});
    this.searchView = new FeedSearchView({
      el: $(".feed-search"),
      model: this.feed
    });
    this.listenTo(this.searchView, "feed:search", this.updateQuery);

    _.bindAll(this, "refresh");
  },

  startRefresh: function() {
    _.delay(this.refresh, 1000 * 30);
  },

  refresh: function() {
  },

  updateQuery: function(query) {
    this.feed.save({query: query});
    this.searchView.clear();
    //this.startRefresh();
  }
});

$(function() {
  var ctrl = window.feedCtrl = new FeedController();
});


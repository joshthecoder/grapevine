// --- Entities ---

var Feed = Backbone.Model.extend({
  urlRoot: "/feeds"
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
    this.searchView = new FeedSearchView({
      el: $(".feed-search"),
      model: this.feed
    });
    this.listenTo(this.searchView, "feed:search", this.updateQuery);
  },

  updateQuery: function(query) {
    this.feed.save({query: query});
    this.searchView.clear();
  }
});

$(function() {
  var ctrl = window.feedCtrl = new FeedController();
});


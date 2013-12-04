class Feed
  include Mongoid::Document
  field :keywords, type: Array
  field :results, type: Array
end


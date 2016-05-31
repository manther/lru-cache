require 'lib/lru-cacher'
class ItemLimited < LRUCacher
  def initialize(max_items)
    @max_items = max_items
    super()
  end

  def over_threshold?
    @table.size > @max_items
  end
end
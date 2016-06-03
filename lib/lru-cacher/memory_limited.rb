require 'lru-cacher'
require 'objspace'

class MemoryLimitedJ < LRUCacher
  def initialize(max_mem_size)
    @max_mem_size = max_mem_size
  end

  def over_threshold?
    ObjectSpace.memsize_of(@table) > @max_mem_size
  end
end
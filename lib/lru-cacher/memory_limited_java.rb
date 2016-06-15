require 'lru-cacher'
require 'java'
import java.lang.management.ManagementFactory

class MemoryLimitedJava < LRUCacher
  def initialize(max_mem_size)
    @max_mem_size = max_mem_size
    @mem_mx_bean  = ManagementFactory.get_memory_mx_bean    # Use the snake case version
    super()
  end

  def over_threshold?
    (@mem_mx_bean.heap_memory_usage.used / 1048576) > @max_mem_size
  end

  def pop
    super()
    # @mem_mx_bean.gc
  end

  def delete(key)
    super(key)
    # @mem_mx_bean.gc
  end
end
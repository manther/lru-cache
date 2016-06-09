require 'lru-cacher/node'

class LRUCacher
  def initialize
    @table = {}
    @head  = nil
    @tail  = nil
  end

  def set(key, value)
    new_node        = LRUCacher::Node.new(value, key, @tail, nil)
    @head           = new_node unless @tail
    @tail.next_node = new_node if @tail
    @tail           = new_node
    @table[key]     = new_node
    delete(@head.key) if @head && over_threshold?
  end

  def exists?(key)
    @table.key?(key)
  end

  def size
    @table.size
  end

  def get(key)
    current_node = @table[key]
    if current_node
      if @tail == current_node
        current_node
      elsif @head == current_node
        @head                  = current_node.next_node
        @head.prev_node        = nil
        current_node.prev_node = @tail
        current_node.next_node = nil
        @tail.next_node        = current_node
        @tail                  = current_node
      else
        current_node.prev_node.next_node = current_node.next_node
        current_node.next_node.prev_node = current_node.prev_node
        current_node.prev_node           = @tail
        current_node.next_node           = nil
        @tail.next_node                  = current_node
        @tail                            = current_node
      end
      current_node
    end
  end

  def delete(key)
    current_node = @table[key]
    if current_node
      if @head == current_node && @tail == current_node
        @head, @tail = nil
      elsif @head == current_node
        @head           = current_node.next_node
        @head.prev_node = nil
      elsif @tail == current_node
        @tail           = current_node.prev_node
        @tail.next_node = nil
      else
        current_node.prev_node.next_node = current_node.next_node
        current_node.next_node.prev_node = current_node.prev_node
      end
      @table.delete(key)
    end
  end
end

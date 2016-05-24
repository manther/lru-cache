# require "lru/cache/version"
module LRU
  class Cache
    attr_accessor :head, :tail, :num_items, :max_items, :table

    def initialize(max_items)
      @max_items = max_items
      @table     = {}
      @head      = nil
      @tail      = nil
      @num_items = 0
    end

    def set(key, value)
      if @table.size > @max_items
        @table.delete @head.key
        @head = @head.next_node
      end
      if !@table.key?(key)
        new_node   = Node.new value, key, @tail, nil
      else
        new_node       = @table[key]
        new_node.value = value
      end
      @head           = new_node if @tail == nil
      @tail.next_node = new_node if @tail != nil
      @tail           = new_node
      @table[key]     = new_node
    end

    def get(key)
      current_node = @table[key]
      if current_node
        return current_node if current_node.next_node == nil
        if current_node.prev_node != nil
          current_node.prev_node.next_node = current_node.next_node
        else
          @head           = current_node.next_node
          @head.prev_node = nil
        end
        @tail.next_node = current_node
        current_node.next_node   = nil
        current_node.prev_node   = @tail
        @tail           = current_node
      end
    end

    def delete(key)
      current_node = @table[key]
      if current_node
        if @head == current_node
          @head = current_node.next_node
        elsif @tail == current_node
          @tail = current_node.prev_node
        else
          current_node.prev_node.next_node = current_node.next_node
          current_node.next_node.prev_node = current_node.prev_node
        end
        @table.delete(key)
      end
    end
  end

  class Node
    attr_accessor :value, :next_node, :prev_node, :key

    def initialize(value, key, prev_node, next_node)
      @value     = value
      @prev_node = prev_node
      @next_node = next_node
      @key       = key
    end
  end
end


lru = LRU::Cache.new(3)
lru.set('a', 1)
lru.set('b', 2)
lru.set('c', 3)
lru.set('d', 3)
lru.set('e', 3)
lru.get('a')

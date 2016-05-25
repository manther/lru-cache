class LRUCacher
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
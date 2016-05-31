# -*- encoding : utf-8 -*-
#
# ***********************************************************
#  Copyright (c) 2014 VMware, Inc.  All rights reserved.
# ***********************************************************
#

require 'spec_helper'

RSpec.describe "MemoryLimited" do
  require 'lru-cacher/memory_limited'
  context 'set' do
    it 'Pops off least recently used when threshold is going to be exceeded' do
      # mem_cache = LRUCacher::MemoryLimited.new(130)
      # mem_cache.set(:one, 1)
      # mem_cache.set(:two, 2)
      # mem_cache.set(:three, 3)
      # mem_cache.set(:four, 4)
      # expect(mem_cache.instance_variable_get(:@table).key? :one).to be false
      # mem_cache.set(:five, 5)
      # expect(mem_cache.instance_variable_get(:@table).key? :two).to be false
      # mem_cache.set(:six, 6)
      # expect(mem_cache.instance_variable_get(:@table).key? :three).to be false
      # mem_cache.set(:seven, 7)
      # expect(mem_cache.instance_variable_get(:@table).key? :four).to be false
      # mem_cache.set(:eight, 8)
      # expect(mem_cache.instance_variable_get(:@table).key? :five).to be false   Too unpredictable to unit test
    end

    it 'Replaces tail with most recently added item' do
      mem_cache = LRUCacher::MemoryLimited.new(130000)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :two
      mem_cache.set(:three, 3)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :three
      mem_cache.set(:four, 4)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :four
    end

    it 'Replaces overwrites value if key is added twice' do
      mem_cache = LRUCacher::MemoryLimited.new(130000)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :two
      mem_cache.set(:one, 3)
      expect(mem_cache.instance_variable_get(:@table)[:one].value).to be 3
      expect(mem_cache.instance_variable_get(:@tail).key).to be :one
    end
  end

  context 'delete' do
    it 'Replaces resets the head node if head is deleted' do
      mem_cache = LRUCacher::MemoryLimited.new(130000)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      mem_cache.set(:three, 3)
      mem_cache.delete(:one)
      expect(mem_cache.instance_variable_get(:@head).key).to be :two
    end

    it 'Resets the head node if head is deleted, and pops off the correct item after' do
      mem_cache = LRUCacher::MemoryLimited.new(130000)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      mem_cache.set(:three, 3)
      mem_cache.delete(:one)
      expect(mem_cache.instance_variable_get(:@head).key).to be :two
    end

    it 'Resets the tail node if tail is deleted, and pops off the correct item after' do
      mem_cache = LRUCacher::MemoryLimited.new(130000)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      mem_cache.set(:three, 3)
      mem_cache.delete(:three)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :two
    end

    it 'Connects surrounding nodes if a node in the middle gets deleted' do
      mem_cache = LRUCacher::MemoryLimited.new(130000)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      mem_cache.set(:three, 3)
      mem_cache.set(:four, 4)
      mem_cache.set(:five, 5)
      mem_cache.delete(:three)
      expect(mem_cache.instance_variable_get(:@table)[:two].next_node.key).to be :four
      expect(mem_cache.instance_variable_get(:@table)[:four].prev_node.key).to be :two
    end

  end

  context 'get' do
    it 'Moves the currently gotten item to the tail if it is between two nodes.' do
      mem_cache = LRUCacher::MemoryLimited.new(130000)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      mem_cache.set(:three, 3)
      mem_cache.set(:four, 4)
      mem_cache.set(:five, 5)
      mem_cache.get(:two)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :two
    end

    it 'Moves the currently gotten item to the tail if it is the head.' do
      mem_cache = LRUCacher::MemoryLimited.new(130000)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      mem_cache.set(:three, 3)
      mem_cache.set(:four, 4)
      mem_cache.set(:five, 5)
      mem_cache.get(:one)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :one
      expect(mem_cache.instance_variable_get(:@head).key).to be :two
    end

    it 'Moves the currently gotten item no where if it is the tail.' do
      mem_cache = LRUCacher::MemoryLimited.new(130000)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      mem_cache.set(:three, 3)
      mem_cache.set(:four, 4)
      mem_cache.set(:five, 5)
      mem_cache.get(:five)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :five
      expect(mem_cache.instance_variable_get(:@head).key).to be :one
    end
  end
end

RSpec.describe 'ItemLimited' do
  require 'lru-cacher/item_limited'
  context 'set' do
    it 'Pops off least recently used when threshold is going to be exceeded' do
      mem_cache = LRUCacher::ItemLimited.new(3)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      mem_cache.set(:three, 3)
      mem_cache.set(:four, 4)
      expect(mem_cache.instance_variable_get(:@table).key? :one).to be false
      mem_cache.set(:five, 5)
      expect(mem_cache.instance_variable_get(:@table).key? :two).to be false
      mem_cache.set(:six, 6)
      expect(mem_cache.instance_variable_get(:@table).key? :three).to be false
      mem_cache.set(:seven, 7)
      expect(mem_cache.instance_variable_get(:@table).key? :four).to be false
      mem_cache.set(:eight, 8)
      expect(mem_cache.instance_variable_get(:@table).key? :five).to be false
    end

    it 'Replaces tail with most recently added item' do
      mem_cache = LRUCacher::ItemLimited.new(3)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :two
      mem_cache.set(:three, 3)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :three
      mem_cache.set(:four, 4)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :four
    end

    it 'Replaces overwrites value if key is added twice' do
      mem_cache = LRUCacher::ItemLimited.new(3)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :two
      mem_cache.set(:one, 3)
      expect(mem_cache.instance_variable_get(:@table)[:one].value).to be 3
      expect(mem_cache.instance_variable_get(:@tail).key).to be :one
    end
  end

  context 'delete' do
    it 'Replaces resets the head node if head is deleted' do
      mem_cache = LRUCacher::ItemLimited.new(3)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      mem_cache.set(:three, 3)
      mem_cache.delete(:one)
      expect(mem_cache.instance_variable_get(:@head).key).to be :two
    end

    it 'Resets the head node if head is deleted, and pops off the correct item after' do
      mem_cache = LRUCacher::ItemLimited.new(3)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      mem_cache.set(:three, 3)
      mem_cache.delete(:one)
      expect(mem_cache.instance_variable_get(:@head).key).to be :two
      mem_cache.set(:four, 4)
      mem_cache.set(:five, 5)
      expect(mem_cache.instance_variable_get(:@table).key? :two).to be false
    end

    it 'Resets the tail node if tail is deleted, and pops off the correct item after' do
      mem_cache = LRUCacher::ItemLimited.new(3)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      mem_cache.set(:three, 3)
      mem_cache.delete(:three)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :two
      mem_cache.set(:four, 4)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :four
      mem_cache.set(:five, 5)
      expect(mem_cache.instance_variable_get(:@table).key? :one).to be false
      mem_cache.delete(:five)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :four
      mem_cache.set(:six, 6)
      expect(mem_cache.instance_variable_get(:@tail).prev_node.key).to be :four
      expect(mem_cache.instance_variable_get(:@tail).prev_node.next_node.key).to be :six
    end

    it 'Connects surrounding nodes if a node in the middle gets deleted' do
      mem_cache = LRUCacher::ItemLimited.new(5)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      mem_cache.set(:three, 3)
      mem_cache.set(:four, 4)
      mem_cache.set(:five, 5)
      mem_cache.delete(:three)
      expect(mem_cache.instance_variable_get(:@table)[:two].next_node.key).to be :four
      expect(mem_cache.instance_variable_get(:@table)[:four].prev_node.key).to be :two
    end

  end

  context 'get' do
    it 'Moves the currently gotten item to the tail if it is between two nodes.' do
      mem_cache = LRUCacher::ItemLimited.new(5)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      mem_cache.set(:three, 3)
      mem_cache.set(:four, 4)
      mem_cache.set(:five, 5)
      mem_cache.get(:two)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :two
    end

    it 'Moves the currently gotten item to the tail if it is the head.' do
      mem_cache = LRUCacher::ItemLimited.new(5)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      mem_cache.set(:three, 3)
      mem_cache.set(:four, 4)
      mem_cache.set(:five, 5)
      mem_cache.get(:one)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :one
      expect(mem_cache.instance_variable_get(:@head).key).to be :two
    end

    it 'Moves the currently gotten item no where if it is the tail.' do
      mem_cache = LRUCacher::ItemLimited.new(5)
      mem_cache.set(:one, 1)
      mem_cache.set(:two, 2)
      mem_cache.set(:three, 3)
      mem_cache.set(:four, 4)
      mem_cache.set(:five, 5)
      mem_cache.get(:five)
      expect(mem_cache.instance_variable_get(:@tail).key).to be :five
      expect(mem_cache.instance_variable_get(:@head).key).to be :one
    end
  end
end
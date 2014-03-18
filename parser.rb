# A simple tree-node class:
class Node
  attr_accessor :children, :parent, :type, :content, :index

  def initialize
    self.children = []
    self.parent = nil
    self.type = ''
    self.content = ''
    self.index = nil
  end

  RELATION_TYPES = %w(NP VP ADJP PP ADVP)

  # Iterative lexer and descent parser in one:
  def self.from_parse_tree(string)
    cursor = self.new
    i = -1

    while (i += 1) < string.length do
      # Descend:
      if string[i] == '('
        cursor.children << (node = self.new)
        node.parent, cursor = cursor, node
        cursor.type << string[i] while string[(i += 1)] != ' '
      # Ascend:
      elsif string[i] == ')'
        cursor = cursor.parent
      # Accept:
      elsif string[i] != ' '
        cursor.content << string[i]
      end
    end

    root = cursor.children[0]
    root.index_content_nodes!
    root
  end

  def inspect(depth = 0)
    "#{"   " * depth}(#{self.type}) #{self.content} [#{self.index}]\n" +
      children.map { |child| child.inspect(depth + 1) }.join
  end

  def to_s
    self.content + children.map(&:to_s).join(' ')
  end

  def phrases
    (self.phrase? ? [self] : []) + children.flat_map(&:phrases)
  end

  def phrase?
    RELATION_TYPES.include?(self.type)
  end

  def index_content_nodes!(index = 0)
    unless self.content.nil? || self.content.empty?
      self.index = index
      index += 1
    end
    self.children.each { |child| index = child.index_content_nodes!(index) }
    index
  end

  def indices_of_content_nodes
    (self.index ? [self.index] : []) + children.flat_map(&:indices_of_content_nodes)
  end
end

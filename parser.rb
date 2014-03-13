# A simple tree-node class:
class Node
  attr_accessor :children, :parent, :type, :content

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

    return cursor.children[0]
  end

  def initialize
    self.children, self.type, self.content = [], '', ''
  end

  def inspect(depth = 0)
    "#{"   " * depth}(#{self.type}) #{self.content}\n" +
      children.map { |child| child.inspect(depth + 1) }.join
  end

  def to_s
    self.content + children.map(&:to_s).join(' ')
  end

  def phrases
    ((self.is_phrase? ? [self] : []) + children.map(&:phrases))
      .flatten
  end

  def is_phrase?
    %w{NP VP ADJP PP}.include? self.type
  end
end


# Usage test:
puts Node.from_parse_tree('(ROOT (S (NP (PRP I)) (VP (VBD put) (NP (DT the) (NN book)) (PRT (RP down)) (PP (IN on) (NP (DT the) (NN coffee) (NN table)))) (. .)))').inspect
puts Node.from_parse_tree('(ROOT (S (NP (NNP Walter) (NNP White)) (VP (VBD was) (ADJP (VBN annoyed) (PP (IN by) (NP (DT the) (VBG buzzing) (NN fly))))) (. .)))').phrases

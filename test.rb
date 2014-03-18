require "minitest/autorun"
require "./parser"
class ParserTest < Minitest::Test
  def test_parser
    example = '(ROOT (S (NP (NNP Walter) (NNP White)) (VP (VBD was) (ADJP (VBN annoyed) (PP (IN by) (NP (DT the) (VBG buzzing) (NN fly))))) (. .)))'
    node = Node.from_parse_tree(example)
    assert_equal 5, node.phrases.size
    assert phrase = node.phrases.first
    assert phrase.is_a?(Node)
    assert_equal "NP", phrase.type
    assert_equal 2, phrase.children.size
    assert phrase.parent.is_a?(Node)
    assert_equal "", phrase.content
    assert !phrase.index
    assert_equal "Walter", phrase.children[0].content
    assert_equal 0, phrase.children[0].index
    assert_equal "White", phrase.children[1].content
    assert_equal 1, phrase.children[1].index
  end
end

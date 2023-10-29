# frozen_string_literal: true

require_relative '../../../test_helper'

class RedundantMessageArgumentTest < Minitest::Test
  def test_registers_offense_when_using_redundant_message_argument_in_assert
    assert_offense(<<~RUBY)
      assert(test, nil)
                   ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      assert(test)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_assert_empty
    assert_offense(<<~RUBY)
      assert_empty(obj, nil)
                        ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      assert_empty(obj)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_assert_equal
    assert_offense(<<~RUBY)
      assert_equal(exp, act, nil)
                             ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      assert_equal(exp, act)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_assert_in_delta
    assert_offense(<<~RUBY)
      assert_in_delta(exp, act, delta, nil)
                                       ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      assert_in_delta(exp, act, delta)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_assert_in_epsilon
    assert_offense(<<~RUBY)
      assert_in_epsilon(exp, act, epsilon, nil)
                                           ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      assert_in_epsilon(exp, act, epsilon)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_assert_includes
    assert_offense(<<~RUBY)
      assert_includes(collection, obj, nil)
                                       ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      assert_includes(collection, obj)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_assert_instance_of
    assert_offense(<<~RUBY)
      assert_instance_of(cls, obj, nil)
                                   ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      assert_instance_of(cls, obj)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_assert_kind_of
    assert_offense(<<~RUBY)
      assert_kind_of(cls, obj, nil)
                               ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      assert_kind_of(cls, obj)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_assert_match
    assert_offense(<<~RUBY)
      assert_match(matcher, obj, nil)
                                 ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      assert_match(matcher, obj)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_assert_nil
    assert_offense(<<~RUBY)
      assert_nil(obj, nil)
                      ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      assert_nil(obj)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_assert_operator
    assert_offense(<<~RUBY)
      assert_operator(o1, op, op, nil)
                                  ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      assert_operator(o1, op, op)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_assert_path_exists
    assert_offense(<<~RUBY)
      assert_path_exists(path, nil)
                               ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      assert_path_exists(path)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_assert_predicate
    assert_offense(<<~RUBY)
      assert_predicate(o1, op, nil)
                               ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      assert_predicate(o1, op)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_assert_respond_to
    assert_offense(<<~RUBY)
      assert_respond_to(obj, meth, nil)
                                   ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      assert_respond_to(obj, meth)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_assert_same
    assert_offense(<<~RUBY)
      assert_same(exp, act, nil)
                            ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      assert_same(exp, act)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_assert_throws
    assert_offense(<<~RUBY)
      assert_throws(sym, nil)
                         ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      assert_throws(sym)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_flunk
    assert_offense(<<~RUBY)
      flunk(nil)
            ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      flunk()
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_refute
    assert_offense(<<~RUBY)
      refute(test, nil)
                   ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      refute(test)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_refute_empty
    assert_offense(<<~RUBY)
      refute_empty(obj, nil)
                        ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      refute_empty(obj)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_refute_equal
    assert_offense(<<~RUBY)
      refute_equal(exp, act, nil)
                             ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      refute_equal(exp, act)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_refute_in_delta
    assert_offense(<<~RUBY)
      refute_in_delta(exp, act, delta, nil)
                                       ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      refute_in_delta(exp, act, delta)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_refute_in_epsilon
    assert_offense(<<~RUBY)
      refute_in_epsilon(exp, act, epsilon, nil)
                                           ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      refute_in_epsilon(exp, act, epsilon)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_refute_includes
    assert_offense(<<~RUBY)
      refute_includes(collection, obj, nil)
                                       ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      refute_includes(collection, obj)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_refute_instance_of
    assert_offense(<<~RUBY)
      refute_instance_of(cls, obj, nil)
                                   ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      refute_instance_of(cls, obj)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_refute_kind_of
    assert_offense(<<~RUBY)
      refute_kind_of(cls, obj, nil)
                               ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      refute_kind_of(cls, obj)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_refute_match
    assert_offense(<<~RUBY)
      refute_match(matcher, obj, nil)
                                 ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      refute_match(matcher, obj)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_refute_nil
    assert_offense(<<~RUBY)
      refute_nil(obj, nil)
                      ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      refute_nil(obj)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_refute_operator
    assert_offense(<<~RUBY)
      refute_operator(o1, op, op, nil)
                                  ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      refute_operator(o1, op, op)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_refute_path_exists
    assert_offense(<<~RUBY)
      refute_path_exists(path, nil)
                               ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      refute_path_exists(path)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_refute_predicate
    assert_offense(<<~RUBY)
      refute_predicate(o1, op, nil)
                               ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      refute_predicate(o1, op)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_refute_respond_to
    assert_offense(<<~RUBY)
      refute_respond_to(obj, meth, nil)
                                   ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      refute_respond_to(obj, meth)
    RUBY
  end

  def test_registers_offense_when_using_redundant_message_argument_in_refute_same
    assert_offense(<<~RUBY)
      refute_same(exp, act, nil)
                            ^^^ Remove the redundant message argument.
    RUBY

    assert_correction(<<~RUBY)
      refute_same(exp, act)
    RUBY
  end

  def test_does_not_register_offense_when_using_useful_message_argument_in_assert
    assert_no_offenses(<<~RUBY)
      assert(test, 'message')
    RUBY
  end
end

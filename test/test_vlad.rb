require 'test/unit'
require 'vlad'

class TestVlad < Test::Unit::TestCase
  def setup
    @vlad = Vlad.instance
    @vlad.reset
  end

  def test_set
    @vlad.set :foo, 5
    assert_equal 5, @vlad.foo
  end

  def test_set_lazy_block_evaluation
    @vlad.set(:foo) { fail "lose" }
    assert_raise(RuntimeError) { @vlad.foo }
  end

  def test_set_with_block
    x = 1
    @vlad.set(:foo) { x += 2 }

    assert_equal 3, @vlad.foo
    assert_equal 3, @vlad.foo
  end

  def test_set_with_nil
    @vlad.set(:foo, nil)
    assert_equal nil, @vlad.foo
  end

  def test_role
    @vlad.role :app, "foo.example.com"
    expected = {"foo.example.com" => {}}
    assert_equal expected, @vlad.roles[:app]
  end

  def test_role_multiple
    @vlad.role :app, "foo.example.com"
    @vlad.role :app, "yarr.example.com", :no_release => true
    expected = {
      "foo.example.com" => {},
      "yarr.example.com" => {:no_release => true}
    }
    assert_equal expected, @vlad.roles[:app]
  end
end


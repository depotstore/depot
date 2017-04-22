require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "shouldn't delete last user" do
    assert_raises (User::Error) {User.destroy_all}
  end

end

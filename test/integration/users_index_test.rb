require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'ul.pagination'
    assert User.page(1).count == 10
    users = User.all
    assert_select 'a[href=?]', user_path(@admin), count: 2
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  # test "the truth" do
  #   assert true
  # end
end

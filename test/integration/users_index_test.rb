require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "index including pagination" do
    log_in_as @user
    get users_path
    assert_template 'users/index'
    assert_select 'ul.pagination'
    assert User.page(1).count == 10
    users = User.all
    assert_select 'a[href=?]', user_path(@user), text: @user.name
  end

  # test "the truth" do
  #   assert true
  # end
end

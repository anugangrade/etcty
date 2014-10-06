require 'test_helper'

class CoupensControllerTest < ActionController::TestCase
  setup do
    @coupen = coupens(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:coupens)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create coupen" do
    assert_difference('Coupen.count') do
      post :create, coupen: { end_date: @coupen.end_date, image: @coupen.image, start_date: @coupen.start_date, title: @coupen.title, user_id: @coupen.user_id, web_link: @coupen.web_link }
    end

    assert_redirected_to coupen_path(assigns(:coupen))
  end

  test "should show coupen" do
    get :show, id: @coupen
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @coupen
    assert_response :success
  end

  test "should update coupen" do
    patch :update, id: @coupen, coupen: { end_date: @coupen.end_date, image: @coupen.image, start_date: @coupen.start_date, title: @coupen.title, user_id: @coupen.user_id, web_link: @coupen.web_link }
    assert_redirected_to coupen_path(assigns(:coupen))
  end

  test "should destroy coupen" do
    assert_difference('Coupen.count', -1) do
      delete :destroy, id: @coupen
    end

    assert_redirected_to coupens_path
  end
end

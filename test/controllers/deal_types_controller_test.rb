require 'test_helper'

class DealTypesControllerTest < ActionController::TestCase
  setup do
    @deal_type = deal_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:deal_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create deal_type" do
    assert_difference('DealType.count') do
      post :create, deal_type: { amount: @deal_type.amount, name: @deal_type.name }
    end

    assert_redirected_to deal_type_path(assigns(:deal_type))
  end

  test "should show deal_type" do
    get :show, id: @deal_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @deal_type
    assert_response :success
  end

  test "should update deal_type" do
    patch :update, id: @deal_type, deal_type: { amount: @deal_type.amount, name: @deal_type.name }
    assert_redirected_to deal_type_path(assigns(:deal_type))
  end

  test "should destroy deal_type" do
    assert_difference('DealType.count', -1) do
      delete :destroy, id: @deal_type
    end

    assert_redirected_to deal_types_path
  end
end

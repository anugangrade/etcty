require 'test_helper'

class VideoAdvsControllerTest < ActionController::TestCase
  setup do
    @video_adv = video_advs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:video_advs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create video_adv" do
    assert_difference('VideoAdv.count') do
      post :create, video_adv: { end_date: @video_adv.end_date, start_date: @video_adv.start_date, title: @video_adv.title, user_id: @video_adv.user_id, youtube_url: @video_adv.youtube_url }
    end

    assert_redirected_to video_adv_path(assigns(:video_adv))
  end

  test "should show video_adv" do
    get :show, id: @video_adv
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @video_adv
    assert_response :success
  end

  test "should update video_adv" do
    patch :update, id: @video_adv, video_adv: { end_date: @video_adv.end_date, start_date: @video_adv.start_date, title: @video_adv.title, user_id: @video_adv.user_id, youtube_url: @video_adv.youtube_url }
    assert_redirected_to video_adv_path(assigns(:video_adv))
  end

  test "should destroy video_adv" do
    assert_difference('VideoAdv.count', -1) do
      delete :destroy, id: @video_adv
    end

    assert_redirected_to video_advs_path
  end
end

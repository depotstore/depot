require 'test_helper'

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @review = reviews(:one)
    @product = products(:one)
  end

  test "should get index" do
    get product_reviews_url(@product)
    assert_response :success
  end

  test "should get new" do
    get new_product_review_url(@product)
    assert_response :success
  end

  test "should create review" do
    assert_difference('Review.count') do
      post product_reviews_path(@product), params: { review:
        { author: @review.author, rating: @review.rating, text: @review.text} }
    end

    assert_redirected_to product_review_url(@product, Review.last)
  end

  test "should show review" do
    get product_review_url(@product, @review)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_review_url(@product, @review)
    assert_response :success
  end

  test "should update review" do
    patch product_review_url(@product, @review), params: { review:
      { author: @review.author, rating: @review.rating, text: @review.text } }
    assert_redirected_to product_review_url(@product, @review)
  end

  test "should destroy review" do
    assert_difference('Review.count', -1) do
      delete product_review_url(@product, @review)
    end

    assert_redirected_to product_reviews_url
  end
end

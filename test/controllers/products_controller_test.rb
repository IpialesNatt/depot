require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    @title = "The Great Book #{rand(1000)}"
    login_as users(:one) # Ensure the user is authenticated
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference("Product.count") do
      post products_url, params: {
        product: {
          description: @product.description,
          image: file_fixture_upload("lorem.jpg", "image/jpeg"),
          price: @product.price,
          title: @title
        }
      }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: {
      product: {
        description: @product.description,
        image: file_fixture_upload("lorem.jpg", "image/jpeg"),
        price: @product.price,
        title: @title
      }
    }

    assert_redirected_to product_url(@product)
  end

# test "should destroy product" do
#   product_to_destroy = products(:two)
#  puts "Producto a destruir ID: #{product_to_destroy.id}"
#  assert_raises ActiveRecord::RecordNotDestroyed do
#    delete product_url(product_to_destroy)
#  end
#  assert Product.exists?(product_to_destroy.id)
# end

test "should not destroy product with line items" do
  product = Product.new(
    title: "Test Product #{rand(1000)}",
    description: "Description",
    price: 10.0
  )

  product.image.attach(
    io: File.open(Rails.root.join("test/fixtures/files/lorem.jpg")),
    filename: "lorem.jpg",
    content_type: "image/jpeg"
  )

  product.save!

  cart = carts(:one)
  LineItem.create!(product: product, cart: cart, quantity: 1)

  assert_raises ActiveRecord::RecordNotDestroyed do
    product.destroy!
  end

  assert Product.exists?(product.id), "El producto no debe haberse destruido"
end
end

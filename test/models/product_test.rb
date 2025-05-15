require "test_helper"

class ProductTest < ActiveSupport::TestCase
  fixtures :products 
  test "product attributes must not be empty" do
product = Product.new
assert product.invalid?
assert product.errors[:title].any?
assert product.errors[:description].any?
assert product.errors[:price].any?
assert product.errors[:image].any?
end

test "product price must be positive" do
  product = Product.new(title: "My Book Title", description: "yyy")
  product.image.attach(io: File.open("test/fixtures/files/lorem.jpg"), 
                   filename: "lorem.jpg", content_type: "image/jpeg")
  
  # Precio negativo
  product.price = -1
  assert product.invalid?
  assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
  
  # Precio cero
  product.price = 0
  assert product.invalid?
  
  # Precio válido
  product.price = 1
  assert product.valid?
end

test "image url" do
  # Imagen válida (JPG)
  product = Product.new(title: "My Book", description: "yyy", price: 1)
  product.image.attach(io: File.open("test/fixtures/files/lorem.jpg"),
                   filename: "lorem.jpg", content_type: "image/jpeg")
  assert product.valid?, "image/jpeg must be valid"
  
  # Imagen inválida (SVG)
  product = Product.new(title: "My Book", description: "yyy", price: 1)
  product.image.attach(io: File.open("test/fixtures/files/logo.svg"),
                   filename: "logo.svg", content_type: "image/svg+xml")
  assert_not product.valid?, "image/svg+xml must be invalid"
end

test "product is not valid without a unique title" do
  # 1. Crea un nuevo producto con el mismo título que uno existente
  product = Product.new(
    title: products(:pragprog).title, # Usa el título del fixture existente
    description: "yyy",
    price: 1
  )
  
  # 2. Adjunta una imagen (requerida por tus validaciones)
  product.image.attach(
    io: File.open("test/fixtures/files/lorem.jpg"),
    filename: "lorem.jpg", 
    content_type: "image/jpeg"
  )
  
  # 3. Verificaciones
  assert product.invalid? # El producto no debería ser válido
  assert_equal ["has already been taken"], product.errors[:title] # Mensaje de error esperado
end
# Este test es de internalizacion, comentamos el anterior porque es lo mismo
test "product is not valid without a unique title - i18n" do
  product = Product.new(
    title: products(:pragprog).title,
    description: "yyy",
    price: 1
  )
  product.image.attach(io: File.open("test/fixtures/files/lorem.jpg"),
                     filename: "lorem.jpg", 
                     content_type: "image/jpeg")
  assert product.invalid?
  assert_equal [I18n.t("errors.messages.taken")], product.errors[:title]
end

end

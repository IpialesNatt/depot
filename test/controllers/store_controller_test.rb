require "test_helper"

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get store_index_url
    assert_response :success

    # Nuevas aserciones:
    assert_select "nav a", minimum: 4       # ¿Hay al menos 4 enlaces en la barra de navegación?
     assert_select "main ul li", { minimum: 3 } # Verifica al menos 3 productos
    assert_select "h2", "The Pragmatic Programmer"  # ¿Existe un título específico?
    assert_select "div", /\$[,\d]+\.\d\d/   # ¿Los precios tienen formato monetario (ej: $19,99)?
  end
end

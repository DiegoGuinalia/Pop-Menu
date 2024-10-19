require 'rails_helper'

RSpec.describe Api::V1::MenusController, type: :controller do
  let!(:restaurant) { FactoryBot.create(:restaurant) }
  let!(:menu) { FactoryBot.create(:menu, restaurant: restaurant) }
  let!(:item) { FactoryBot.create(:item, name: 'Burger') }
  let!(:item_2) { FactoryBot.create(:item, name: 'Salad') }
  let!(:menu_item_1) { FactoryBot.create(:menu_item, menu: menu, item: item, price: 9.0) }
  let!(:menu_item_2) {
    FactoryBot.create(
      :menu_item,
      menu: menu,
      item: item_2, price: 5.0
    )
  }

  describe 'GET #index' do
    it 'returns a list of menus with pagination' do
      get :index, params: { page: 1, per_page: 3 }
      expect(response).to be_successful

      json_response = JSON.parse(response.body)

      expect(json_response['pagination']).to be_present
      expect(json_response['pagination']['found']).to eq(1)
      expect(json_response['pagination']['pages']).to eq(1)
      expect(json_response['pagination']['current_page']).to eq(1)
      expect(json_response['pagination']['per_page']).to eq(3)

      expect(json_response['entries']).to be_present
      expect(json_response['entries'].count).to eq(1)

      expect(json_response['entries'].first).to include(
        'id' => menu.id,
        'name' => menu.name,
        'restaurant_id' => restaurant.id,
        'restaurant_name' => restaurant.name,
        'menu_items' => a_kind_of(Array)
      )

      expect(json_response['entries'].first['menu_items']).to include(
        {
          'id' => menu_item_1.id,
          'name' => item.name,
          'price' => menu_item_1.price.to_s,
          'menu_id' => menu_item_1.menu_id
        },
        {
          'id' => menu_item_2.id,
          'name' => item_2.name,
          'price' => menu_item_2.price.to_s,
          'menu_id' => menu_item_2.menu_id
        }
      )
    end
  end

  describe 'GET #show' do
    it 'returns the menu' do
      get :show, params: { id: menu.id }
      expect(response).to be_successful
      expect(json_response['data']['id']).to eq(menu.id)
    end

    it 'returns not found if menu does not exist' do
      get :show, params: { id: 9999 }
      expect(json_response['messages']).to eq('not found')
    end
  end

  describe 'POST #create_or_update' do
    let(:menu_params) do
      {
        "name": "Dinner1",
        "restaurant_name": "New Restaurant",
        "menu_items": [
            {
                "name": "fish",
                "price": "1.8"
            },
            {
                "name": "rice",
                "price": "2.5"
            }
        ]
     }
    end

    it 'creates a new menu' do
      expect {
        post :create_or_update, params: menu_params
      }.to change(Menu, :count).by(1)
      expect(response).to be_successful
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the menu' do
      delete :destroy, params: { ids: [menu.id] }
      expect(response).to have_http_status(:success)
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end

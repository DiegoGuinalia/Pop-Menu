require 'rails_helper'

RSpec.describe Api::V1::MenuItemsController, type: :controller do
  let!(:menu) { FactoryBot.create(:menu) }
  let!(:item) { FactoryBot.create(:item, name: 'Burger') }
  let!(:item_2) { FactoryBot.create(:item, name: 'Salad') }
  let!(:menu_item) { FactoryBot.create(:menu_item, menu: menu, item: item, price: 9.0) }
  let!(:menu_item_2) {
    FactoryBot.create(
      :menu_item,
      menu: menu,
      item: item_2, price: 5.0
    )
  }

  describe 'GET #index' do
    it 'returns a list of menu items with pagination' do
      get :index, params: { page: 1, per_page: 2 }
      expect(response).to be_successful

      json_response = JSON.parse(response.body)

      expect(json_response['pagination']).to be_present
      expect(json_response['pagination']['found']).to eq(2)
      expect(json_response['pagination']['pages']).to eq(1)
      expect(json_response['pagination']['current_page']).to eq(1)
      expect(json_response['pagination']['per_page']).to eq(2)

      expect(json_response['entries']).to be_present
      expect(json_response['entries'].count).to eq(2)

      # Check the structure of the first menu item
      expect(json_response['entries'].first).to include(
        'id' => menu_item.id,
        'name' => item.name,
        'price' => menu_item.price.to_s,
        'menu_id' => menu_item.menu_id
      )
    end

    it 'handles exceptions' do
      allow(MenuItem).to receive(:order).and_raise(StandardError.new("Some error"))
      get :index
      expect(response).to have_http_status(:bad_request)
      expect(json_response['messages']).to eq('Some error')
    end
  end

  describe 'GET #show' do
    it 'returns the menu item' do
      get :show, params: { id: menu_item.id }
      expect(response).to be_successful
      expect(json_response['data']['id']).to eq(menu_item.id)
    end

    it 'returns not found if menu item does not exist' do
      get :show, params: { id: 9999 }
      expect(json_response['messages']).to eq('not found')
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the menu item' do
      expect {
        delete :destroy, params: { ids: [menu_item.id] }
      }.to change(MenuItem, :count).by(-1)
      expect(response).to be_successful
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end

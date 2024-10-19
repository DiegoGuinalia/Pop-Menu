require 'rails_helper'

RSpec.describe Api::V1::ItemsController, type: :controller do
  let!(:item) { FactoryBot.create(:item, name: 'Burger') }
  let!(:item_2) { FactoryBot.create(:item, name: 'meatballs') }

  describe 'GET #index' do
    it 'returns a list of items with pagination' do
      get :index, params: { page: 1, per_page: 2 }
      expect(response).to be_successful

      json_response = JSON.parse(response.body)

      expect(json_response['pagination']).to be_present
      expect(json_response['pagination']['found']).to eq(2)
      expect(json_response['pagination']['pages']).to eq(1) # since we have only 2 items and are fetching 2 per page
      expect(json_response['pagination']['current_page']).to eq(1)
      expect(json_response['pagination']['per_page']).to eq(2)

      expect(json_response['entries']).to be_present
      expect(json_response['entries'].count).to eq(2) # Ensure only the created items are returned

      # Check the structure of the first item
      expect(json_response['entries'].first).to include(
        'id' => item.id,
        'name' => item.name
      )
    end

    it 'handles exceptions' do
      allow(Item).to receive(:order).and_raise(StandardError.new("Some error"))
      get :index
      expect(response).to have_http_status(:bad_request)
      expect(json_response['messages']).to eq('Some error')
    end
  end

  describe 'GET #show' do
    it 'returns the item' do
      get :show, params: { id: item.id }
      expect(response).to be_successful
      expect(json_response['data']['id']).to eq(item.id)
    end

    it 'returns not found if item does not exist' do
      get :show, params: { id: 9999 }
      expect(json_response['messages']).to eq('not found')
    end
  end

  describe 'POST #create_or_update' do
    context 'when creating a new item' do
      let(:item_params) { { name: 'New Item' } }

      it 'creates a new item' do
        expect {
          post :create_or_update, params: item_params
        }.to change(Item, :count).by(1)
        expect(response).to be_successful
      end
    end

    context 'when updating an existing item' do
      let(:item_params) { { id: item.id, name: 'Updated Item' } }

      it 'updates the existing item' do
        post :create_or_update, params: item_params
        expect(item.reload.name).to eq('Updated Item')
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the item' do
      byebug
      expect {
        delete :destroy, params: { ids: [item.id] }
      }.to change(Item, :count).by(-1)
      expect(response).to be_successful
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end

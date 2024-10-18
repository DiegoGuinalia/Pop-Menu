require 'rails_helper'

RSpec.describe Api::V1::RestaurantsController, type: :controller do
  let(:valid_attributes) { { name: 'Test Restaurant' } }
  let(:invalid_attributes) { { name: '' } }

  describe 'GET #index' do
    it 'returns a paginated list of restaurants' do
      FactoryBot.create_list(:restaurant, 5)

      get :index, params: { page: 1, per_page: 2 }
      expect(response).to have_http_status(:success)
      expect(json_response['pagination']['found']).to eq(5)
      expect(json_response['entries'].size).to eq(2)
    end

    it 'returns an error if an exception occurs' do
      allow(Restaurant).to receive(:order).and_raise(StandardError.new('Some error'))

      get :index
      expect(response).to have_http_status(:bad_request)
      expect(json_response['messages']).to include('Some error')
    end
  end

  describe 'GET #show' do
    let(:restaurant) { FactoryBot.create(:restaurant) }

    it 'returns the restaurant' do
      get :show, params: { id: restaurant.id }
      expect(response).to have_http_status(:success)
      expect(json_response['data']['name']).to eq(restaurant.name)
    end

    it 'returns an error if the restaurant is not found' do
      get :show, params: { id: 9999 }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['messages']).to include('not found')
    end
  end

  describe 'POST #create_or_update' do
    it 'creates a new restaurant' do
      post :create_or_update, params: valid_attributes
      expect(response).to have_http_status(:success)
      expect(json_response['data']['name']).to eq('Test Restaurant')
    end

    it 'returns an error if the restaurant is invalid' do
      post :create_or_update, params: invalid_attributes
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['messages']).to eq('unexpected error has occurred')
    end
  end

  describe 'DELETE #destroy' do
    let!(:restaurant) { FactoryBot.create(:restaurant) }

    it 'deletes the restaurant' do
      delete :destroy, params: { ids: [restaurant.id] }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #upload' do
    let(:file) { fixture_file_upload('test_file.json', 'application/json') }

    context 'when the file is valid' do
      let(:processed_items) {
        {
          "processed_items" => [
            {
              "menu_items" => [
                {
                  "name" => "Burger",
                  "price" => "9.0"
                }
              ]
            }
          ]
        }
      }

      let(:result) { double(success?: true, failure?: false, processed_items: processed_items, unprocessed_items: []) }

      before do
        allow(FileUpload::Json).to receive(:call).with(hash_including(file: instance_of(ActionDispatch::Http::UploadedFile))).and_return(result)
      end

      it 'uploads a valid file' do
        post :upload, params: { file: file }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include(
          'data' => {
            'processed_items' => {
              'processed_items' => processed_items['processed_items'],
            },
            'unprocessed_items' => []
          },
          'messages' => 'OK',
          'result' => 'success'
        )
      end
    end

    context 'when the file is not provided' do
      it 'returns an error when file is not provided' do
        post :upload, params: {}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['messages']).to include('File not found')
      end
    end

    context 'when the file upload fails' do
      it 'returns an error when the file upload fails' do
        allow(FileUpload::Json).to receive(:call).and_return(double(success?: false, failure?: true, error: 'Upload error'))

        post :upload, params: { file: file }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['messages']).to include('Upload error')
      end
    end
  end



  private

  def json_response
    JSON.parse(response.body)
  end
end

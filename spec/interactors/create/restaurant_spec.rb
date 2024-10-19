require 'rails_helper'

RSpec.describe Create::Restaurant do
  let(:params) { { restaurant_name: 'Pasta Place' } }
  let(:context) { { params: params, restaurant_data: {} } }
  subject(:interactor) { described_class.call(context) }

  describe '#call' do
    context 'when creating a new restaurant' do
      let(:params) { { name: 'Pasta Place' } }
      let(:restaurant_data) { { name: 'Pasta Place' } }

      before do
        context[:restaurant_data] = restaurant_data
      end

      it 'creates a new restaurant with the given name' do
        expect { interactor }.to change { Restaurant.count }.by(1)
        expect(interactor.restaurant.name).to eq('Pasta Place')
      end
    end

    context 'when updating an existing restaurant' do
      let!(:existing_restaurant) { FactoryBot.create(:restaurant, name: 'Pasta Place') }
      let(:params) { { id: existing_restaurant.id, restaurant_name: 'Pasta Paradise' } }

      it 'updates the existing restaurant name' do
        interactor
        expect(existing_restaurant.reload.name).to eq('Pasta Paradise')
      end

      it 'sets the updated restaurant in the context' do
        interactor
        expect(interactor.restaurant).to eq(existing_restaurant)
      end
    end

    context 'when trying to create a restaurant with an existing name' do
      let!(:existing_restaurant) { FactoryBot.create(:restaurant, name: 'Pasta Place') }
      let(:params) { { restaurant_name: 'Pasta Place' } }

      it 'does not create a new restaurant' do
        expect { interactor }.not_to change { Restaurant.count }
      end

      it 'sets the existing restaurant in the context' do
        interactor
        expect(interactor.restaurant).to eq(existing_restaurant)
      end
    end
  end
end

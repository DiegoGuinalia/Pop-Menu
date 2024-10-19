require 'rails_helper'

RSpec.describe Delete::Restaurants do
  let!(:restaurant1) { FactoryBot.create(:restaurant) }
  let!(:restaurant2) { FactoryBot.create(:restaurant) }
  let!(:restaurant3) { FactoryBot.create(:restaurant) }

  let(:context) { { params: { ids: [restaurant1.id, restaurant2.id, 'invalid_id', nil] } } }

  subject(:interactor) { described_class.call(context) }

  describe '#call' do
    context 'when called with valid ids' do
      it 'deletes the specified restaurants' do
        expect { interactor }.to change { Restaurant.count }.by(-2)
      end

      it 'sets deleted_restaurant_ids in the context' do
        interactor
        expect(interactor.deleted_restaurant_ids).to eq({ deleted_restaurant_ids: [restaurant1.id, restaurant2.id] })
      end
    end

    context 'when no valid ids are provided' do
      let(:context) { { params: { ids: ['invalid_id', nil] } } }

      it 'does not delete any restaurants' do
        expect { interactor }.not_to change { Restaurant.count }
      end

      it 'sets deleted_restaurant_ids in the context to an empty array' do
        interactor
        expect(interactor.deleted_restaurant_ids).to eq({ deleted_restaurant_ids: [] })
      end
    end

    context 'when some ids are invalid' do
      it 'only deletes the valid restaurants' do
        expect { interactor }.to change { Restaurant.count }.by(-2)
      end
    end
  end
end

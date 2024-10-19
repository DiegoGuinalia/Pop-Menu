require 'rails_helper'

RSpec.describe Delete::Items do
  let!(:item1) { FactoryBot.create(:item) }
  let!(:item2) { FactoryBot.create(:item) }
  let!(:item3) { FactoryBot.create(:item) }

  let(:context) { { params: { ids: [item1.id, item2.id, 'three', nil] } } }

  subject(:interactor) { described_class.call(context) }

  describe '#call' do
    context 'when called with valid ids' do
      it 'deletes the specified items' do
        expect { interactor }.to change { Item.count }.by(-2)
      end

      it 'sets deleted_item_ids in the context' do
        interactor
        expect(interactor.deleted_item_ids).to eq({ deleted_item_ids: [item1.id, item2.id] })
      end
    end

    context 'when no valid ids are provided' do
      let(:context) { { params: { ids: ['invalid_id', nil] } } }

      it 'does not delete any items' do
        expect { interactor }.not_to change { Item.count }
      end

      it 'sets deleted_item_ids in the context to an empty array' do
        interactor
        expect(interactor.deleted_item_ids).to eq({ deleted_item_ids: [] })
      end
    end

    context 'when some ids are invalid' do
      it 'only deletes the valid items' do
        expect { interactor }.to change { Item.count }.by(-2)
      end
    end
  end
end

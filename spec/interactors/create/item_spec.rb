require 'rails_helper'

RSpec.describe Create::Item do
  let(:params) { { name: 'Item Name' } }
  let(:context) { { params: params } }
  subject(:interactor) { described_class.call(context) }

  describe '#call' do
    context 'when creating a new item' do
      it 'creates a new item with the given name' do
        expect { interactor }.to change { Item.count }.by(1)
        expect(interactor.item.name).to eq('Item Name')
      end
    end

    context 'when updating an existing item' do
      let!(:existing_item) { FactoryBot.create(:item, name: 'Old Name') }
      let(:params) { { id: existing_item.id, name: 'New Name' } }

      it 'updates the item with the new name' do
        expect { interactor }.not_to change { Item.count }
        expect(existing_item.reload.name).to eq('New Name')
      end

      it 'sets the updated item in the context' do
        interactor
        expect(interactor.item).to eq(existing_item)
      end
    end

    context 'when the item already exists with the same name' do
      let!(:existing_item) { FactoryBot.create(:item, name: 'Item Name') }

      it 'does not create a new item' do
        expect { interactor }.not_to change { Item.count }
      end

      it 'sets the existing item in the context' do
        interactor
        expect(interactor.item).to eq(existing_item)
      end
    end
  end
end

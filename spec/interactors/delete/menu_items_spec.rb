require 'rails_helper'

RSpec.describe Delete::MenuItems do
  let!(:menu_item1) { FactoryBot.create(:menu_item) }
  let!(:menu_item2) { FactoryBot.create(:menu_item) }
  let!(:menu_item3) { FactoryBot.create(:menu_item) }

  let(:context) { { params: { ids: [menu_item1.id, menu_item2.id, 'invalid_id', nil] } } }

  subject(:interactor) { described_class.call(context) }

  describe '#call' do
    context 'when called with valid ids' do
      it 'deletes the specified menu items' do
        expect { interactor }.to change { MenuItem.count }.by(-2)
      end

      it 'sets deleted_menu_item_ids in the context' do
        interactor
        expect(interactor.deleted_menu_item_ids).to eq({ deleted_menu_item_ids: [menu_item1.id, menu_item2.id] })
      end
    end

    context 'when no valid ids are provided' do
      let(:context) { { params: { ids: ['invalid_id', nil] } } }

      it 'does not delete any menu items' do
        expect { interactor }.not_to change { MenuItem.count }
      end

      it 'sets deleted_menu_item_ids in the context to an empty array' do
        interactor
        expect(interactor.deleted_menu_item_ids).to eq({ deleted_menu_item_ids: [] })
      end
    end

    context 'when some ids are invalid' do
      it 'only deletes the valid menu items' do
        expect { interactor }.to change { MenuItem.count }.by(-2)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Delete::Menus do
  let!(:menu1) { FactoryBot.create(:menu) }
  let!(:menu2) { FactoryBot.create(:menu) }
  let!(:menu3) { FactoryBot.create(:menu) }

  let(:context) { { params: { ids: [menu1.id, menu2.id, 'invalid_id', nil] } } }

  subject(:interactor) { described_class.call(context) }

  describe '#call' do
    context 'when called with valid ids' do
      it 'deletes the specified menus' do
        expect { interactor }.to change { Menu.count }.by(-2)
      end

      it 'sets deleted_menu_ids in the context' do
        interactor
        expect(interactor.deleted_menu_ids).to eq({ deleted_menu_ids: [menu1.id, menu2.id] })
      end
    end

    context 'when no valid ids are provided' do
      let(:context) { { params: { ids: ['invalid_id', nil] } } }

      it 'does not delete any menus' do
        expect { interactor }.not_to change { Menu.count }
      end

      it 'sets deleted_menu_ids in the context to an empty array' do
        interactor
        expect(interactor.deleted_menu_ids).to eq({ deleted_menu_ids: [] })
      end
    end

    context 'when some ids are invalid' do
      it 'only deletes the valid menus' do
        expect { interactor }.to change { Menu.count }.by(-2)
      end
    end
  end
end

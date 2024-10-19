require 'rails_helper'

RSpec.describe Create::Menu do
  let!(:restaurant) { FactoryBot.create(:restaurant) }
  let(:params) { { name: 'Dinner Menu' } }
  let(:context) { { params: params, restaurant: restaurant, menu_data: {} } }
  subject(:interactor) { described_class.call(context) }

  describe '#call' do
    context 'when creating a new menu' do
      let(:params) { { name: 'Dinner Menu' } }
      let(:menu_data) { { name: 'Dinner Menu' } }

      before do
        context[:menu_data] = menu_data
      end

      it 'creates a new menu with the given name' do
        expect { interactor }.to change { Menu.count }.by(1)
        expect(interactor.menu.name).to eq('Dinner Menu')
        expect(interactor.menu.restaurant_id).to eq(restaurant.id)
      end
    end

    context 'when updating an existing menu' do
      let!(:existing_menu) { FactoryBot.create(:menu, name: 'Dinner Menu', restaurant: restaurant) }
      let(:params) { { name: 'Dinner Menu' } }
      let(:menu_data) { { name: 'Updated Menu Name' } }

      before do
        context[:menu_data] = menu_data
      end

      it 'updates the existing menu' do
        interactor
        expect(existing_menu.reload.name).to eq('Updated Menu Name')
      end

      it 'sets the updated menu in the context' do
        interactor
        expect(interactor.menu).to eq(existing_menu)
      end
    end

    context 'when creating a menu with existing name' do
      let!(:existing_menu) { FactoryBot.create(:menu, name: 'Dinner Menu', restaurant: restaurant) }

      it 'does not create a new menu' do
        expect { interactor }.not_to change { Menu.count }
      end

      it 'sets the existing menu in the context' do
        interactor
        expect(interactor.menu).to eq(existing_menu)
      end
    end
  end
end

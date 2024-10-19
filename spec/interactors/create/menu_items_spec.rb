require 'rails_helper'

RSpec.describe Create::MenuItems do
  let!(:menu) { FactoryBot.create(:menu) }
  let!(:item) { FactoryBot.create(:item, name: 'Burger') }
  let(:params) do
    {
      menu_items: [
        { name: 'Burger', price: 10.0 },
        { name: 'Fries', price: 5.0 }
      ]
    }
  end
  let(:context) { { params: params, menu: menu } }
  subject(:interactor) { described_class.call(context) }

  describe '#call' do
    context 'when creating new menu items' do
      it 'creates new menu items if they do not exist' do
        expect { interactor }.to change { MenuItem.count }.by(2)
        expect(interactor.menu_items.map(&:item).map(&:name)).to contain_exactly('Burger', 'Fries')
      end

      it 'associates the menu items with the menu' do
        interactor
        interactor.menu_items.each do |menu_item|
          expect(menu_item.menu).to eq(menu)
        end
      end
    end

    context 'when updating existing menu items' do
      let!(:existing_menu_item) { FactoryBot.create(:menu_item, item: item, menu: menu, price: 8.0) }
      let(:params) do
        {
          menu_items: [
            { name: 'Burger', price: 12.0 }
          ]
        }
      end

      it 'updates the existing menu item price' do
        expect { interactor }.not_to change { MenuItem.count }
        expect(existing_menu_item.reload.price).to eq(12.0)
      end

      it 'does not create a duplicate menu item' do
        expect { interactor }.not_to change { MenuItem.count }
      end
    end

    context 'when some menu items already exist and others do not' do
      let!(:existing_menu_item) { FactoryBot.create(:menu_item, item: item, menu: menu, price: 8.0) }

      it 'creates the new menu items and updates existing ones' do
        expect { interactor }.to change { MenuItem.count }.by(1)
        expect(existing_menu_item.reload.price).to eq(10.0)
      end
    end
  end
end

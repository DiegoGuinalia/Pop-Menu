class PlaceMenus
  include Interactor::Organizer

  organize  Parse::MenuData,
            Create::Restaurant,
            Create::Menu,
            Create::MenuItems
end

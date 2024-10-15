module Delete
  class Menus < Base
    private

    def delete_entities
      Menu.where(id: only_ids).destroy_all
      context.deleted_menu_ids = { deleted_menu_ids: only_ids }
    end
  end
end

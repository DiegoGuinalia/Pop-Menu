module Delete
  class MenuItems < Base
    private

    def delete_entities
      MenuItem.where(id: only_ids).destroy_all
      context.deleted_menu_item_ids = { deleted_menu_item_ids: only_ids }
    end
  end
end

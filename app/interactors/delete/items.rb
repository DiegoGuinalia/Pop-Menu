module Delete
  class Items < Base
    private
    def delete_entities
      Item.where(id: only_ids).destroy_all
      context.deleted_item_ids = { deleted_item_ids: only_ids }
    end
  end
end

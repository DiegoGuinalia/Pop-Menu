module Delete
  class Restaurants < Base
    private
    def delete_entities
      Restaurant.where(id: only_ids).destroy_all
      context.deleted_restaurant_ids = { deleted_restaurant_ids: only_ids }
    end
  end
end

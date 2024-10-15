module Create
  class Item < Base
    private

    def create_or_update_entity
      item = if params[:id].present?
        ::Item.find_by(id: params[:id])
      else
        ::Item.find_by(name: params[:name])
      end

      if item.nil?
        context.item = ::Item.create!(item_data)
      else
        item.update(name: params[:name]) if params[:name].present?
        context.item = item
      end
    end

    def set_associated_entity
      @associated_entity = context.item
    end

    def item_data
      { name: params[:name] }
    end
  end
end

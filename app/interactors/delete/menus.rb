module Delete
  class Menus
    include Interactor
    include Utils

    delegate :params, to: :context

    def call
      within_transaction do
        delete_menu
      end
    end

    private

    def delete_menu
      Menu.where(id: only_ids).destroy_all
      context.deleted_menu_ids = { deleted_menu_ids: only_ids }
    end

    def only_ids
      params[:ids].select{|param| param.is_a?(Integer)}
    end
  end
end

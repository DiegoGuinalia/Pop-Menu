module Delete
  class Base
    include Interactor
    include Utils

    delegate :params, to: :context

    def call
      within_transaction do
        delete_entities
      end
    end

    private

    def delete_entities
      raise NotImplementedError, "Should be implemented"
    end

    def only_ids
      params[:ids].select { |param| Integer(param) rescue false }
    end
  end
end

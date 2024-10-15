module Create
  class Base
    include Interactor
    include Utils

    delegate :params, to: :context

    attr_accessor :associated_entity

    def call
      set_associated_entity

      within_transaction do
        create_or_update_entity
      end
    end

    private

    def create_or_update_entity
      raise NotImplementedError, "Should be implemented create_or_update_entity"
    end

    def set_associated_entity
      raise NotImplementedError, "Should be implemented set_associated_entity"
    end

    def entity_data
      raise NotImplementedError, "Should be implemented"
    end
  end
end

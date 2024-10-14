module Utils
  include Interactor

  def within_transaction
    ActiveRecord::Base.transaction do
      begin
        yield
      rescue => error
        @error = error
        puts @error
        context.fail!(error: "unexpected error has occurred")
        raise ActiveRecord::Rollback
      end
    end
  end
end

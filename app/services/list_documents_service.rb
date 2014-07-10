class ListDocumentsService

  def initialize(documents_repository)
    @documents_repository = documents_repository
  end

  def call
    documents_repository.all
  end

  private

  attr_reader :documents_repository

end

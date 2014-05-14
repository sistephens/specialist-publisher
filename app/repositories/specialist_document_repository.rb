require "gds_api/panopticon"

class SpecialistDocumentRepository

  def initialize(panopticon_mappings,
    specialist_document_editions,
    specialist_document_factory)
    @panopticon_mappings = panopticon_mappings
    @specialist_document_editions = specialist_document_editions
    @document_factory = specialist_document_factory
  end

  def all
    # TODO: add a method on PanopticonMapping to handle this
    document_ids = panopticon_mappings.all_document_ids
    documents = document_ids.map { |id| fetch(id) {} }.to_a.compact

    documents.sort_by(&:updated_at).reverse
  end

  def fetch(id, &block)
    # TODO: add a method on SpecialistDocumentEdition to handle this
    editions = specialist_document_editions
      .where(document_id: id)
      .order_by([:version_number, :desc])
      .limit(2)
      .to_a
      .reverse

    if editions.empty?
      if block_given?
        yield(id)
      else
        raise NotFound
      end
    else
      document_factory.call(id, editions)
    end
  end

  def slug_unique?(document)
    # TODO: push this method down into persistence layer
    editions_with_slug = specialist_document_editions.where(
      :slug => document.slug,
      :document_id.ne => document.id,
    ).empty?
  end

  def store(document)
    edition = document.exposed_edition

    edition.save!
  end

  NotFound = Class.new(StandardError)

  class InvalidDocumentError < StandardError
    def initialize(message, document)
      super(message)
      @document = document
    end

    attr_reader :document
  end

private

  attr_reader(
    :panopticon_mappings,
    :specialist_document_editions,
    :document_factory,
  )

end
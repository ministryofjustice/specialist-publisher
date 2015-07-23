require "url_maker"
require "rummager_indexer"

class AbstractSpecialistDocumentObserversRegistry
  def creation
    []
  end

  def update
    []
  end

  def publication
    [
      publication_logger,
      content_api_exporter,
      panopticon_exporter,
      rummager_exporter,
    ]
  end

  def republication
    [
      content_api_exporter,
      panopticon_exporter,
      rummager_exporter,
    ]
  end

  def withdrawal
    [
      content_api_withdrawer,
      panopticon_exporter,
      rummager_withdrawer,
    ]
  end

private
  def panopticon_exporter
    ->(document) {
      panopticon_registerer.call(
        format_document_as_artefact(document)
      )
    }
  end

  def panopticon_registerer
    SpecialistPublisherWiring.get(:panopticon_registerer)
  end

  def format_document_as_artefact(document)
    raise NotImplementedError
  end

  def content_api_exporter
    ->(document) {
      SpecialistDocumentDatabaseExporter.new(
        RenderedSpecialistDocument,
        SpecialistPublisherWiring.get(:specialist_document_renderer),
        finder_schema,
        document,
        PublicationLog,
      ).call
    }
  end

  def rummager_exporter
    ->(document) {
      RummagerIndexer.new.add(
        format_document_for_indexing(document)
      )
    }
  end

  def rummager_withdrawer
    ->(document) {
      RummagerIndexer.new.delete(
        format_document_for_indexing(document)
      )
    }
  end

  def format_document_for_indexing(document)
    raise NotImplementedError
  end

  def content_api_withdrawer
    ->(document) {
      RenderedSpecialistDocument.where(slug: document.slug).map(&:destroy)
    }
  end

  def email_alert_api
    SpecialistPublisherWiring.get(:email_alert_api)
  end

  def publication_alert_exporter
    ->(document) {
      if !document.minor_update
        EmailAlertExporter.new(
          email_alert_api: email_alert_api,
          formatter: publication_alert_formatter(document),
        ).call
      end
    }
  end

  def publication_alert_formatter
    raise NotImplementedError
  end

  def publication_logger
    ->(document) {
      unless document.minor_update?
        PublicationLog.create!(
          title: document.title,
          slug: document.slug,
          version_number: document.version_number,
          change_note: document.change_note,
        )
      end
    }
  end

  def url_maker
    UrlMaker.new
  end
end

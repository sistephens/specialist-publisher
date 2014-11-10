require "url_maker"

class AbstractSpecialistDocumentObserversRegistry
  def creation
    []
  end

  def update
    []
  end

  def publication
    [
      content_api_exporter,
      panopticon_exporter,
      rummager_exporter,
      publication_alert_exporter,
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
    raise NotImplementedError
  end

  def content_api_exporter
    raise NotImplementedError
  end

  def rummager_exporter
    raise NotImplementedError
  end

  def rummager_withdrawer
    raise NotImplementedError
  end

  def content_api_withdrawer
    raise NotImplementedError
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

  def url_maker
    UrlMaker.new
  end
end

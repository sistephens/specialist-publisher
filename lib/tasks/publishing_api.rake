namespace :publishing_api do
  desc "Publish cma finder"
  task publish_cma_finder: :environment do
    require "multi_json"
    require "publishing_api_finder_publisher"
    file = "lib/documents/schemas/cma_cases.json"
    cma_finder = [
      file: MultiJson.load(File.read(file)),
      timestamp: File.mtime(file)
    ]
    begin
      PublishingApiFinderPublisher.new(cma_finder).call
    rescue GdsApi::HTTPServerError => e
      puts "Error publishing cma finder"
    end
  end

  desc "Publish all Finders to the Publishing API"
  task publish_finders: :environment do
    require "finder_loader"
    require "publishing_api_finder_publisher"

    finder_loader = FinderLoader.new

    begin
      PublishingApiFinderPublisher.new(finder_loader.finders).call
    rescue GdsApi::HTTPServerError => e
      puts "Error publishing finder: #{e.inspect}"
    end
  end
end

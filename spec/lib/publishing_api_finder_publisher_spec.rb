require "spec_helper"
require "publishing_api_finder_publisher"

describe PublishingApiFinderPublisher do
  describe ".call" do

    let(:schema) do
      {
        "facets" => [
          {
            "key" => "report_type",
            "name" => "Report type",
            "type" => "text",
            "display_as_result_metadata" => true,
            "filterable" => true,
          },
        ],
        "document_noun" => "reports",
      }
    end

    def make_metadata(base_path, overrides = {})
      underscore_name = base_path.sub("/", "")
      name = underscore_name.humanize
      metadata = {
        "base_path" => base_path,
        "name" => name,
        "format_name" => "#{name} things",
        "content_id" => SecureRandom.uuid,
        "format" => "#{underscore_name}_format",
        "logo_path" => "http://example.com/logo.png",
      }.merge(overrides)
      metadata.delete("content_id") if metadata["content_id"].nil?

      metadata
    end

    def make_finder(base_path, overrides = {})
      {
        schema: schema,
        metadata: make_metadata(base_path, overrides),
        timestamp: "2015-01-05T10:45:10.000+00:00"
      }
    end

    let(:publishing_api) { double("publishing-api") }

    let(:test_logger) { Logger.new(nil) }

    before do
      allow(GdsApi::PublishingApi).to receive(:new)
        .with(Plek.new.find("publishing-api"))
        .and_return(publishing_api)
    end

    it "uses GdsApi::PublishingApi to publish the Finders" do
      finders = [
        make_finder("/first-finder", "signup_content_id" => SecureRandom.uuid),
        make_finder("/second-finder"),
      ]

      expect(publishing_api).to receive(:put_content_item)
        .with("/first-finder", be_valid_against_schema("finder"))

       # This should be validated against an email-signup schema if one gets created
      expect(publishing_api).to receive(:put_content_item)
        .with("/first-finder/email-signup", anything)

      expect(publishing_api).to receive(:put_content_item)
        .with("/second-finder", be_valid_against_schema("finder"))

      PublishingApiFinderPublisher.new(finders, logger: test_logger).call
    end

    it "can publish a Finder with a phase" do
      finders = [
        make_finder("/finder-with-phase", "phase" => "beta"),
      ]

      expect(publishing_api).to receive(:put_content_item)
        .with("/finder-with-phase", be_valid_against_schema("finder"))

      PublishingApiFinderPublisher.new(finders, logger: test_logger).call
    end

    context 'with pre_production false metadata and RAILS_ENV is "production"' do
      it "does publish finder" do
        finders = [
          make_finder("/finder-with-pre-production-true", "pre_production" => false)
        ]

        production = ActiveSupport::StringInquirer.new("production")
        allow(Rails).to receive(:env).and_return(production)

        expect(publishing_api).to receive(:put_content_item)
          .with("/finder-with-pre-production-true", anything)

        PublishingApiFinderPublisher.new(finders, logger: test_logger).call
      end
    end

    context "with pre_production true metadata" do
      let(:finders) do
        [
          make_finder("/finder-with-pre-production-true", "pre_production" => true)
        ]
      end

      context 'and RAILS_ENV is not "production"' do
        it "publishes finder" do
          expect(publishing_api).to receive(:put_content_item)
            .with("/finder-with-pre-production-true", anything)

          PublishingApiFinderPublisher.new(finders, logger: test_logger).call
        end
      end

      context 'and RAILS_ENV is "production"' do
        before do
          production = ActiveSupport::StringInquirer.new("production")
          allow(Rails).to receive(:env).and_return(production)
        end

        context 'and GOVUK_APP_DOMAIN does not contain "preview"' do
          it "does not publish finder" do
            expect(publishing_api).not_to receive(:put_content_item)
              .with("/finder-with-pre-production-true", anything)

            PublishingApiFinderPublisher.new(finders, logger: test_logger).call
          end
        end

        context 'and GOVUK_APP_DOMAIN contains "preview"' do
          it "publishes finder" do
            allow(ENV).to receive(:fetch).with("GOVUK_APP_DOMAIN", "").and_return("preview")
            expect(publishing_api).to receive(:put_content_item)
              .with("/finder-with-pre-production-true", anything)

            PublishingApiFinderPublisher.new(finders, logger: test_logger).call
          end
        end

      end
    end
  end
end

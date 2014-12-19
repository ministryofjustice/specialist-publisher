[![Code Climate](https://codeclimate.com/github/alphagov/specialist-publisher.png)](https://codeclimate.com/github/alphagov/specialist-publisher)

# Specialist publisher

## Purpose

Publishing App for Specialist Documents and Manuals.

## Nomenclature

* Specialist Documents: Documents with metadata which are published to Finders
* Schema: JSON file defining slug, document noun and name of Specialist Document document_types. Also has select facets and their possible values for each document_type which are displayed by the `_form.html.erb`.
* Manual: Grouped Documents published as a number of sections inside a parent document

## Current formats

### Live
* [AAIB Reports](https://www.gov.uk/aaib-reports)
* [CMA Cases](https://www.gov.uk/cma-cases)
* [Drug Safety Updates](https://www.gov.uk/drug-safety-update)
* [International Funding Development](https://www.gov.uk/international-funding-development)
* Manuals (there's no public index page for Manuals, they can all be found at `gov.uk/guidance/:manual-slug`)
* [Medical Safety Alerts](https://www.gov.uk/drug-device-alerts)

## Dependencies

* [alphagov/static](http://github.com/alphagov/static): provides static assets (JS/CSS)
* [alphagov/panopticon](http://github.com/alphagov/panopticon): provides public URLs for content on GOV.UK
* [alphagov/asset_manager](http://github.com/alphagov/asset_manager): provides uploading for static files
* [alphagov/rummager](http://github.com/alphagov/rummager): allows documents to be indexed for searching in both Finders and site search
* [alphagov/publishing-api](http://github.com/alphagov/publishing-api): allows documents to be published to the Publishing queue

## Running the application

```
$ ./startup.sh
```
If you are using the GDS development virtual machine then the application will be available on the host at http://specialist-publisher.dev.gov.uk/

## Running the test suite

```
$ bundle exec rake
```

## Adding a new specialist document format

1. Add the document_type to the `document_types` array in `config/routes.rb`
2. Add a controller that inherits `AbstractDocumentController`
3. Add the schema to the `schemas` folder and define the singleton for it in `app/lib/specialist_publisher_wiring.rb`
4. Add a model (which is a subclass of `DocumentMetadataDecorator` and only defines the extra fields of the document type), validator and builder for the new format.
5. Define the factory with the builder in `app/lib/specialist_publisher_wiring.rb`.
6. Define the validatable document factory in `app/models/document_factory_registry.rb`
7. Define a repository in `app/repositories/repository_registry.rb`
8. Add observers, along with formatters required:
  - `document_type_publication_alert_formatter.rb` in `app/exporters/formatters/`
  - `document_type_artefact_formatter.rb` in `app/lib/` for Panopticon
  - `document_type_indexable_formatter.rb` app/lib/` for Rummager
  - define a factory for `document_type_panopticon_registerer`, `document_type_rummager_indexer`, `document_type_rummager_deleter` and `document_type_content_api_exporter` in `app/lib/specialist_publisher_wiring.rb`
  - add an Observers registry for the docuemt type and add it to the has in the `observers_registry` method in `app/lib/specialist_publisher`
9. Add `app/view_adapters/document_type_view_adapter.rb` along with it's entry in `app/view_adapters/view_adapter_registry.rb`. Also add the `_form.html.erb` which has the extra fields for that document_type. Be sure to pass the correct `form_namespace` matching the document_type.
10. Add the entry to `app/lib/permission_checker.rb` for the owning organisation and an entry in the finders array in `ApplicationController`.
11. That's it!

### Testing your new specialist document format

We have a spec for each model but most of the testing is done in Cucumber tests. Each document format has a feature for creating & editing, publishing and withdrawing. Be sure to add an editor type to `test/factories.rb` for the owning Org of the newformat (if there isn't already a format owned by that Org). The step definitions in each of the tests are pretty similar, so the methods in `features/support/document_format_helpers.rb` call the abstract methods in `features/support/document_helpers.rb`. The features should also cover add attachments, if you follow the same pattern as the other document formats.


## Application Structure

### Directory Structure

Non standard Rails directories and what they're used for:

* `app/exporters`
  These export information to various GOV.UK APIs
  * `app/exporters/formatters`
    These are used by exporters to format information for transferring as JSON
* `app/importers`
  Generic code used when writing importers for scraped content of new document formats
* `app/models`
  Combination of Mongoid documents and Ruby objects for handling Documents and various behaviours
  * `app/models/builders`
    Ruby objects for building a new document by setting ID and subclasses for setting the document type, if needed
  * `app/models/validators`
    Not validators. Decorators for providing validation logic.
* `app/observers`
  Define ordered lists of exporters, called at different stages of a documents life cycle, for example, publication.
* `app/repositories`
  Provide interaction with the persistance layer (Mongoid)
* `app/services`
  Reusable classes for completing actions on documents
* `app/view_adapters`
  Provide classes which allow us to have Rails like form objects in views
* `app/workers`
  Classes for sidekiq workers. Currently the only worker in the App is for publishing Manuals as Manual publishing was timing out due to the large number of document objects inside a Manual


### Services

Services do things such as previewing a document, creation, updating, showing, withdrawing, queueing. This replaces the normal Rails behaviour of completing these actions directly from a controller, instead we call a service registry for a document in the `AbstractDocumentsController` and then call the individual services like `services.show(document_id).call` where `document_id` is a UUID representing the document.

## Bin scripts

Due to the nature of Specialist Publisher and it's document formats, we've added some scripts to do various things such as importing documents as a format and mass publishing.

- **Importing**: Using a copy of scraped content formatted with a `metadata` and `downloads` folder running these scripts. See `doc/importing.md` for how to do an import. Important to note that this doesn't do a find_or_create, it will simply create them. So running it twice will create duplicates of all the documents.
- **Bulk publishing**: After an import, we can bulk publish all draft documents for a given format to avoid having to do it manually. For more information see `doc/bulk_publishing.md`.


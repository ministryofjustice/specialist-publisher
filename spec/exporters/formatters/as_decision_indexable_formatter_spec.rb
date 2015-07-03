require "spec_helper"
require "spec/exporters/formatters/abstract_indexable_formatter_spec"
require "spec/exporters/formatters/abstract_specialist_document_indexable_formatter_spec"
require "formatters/as_decision_indexable_formatter"

RSpec.describe AsDecisionIndexableFormatter do
  let(:document) {
    double(
      :as_decision,
      body: double,
      slug: double,
      summary: double,
      title: double,
      updated_at: double,
      minor_update?: false,

      category: double,
      judges: double,
      landmark: double,
    )
  }

  subject(:formatter) { AsDecisionIndexableFormatter.new(document) }

  it_should_behave_like "a specialist document indexable formatter"

  it "should have a type of as_decision" do
    expect(formatter.type).to eq("as_decision")
  end
end

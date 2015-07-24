require "spec_helper"
require "spec/exporters/formatters/abstract_indexable_formatter_spec"
require "spec/exporters/formatters/abstract_specialist_document_indexable_formatter_spec"
require "formatters/aaib_report_indexable_formatter"

RSpec.describe UtiacDecisionIndexableFormatter do
  let(:document) {
    double(
      :utiac_decision,
      body: double,
      country: double,
      country_guidance: double,
      decision_reported: double,
      judges: double,
      minor_update?: false,
      hidden_indexable_content: double,
      promulgation_date: double,
      slug: double,
      summary: double,
      title: double,
      updated_at: double,
      public_updated_at: nil
    )
  }

  subject(:formatter) { UtiacDecisionIndexableFormatter.new(document) }

  it_should_behave_like "a specialist document indexable formatter"

  it "should have a type of utiac_decision" do
    expect(formatter.type).to eq("utiac_decision")
  end

  context "without hidden_indexable_content" do

    it "should have body as its indexable_content" do
      allow(document).to receive(:hidden_indexable_content).and_return(nil)
      expect(formatter.indexable_attributes[:indexable_content]).to eq(document.body)
    end
  end

  context "with hidden_indexable_content" do

    it "should have hidden_indexable_content as its indexable_content" do
      expect(formatter.indexable_attributes[:indexable_content]).to eq(document.hidden_indexable_content)
    end
  end

end

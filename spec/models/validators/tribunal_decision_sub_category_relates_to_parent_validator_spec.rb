require "spec_helper"

RSpec.shared_examples_for "tribunal decision sub_category validator" do

  let(:category_label) { "Category label" }
  let(:humanized_facet_value) { category_label }
  include_context "schema with humanized_facet_value available"

  describe "#errors" do

    context "when sub_category does not match category" do
      let(:category) { "category-name" }
      let(:sub_category) { "non-matching-sub-category" }

      it "returns error for sub_category" do
        validatable.valid?
        errors = validatable.errors.messages
        expect(errors).to eq({
          tribunal_decision_sub_category: ["change to be a sub-category of '#{category_label}' or change category"]
        })
      end
    end

    context "when sub_category matches category" do
      let(:category) { "category-name" }
      let(:sub_category) { "category-name-subcategory-name" }

      it "returns an empty error hash" do
        validatable.valid?
        errors = validatable.errors.messages
        expect(errors).to eq({})
      end
    end
  end
end

class TribunalDecisionViewAdapter < DocumentViewAdapter

  def self.model_name
    ActiveModel::Name.new(self, nil, model_class_name)
  end

  def self.define_attributes attributes
    attributes.each do |attribute_name|
      define_method(attribute_name) do
        delegate_if_document_exists(attribute_name)
      end
    end
  end

private

  def self.model_class_name
    name.sub('ViewAdapter','')
  end

  def finder_schema
    name = self.class.model_class_name.tableize.singularize
    SpecialistPublisherWiring.get(:"#{name}_finder_schema")
  end
end

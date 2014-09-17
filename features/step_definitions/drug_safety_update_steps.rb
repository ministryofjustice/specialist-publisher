When(/^I create a Drug Safety Update$/) do
  @slug = "drug-safety-update/example-drug-safety-update"
  @dsu_fields = {
    title: "Example Drug Safety Update",
    summary: "Nullam quis risus eget urna mollis ornare vel eu leo.",
    body: "## Header" + ("\n\nPraesent commodo cursus magna, vel scelerisque nisl consectetur et." * 10),
    therapeutic_area: ["Anaesthesia and intensive care"],
  }
  @dsu_metadata_values = {
    therapeutic_area: ["anaesthesia-intensive-care"],
  }

  create_drug_safety_update(@dsu_fields)
end

Then(/^the Drug Safety Update has been created$/) do
  check_drug_safety_update_exists_with(@dsu_fields)
end

When(/^I create a Drug Safety Update with invalid fields$/) do
  @dsu_fields = {
    body: "<script>alert('Oh noes!)</script>",
  }
  create_drug_safety_update(@dsu_fields)
end

Then(/^the Drug Safety Update should not have been created$/) do
  check_no_document_created(:drug_safety_update)
end

Given(/^a draft Drug Safety Update exists$/) do
  @slug = "drug-safety-update/example-drug-safety-update"
  @dsu_fields = {
    title: "Example Drug Safety Update",
    summary: "Nullam quis risus eget urna mollis ornare vel eu leo.",
    body: "## Header" + ("\n\nPraesent commodo cursus magna, vel scelerisque nisl consectetur et." * 10),
    therapeutic_area: ["Anaesthesia and intensive care"],
  }
  @dsu_metadata_values = {
    therapeutic_area: ["anaesthesia-intensive-care"],
  }

  create_drug_safety_update(@dsu_fields)
end

When(/^I edit a Drug Safety Update and remove required fields$/) do
  edit_drug_safety_update(@dsu_fields.fetch(:title), summary: "")
end

Then(/^the Drug Safety Update should not have been updated$/) do
  expect(page).to have_content("Summary can't be blank")
end

Given(/^two Drug Safety Updates exist$/) do
  @dsu_fields = {
    title: "Example Drug Safety Update 1",
    summary: "Nullam quis risus eget urna mollis ornare vel eu leo.",
    body: "## Header" + ("\n\nPraesent commodo cursus magna, vel scelerisque nisl consectetur et." * 10),
    therapeutic_area: ["Anaesthesia and intensive care"],
  }
  @dsu_metadata_values = {
    therapeutic_area: ["anaesthesia-intensive-care"],
  }

  create_drug_safety_update(@dsu_fields)

  @dsu_fields = {
    title: "Example Drug Safety Update 2",
    summary: "Nullam quis risus eget urna mollis ornare vel eu leo.",
    body: "## Header" + ("\n\nPraesent commodo cursus magna, vel scelerisque nisl consectetur et." * 10),
    therapeutic_area: ["Anaesthesia and intensive care"],
  }
  @dsu_metadata_values = {
    therapeutic_area: ["anaesthesia-intensive-care"],
  }
  create_drug_safety_update(@dsu_fields)
end

Then(/^the Drug Safety Updates should be in the publisher DSU index in the correct order$/) do
  visit drug_safety_updates_path

  check_for_documents("Example Drug Safety Update 1", "Example Drug Safety Update 2")
end

When(/^I edit a Drug Safety Update$/) do
  @new_title = "New Drug Safety Update Title"
  edit_drug_safety_update(@dsu_fields.fetch(:title), title: @new_title)
end

Then(/^the Drug Safety Update should have been updated$/) do
  check_for_new_drug_safety_update_title(@new_title)
end

Then(/^the Drug Safety Update should be in draft$/) do
  expect(
    drug_safety_update_repository.all.last
  ).to be_draft
end

When(/^I publish the Drug Safety Update$/) do
  go_to_show_page_for_drug_safety_update(@dsu_fields.fetch(:title))
  publish_document
end

Then(/^the Drug Safety Update should be published$/) do
  check_document_is_published(@slug, @dsu_fields.merge(@dsu_metadata_values))
end

When(/^I publish a new Drug Safety Update$/) do
  @slug = "drug-safety-update/example-drug-safety-update"
  @dsu_fields = {
    title: "Example Drug Safety Update",
    summary: "Nullam quis risus eget urna mollis ornare vel eu leo.",
    body: "## Header" + ("\n\nPraesent commodo cursus magna, vel scelerisque nisl consectetur et." * 10),
    therapeutic_area: "Anaesthesia and intensive care",
  }
  @dsu_metadata_values = {
    therapeutic_area: ["anaesthesia-intensive-care"],
  }
  create_drug_safety_update(@dsu_fields, publish: true)
end

When(/^I edit the Drug Safety Update and republish$/) do
  @amended_document_attributes = {summary: "New summary", title: "My title"}
  edit_drug_safety_update(@dsu_fields.fetch(:title), @amended_document_attributes, publish: true)
end

Given(/^a published Drug Safety Update exists$/) do
  @slug = "drug-safety-update/example-drug-safety-update"
  @dsu_fields = {
    title: "Example Drug Safety Update",
    summary: "Nullam quis risus eget urna mollis ornare vel eu leo.",
    body: "## Header" + ("\n\nPraesent commodo cursus magna, vel scelerisque nisl consectetur et." * 10),
    therapeutic_area: ["Anaesthesia and intensive care"],
  }
  @dsu_metadata_values = {
    therapeutic_area: ["anaesthesia-intensive-care"],
  }
  create_drug_safety_update(@dsu_fields, publish: true)
end

When(/^I withdraw a Drug Safety Update$/) do
  withdraw_drug_safety_update(@dsu_fields.fetch(:title))
end

Then(/^the Drug Safety Update should be withdrawn$/) do
  check_document_is_withdrawn(@slug, @dsu_fields.fetch(:title))
end

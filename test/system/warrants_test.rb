require "application_system_test_case"

class WarrantsTest < ApplicationSystemTestCase
  setup do
    @warrant = warrants(:one)
  end

  test "visiting the index" do
    visit warrants_url
    assert_selector "h1", text: "Warrants"
  end

  test "creating a Warrant" do
    visit warrants_url
    click_on "New Warrant"

    fill_in "Basic price", with: @warrant.basic_price
    fill_in "Code", with: @warrant.code
    fill_in "Conversion", with: @warrant.conversion
    fill_in "End date", with: @warrant.end_date
    fill_in "Issuer", with: @warrant.issuer
    fill_in "Link", with: @warrant.link
    fill_in "Start date", with: @warrant.start_date
    fill_in "Status", with: @warrant.status
    fill_in "Stock", with: @warrant.stock
    fill_in "Stock price", with: @warrant.stock_price
    click_on "Create Warrant"

    assert_text "Warrant was successfully created"
    click_on "Back"
  end

  test "updating a Warrant" do
    visit warrants_url
    click_on "Edit", match: :first

    fill_in "Basic price", with: @warrant.basic_price
    fill_in "Code", with: @warrant.code
    fill_in "Conversion", with: @warrant.conversion
    fill_in "End date", with: @warrant.end_date
    fill_in "Issuer", with: @warrant.issuer
    fill_in "Link", with: @warrant.link
    fill_in "Start date", with: @warrant.start_date
    fill_in "Status", with: @warrant.status
    fill_in "Stock", with: @warrant.stock
    fill_in "Stock price", with: @warrant.stock_price
    click_on "Update Warrant"

    assert_text "Warrant was successfully updated"
    click_on "Back"
  end

  test "destroying a Warrant" do
    visit warrants_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Warrant was successfully destroyed"
  end
end

require "rspec"
require "capybara"

feature "Messages" do
  scenario "As a user, I can submit a message" do
    visit "/"

    expect(page).to have_content("Message Roullete")

    fill_in "Message", :with => "Hello Everyone!"

    click_button "Submit"

    expect(page).to have_content("Hello Everyone!")
  end

  scenario "As a user, I see an error message if I enter a message > 140 characters" do
    visit "/"

    fill_in "Message", :with => "a" * 141

    click_button "Submit"

    expect(page).to have_content("Message must be less than 140 characters.")
  end

  scenario "As a user, I can edit a message" do
    visit "/"
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    expect(page).to have_content("Hello Everyone!")
    click_link "Edit"
    expect(page).to have_content("Edit Message")
    fill_in "message", :with => "Hi, nice to meet you."

    click_button "Edit Message"
    # expect(page).to have_content("What the!!!")
    # raise "This should have failed here ^^"
    expect(page).to have_content("Home Page")
    expect(page).to have_content("Hi, nice to meet you.")
  end

  scenario "As a user, I can see error message" do
    visit "/"
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"
    expect(page).to have_content("Hello Everyone!")
    click_link "Edit"
    expect(page).to have_content("Edit Message")
    fill_in "message", :with => "This is a very long message. It is so long that it sets off an error. The error shows as a 'Flash' on the page............................................."
    click_button "Edit Message"

    save_and_open_page

    expect(page).to have_content("Message must be less than 140 characters.")
  end


end#feature end

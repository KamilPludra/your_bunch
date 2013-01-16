# encoding: utf-8
require 'spec_helper'

describe "Strony Statyczne" do

  subject { page }

  shared_examples_for "wszystkie statyczne strony" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  it "powinna miec odpowiednie linki na stronie" do
    visit root_path
    click_link "O nas"
    page.should have_selector 'title', text: full_title('O nas')
    click_link "Pomoc"
    page.should # fill in
    click_link "Kontakt"
    page.should # fill in
    click_link "Home"
    click_link "Zarejestruj"
    page.should # fill in
    click_link "Your Bunch"
    page.should # fill in

  end

  describe "Strona glowna" do
    before { visit root_path }

    let(:heading)    { 'Your Bunch' }
    let(:page_title) { '' }

    it_should_behave_like "wszystkie statyczne strony"
    it { should_not have_selector 'title', text: '| Home' }


    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem")
        FactoryGirl.create(:micropost, user: user, content: "Ipsum")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end




  end

  describe "Strona pomocy" do
    before { visit pomoc_path }

    it { should have_selector('h1',    text: 'Pomoc') }
    it { should have_selector('title', text: full_title('Pomoc')) }
  end

  describe "O stronie" do
    before { visit onas_path }

    it { should have_selector('h1',    text: 'O nas') }
    it { should have_selector('title', text: full_title('O nas')) }
  end

  describe "Strona Kontakt" do
    before { visit kontakt_path }

    it { should have_selector('h1',    text: 'Kontakt') }
    it { should have_selector('title', text: full_title('Kontakt')) }
  end
end
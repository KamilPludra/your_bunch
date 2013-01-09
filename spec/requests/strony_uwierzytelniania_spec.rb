# encoding: utf-8

require 'spec_helper'

describe "Strony Uwierzytelniania" do

  subject { page }

  describe "logowanie na stronie" do
      before { visit zaloguj_path }

      it { should have_selector('h1',    text: 'Zaloguj się') }
      it { should have_selector('title', text: 'Zaloguj się') }
  end

  describe "Zaloguj się" do
    before { visit zaloguj_path }

    describe "z nieprawidłowych informacji" do
      before { click_button "Zaloguj się" }

      it { should have_selector('title', text: 'Zaloguj się') }
      it { should have_selector('div.alert.alert-error', text: 'Nieprawidłowy') }

      describe "po wizycie na innej stronie" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end

    end

    describe "z prawidłowych informacji" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Twój adres e-mail",    with: user.email
        fill_in "Hasło do serwisu Your Bunch", with: user.password
        click_button "Zaloguj się"
      end

      it { should have_selector('title', text: user.name) }
      it { should have_link('Profil', href: user_path(user)) }
      it { should have_link('Wyloguj', href: wyloguj_path) }
      it { should_not have_link('Zaloguj', href: zaloguj_path) }


      describe "następnie wyloguj" do
        before { click_link "Wyloguj się" }
        it { should have_link('Zaloguj się') }
      end

    end

  end



end

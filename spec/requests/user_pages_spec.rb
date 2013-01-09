# encoding: utf-8
require 'spec_helper'

describe "Strony uzytkownikow" do

  subject { page }

  describe "Strona profilu" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
  end


  describe "Strona Rejestracji" do
    before { visit zarejestruj_path }

    it { should have_selector('h1',    text: 'Zarejestruj') }
    it { should have_selector('title', text: 'Zarejestruj') }

  end


  describe "zarejestruj" do

    before { visit zarejestruj_path }

    let(:zarejestruj) { "Utwórz konto" }

    describe "z nieprawidlowych informacji" do
      it "nie nalezy utworzyc uzytkownika" do
        expect { click_button zarejestruj }.not_to change(User, :count)
      end
    end

    describe "po zapisaniu instrukcji" do
      before { click_button zarejestruj }

      it { should have_selector('title', text: 'Zarejestruj się') }
      it { should have_content('error') }

    end

    describe "z prwidlowej informacji" do
      before do
        fill_in "Imię i nazwisko",          with: "Przykladowy Uzytkownik"
        fill_in "Twój adres e-mail",        with: "przykladowy@uzytkownik.pl"
        fill_in "Hasło",                    with: "pludra"
        fill_in "Wprowadź ponownie hasło",  with: "pludra"

      end

      it "nalezy utworzyc uzytkownika" do
        expect { click_button zarejestruj }.to change(User, :count).by(1)

        # it { should have_link('Wyloguj się') }
      end
    end
  end

end
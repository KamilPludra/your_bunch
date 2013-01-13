# encoding: utf-8
require 'spec_helper'

describe "Strony uzytkownikow" do

  subject { page }


  describe "index" do

    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'Wszyscy użytkownicy') }
    it { should have_selector('h1',    text: 'Wszyscy użytkownicy') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end




    describe "usuwanie linków" do

      it { should_not have_link('delete') }

      describe "jako administrator" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('usuń', href: user_path(User.first)) }
        it "powinien być w stanie usunąć innego użytkownika" do
          expect { click_link('usuń') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('usuń', href: user_path(admin)) }
      end
    end





  end









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
      # it { should have_link('Wyloguj się') }


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


      end
    end
  end





  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end




    describe "strona" do
      it { should have_selector('h1',    text: "Zaktualizuj swój profil") }
      it { should have_selector('title', text: "Edycja użytkownika") }
      it { should have_link('Zmień obraz', href: 'http://gravatar.com/emails') }
    end

    describe "z nieprawidłowymi informacjami" do
      before { click_button "Zapisz zmiany" }

      it { should have_content('error') }
    end

    describe "z prawidłowymi informacjami" do
      let(:new_name)  { "Nowy Imie" }
      let(:new_email) { "nowe@imie.com" }
      before do
        fill_in "Imię i nazwisko",             with: new_name
        fill_in "Twój adres e-mail",            with: new_email
        fill_in "Nowe hasło",         with: user.password
        fill_in "Wprowadź ponownie hasło", with: user.password
        click_button "Zapisz zmiany"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Wyloguj się', href: wyloguj_path) }

      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end

  end




  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
  end




end





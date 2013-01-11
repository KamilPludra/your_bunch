# encoding: utf-8

require 'spec_helper'

describe "Uwierzytelnianie" do

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
        before { sign_in user }

        it { should have_selector('title', text: user.name) }

        it { should have_link('Użytkownicy',    href: users_path) }
        it { should have_link('Profil', href: user_path(user)) }
        it { should have_link('Ustawienia', href: edit_user_path(user)) }
        it { should have_link('Wyloguj się', href: wyloguj_path) }

        it { should_not have_link('Zaloguj się', href: zaloguj_path) }





      describe "następnie wyloguj" do
        before { click_link "Wyloguj się" }
        it { should have_link('Zaloguj się') }
      end
    end



  end




  describe "autoryzacja" do

    describe "dla niezalogowanych użytkowników" do
      let(:user) { FactoryGirl.create(:user) }


      describe "when attempting to visit a protected page" do
        before do
          fill_in "Twój adres e-mail",    with: user.email
          fill_in "Hasło do serwisu Your Bunch", with: user.password
          click_button "Zaloguj się"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edycja użytkownika')
          end
        end
      end


      describe "w kontrolerze Users" do

        describe "odwiedzając stronę edycji" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Zaloguj się') }
        end

        describe "przedkładanie działań aktualizacji" do
          before { put user_path(user) }
          specify { response.should redirect_to(zaloguj_path) }
        end


        describe "as wrong user" do
          let(:user) { FactoryGirl.create(:user) }
          let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
          before { sign_in user }

          describe "visiting Users#edit page" do
            before { visit edit_user_path(wrong_user) }
            it { should_not have_selector('title', text: full_title('Edit user')) }
          end

          describe "submitting a PUT request to the Users#update action" do
            before { put user_path(wrong_user) }
            specify { response.should redirect_to(root_path) }
          end
        end






        describe "odwiedzając indeks użytkownika" do
          before { visit users_path }
          it { should have_selector('title', text: 'Zaloguj się') }
        end

      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end



  end

end

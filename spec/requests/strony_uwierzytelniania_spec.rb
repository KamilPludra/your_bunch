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


  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do


        describe "in the Relationships controller" do
          describe "submitting to the create action" do
            before { post relationships_path }
            specify { response.should redirect_to(signin_path) }
          end

          describe "submitting to the destroy action" do
            before { delete relationship_path(1) }
            specify { response.should redirect_to(signin_path) }
          end
        end

            describe "visiting the following page" do
              before { visit following_user_path(user) }
              it { should have_selector('title', text: 'Sign in') }
            end

        describe "visiting the followers page" do
          before { visit followers_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end
      end

          describe "in the Microposts controller" do

        describe "submitting to the create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { response.should redirect_to(signin_path) }
        end
      end

    end
  end

end

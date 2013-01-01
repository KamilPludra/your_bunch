require 'spec_helper'

describe "Strony uzytkownikow" do

  subject { page }

  describe "Strona Rejestracji" do
    before { visit zarejestruj_path }

    it { should have_selector('h1',    text: 'Zarejestruj') }
    it { should have_selector('title', text: full_title('Zarejestruj')) }
  end
end
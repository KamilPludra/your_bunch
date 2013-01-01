require 'spec_helper'

describe "Strony Statyczne" do

  subject { page }

  describe "Strona glowna" do
    before { visit root_path }

    it { should have_selector('h1',    text: 'Your Bunch') }
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector 'title', text: '| Home' }
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
require 'spec_helper'

describe "Strony Statyczne" do
  let(:base_title) { "Your Bunch" }
  describe "Strona glowna" do

    it "powinien miec h1 'Your Bunch'" do
      visit '/strony_statyczne/home'
      page.should have_selector('h1', :text => 'Your Bunch')
    end

    it "powinien miec tytul bazowy" do
      visit '/strony_statyczne/home'
      page.should have_selector('title', :text => "Your Bunch")
    end

    it "nie powinno miec wlasnego tytulu strony" do
      visit '/strony_statyczne/home'
      page.should_not have_selector('title', :text => '| Home')
    end
  end


describe "Strona pomocy " do

    it "powinien miec h1 'Pomoc'" do
      visit '/strony_statyczne/pomoc'
      page.should have_selector('h1', :text => 'Pomoc')
    end

    it "powinien miec tytul 'Pomoc'" do
      visit '/strony_statyczne/pomoc'
      page.should have_selector('title', :text => "#{base_title} | Pomoc")
    end
end


  describe "O stronie" do

    it "powinien miec h1 'O nas'" do
      visit '/strony_statyczne/onas'
      page.should have_selector('h1', :text => 'O nas')
    end

    it "powinien miec tytul 'O nas'" do
      visit '/strony_statyczne/onas'
      page.should have_selector('title', :text => "#{base_title} | O nas")
    end
  end

    describe "Strona Kontakt" do

      it "powinien miec h1 'Kontakt'" do
        visit '/strony_statyczne/kontakt'
        page.should have_selector('h1', :text => 'Kontakt')
      end

      it "powinien miec tytul 'Kontakt'" do
        visit '/strony_statyczne/kontakt'
        page.should have_selector('title', :text => "#{base_title} | Kontakt")
      end
  end
end
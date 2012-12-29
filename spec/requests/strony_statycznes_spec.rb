require 'spec_helper'

describe "Strony Statyczne" do
  describe "Strona glowna" do

    it "powinien miec h1 'Your Bunch'" do
      visit '/strony_statyczne/home'
      page.should have_selector('h1', :text => 'Your Bunch')
    end

    it "powinien miec tytul 'Home'" do
      visit '/strony_statyczne/home'
      page.should have_selector('title',
                                :text => "Your Bunch | Home")
    end
  end


describe "Strona pomocy " do

    it "powinien miec h1 'Pomoc'" do
      visit '/strony_statyczne/pomoc'
      page.should have_selector('h1', :text => 'Pomoc')
    end

    it "powinien miec tytul 'Pomoc'" do
      visit '/strony_statyczne/pomoc'
      page.should have_selector('title',
                                :text => "Your Bunch | Pomoc")
    end
end


  describe "O stronie" do

    it "powinien miec h1 'O nas'" do
      visit '/strony_statyczne/onas'
      page.should have_selector('h1', :text => 'O nas')
    end

    it "powinien miec tytul 'O nas'" do
      visit '/strony_statyczne/onas'
      page.should have_selector('title',
                                :text => "Your Bunch | O nas")
    end
  end
end
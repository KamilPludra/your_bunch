# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# encoding: utf-8

require 'spec_helper'
# encoding: utf-8

describe User do

  before do

    @user = User.new(name: "Przykladowy Uzytkownik", email: "przykladowy@uzytkownik.pl",
                     password: "pludra", password_confirmation: "pludra")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should be_valid }

  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }

  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }

  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }


  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }

  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }

  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end



  describe "Pamietaj token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

##############        WALIDACJA nazwy użytkownika        ##############

  describe "gdy imie jest niewypelnione" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "gdy imie jest zbyt dlugie" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

##############        WALIDACJA email        ##############

  describe "gdy email jest niewypelniony" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "kiedy format email jest nieprawidlowy" do
    it "should be invalid" do
      adresx = %w[kamil@wer,com kamil_at_wer.org kamil.pludra@wsd.
                     kamil@pln_kmn.com kamil@okm+tgb.com]
      adresx.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "kiedy format email jest prawidlowy" do
    it "powinien byc przyjety" do
      adresx = %w[kamil@mail.COM K_PLUD-RA@a.b.org kamil.pludra@wer.jp x+y@wsd.cn]
      adresx.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "gdy adres email jest juz zajety" do
    before do
      taki_sam_email = @user.dup
      taki_sam_email.email = @user.email.upcase
      taki_sam_email.save
    end

    it { should_not be_valid }
  end

##############        WALIDACJA hasła        ##############

  describe "gdy haslo jest niewypelnione" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "gdy haslo nie zgadza sie z potwierdzeniem hasla" do
    before { @user.password_confirmation = "niezgodnosc" }
    it { should_not be_valid }
  end

  describe "gdy potwierdzenie hasla jest nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "z haslem, ktore jest zbyt krotkie" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "zwroci wartosc metody uwierzytelniania" do
    before { @user.save }
    let(:znaleziono_uzytkownika) { User.find_by_email(@user.email) }

    describe "z prawidlowym haslem" do
      it { should == znaleziono_uzytkownika.authenticate(@user.password) }
    end

    describe "z nieprawidlowym haslem" do
      let(:uzytkownikZnieprawilowym_hasle) { znaleziono_uzytkownika.authenticate("nieprawidlowym") }

      it { should_not == uzytkownikZnieprawilowym_hasle }
      specify { uzytkownikZnieprawilowym_hasle.should be_false }
    end
  end

  describe "adres email w mieszanej wilokosci liter" do
    let(:mieszany_email) { "Kamil@PlUdRa.CoM" }

    it "powinien byc zapisany caly malymi literami" do
      @user.email = mieszany_email
      @user.save
      @user.reload.email.should == mieszany_email.downcase
    end
  end



  describe "micropost associations" do

    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end


    it "should destroy associated microposts" do
      microposts = @user.microposts.dup
      @user.destroy
      microposts.should_not be_empty
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end

  end


  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end


    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end

  end



end

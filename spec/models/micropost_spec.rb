# encoding: utf-8

require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "dostępne atrybuty" do
    it "nie powinno umożliwić dostęp do user_id" do
      expect do
        Micropost.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "gdy nie jest obecny user_id" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "z pustą zawartością" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  describe "z zawartością, która jest zbyt długa" do
    before { @micropost.content = "a" * 1001 }
    it { should_not be_valid }
  end
end
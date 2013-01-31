require 'spec_helper'

describe Relationship do

  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { should be_valid }

  describe "dostępne atrybuty" do
    it "nie powinny umożliwić dostęp do follower_id" do
      expect do
        Relationship.new(follower_id: follower.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end


  describe "metody zwolennik" do
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    its(:follower) { should == follower }
    its(:followed) { should == followed }
  end


  describe "gdy po id nie jest obecny" do
    before { relationship.followed_id = nil }
    it { should_not be_valid }
  end

  describe "gdy id wyznawca nie jest obecny" do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end
end
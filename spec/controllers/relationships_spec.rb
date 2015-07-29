require 'spec_helper'

describe RelationshipsController do
  describe "GET#index" do
    it "sets @relationship to current users following relationship" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
    
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end
  end
  
  describe "DELETE#destroy" do
    it "deletes @relationship if current user is a follower" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end
    it "does not delete @relationship if current user is not the follower" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      sam = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: sam, leader: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end
    
    it "redirects to the people page is relationship is successfully deleted" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end
    
    it_behaves_like "requires sign in" do
      let(:action) {delete :destroy, id: 4}
    end
  end
  
  describe "POST#create" do
    it_behaves_like "requires sign in" do
      let(:action) {post :create, leader_id: 3}
    end
    
    it "creates a relationship where the current user follows the leader" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      post :create, leader_id: bob.id
      expect(alice.following_relationships.first.leader).to eq(bob)
    end
    
    it "redirects to the peoples page" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      post :create, leader_id: bob.id
      expect(response).to redirect_to people_path
    end
    
    it "does not create a relationship if the current user already follows the leader" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)
      post :create, leader_id: bob.id
      expect(Relationship.count).to eq(1)
    end
    
    it "does not allow current user to follow itself" do
      alice = Fabricate(:user)
      set_current_user(alice)
      post :create, leader_id: alice.id
      expect(Relationship.count).to eq(0)
    end
    
  end
  
end
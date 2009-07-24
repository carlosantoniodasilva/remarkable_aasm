require File.join(File.dirname(__FILE__), "spec_helper.rb")

require 'aasm'

create_table "users" do end

class User < ActiveRecord::Base
  include AASM
  aasm_column :state
  aasm_initial_state :pending
  aasm_state :passive
  aasm_state :pending
  aasm_state :active
  aasm_state :suspended
  aasm_state :deleted

  aasm_event :register do
    transitions :from => :passive, :to => :pending, :on_transition => :valid?
  end

  aasm_event :activate do
    transitions :from => :pending, :to => :active
  end

  aasm_event :suspend do
    transitions :from => [:passive, :pending, :active], :to => :suspended
  end

  aasm_event :delete do
    transitions :from => [:passive, :pending, :active, :suspended], :to => :deleted
  end
end

describe Remarkable::AASM do
  describe "aasm column" do
    it "should validate a model defines the aasm column" do
      aasm(:state).matches?(User.new).should be_true
    end

    it "should validate a model doesn't respond to wrong aasm column" do
      aasm(:status).matches?(User.new).should be_false
    end
  end

  describe "aasm initial state" do
    it "should validate a model defines the initial state" do
      aasm(:state, :initial_state => :pending).matches?(User.new).should be_true
    end

    it "should validate a model doesn't define the wrong initial state" do
      aasm(:state, :initial_state => :passive).matches?(User.new).should be_false
    end
  end

  describe "aasm states" do
    context "using one state as a symbol" do
      it "should validate a model defines the state" do
        aasm(:state, :states => :pending).matches?(User.new).should be_true
      end

      it "should validate a model doesn't define the state" do
        aasm(:state, :states => :inactive).matches?(User.new).should be_false
      end
    end

    context "using an array with one or more states" do
      it "should validate a model defines all states" do
        aasm(:state, :states => [:passive, :pending, :active, :suspended, :deleted]).matches?(User.new).should be_true
      end

      it "should validate all states in any order" do
        aasm(:state, :states => [:passive, :pending, :active, :suspended, :deleted].shuffle).matches?(User.new).should be_true
      end

      it "should validate a model doesn't define a state" do
        aasm(:state, :states => [:passive, :pending, :active, :suspended, :deleted, :inactive]).matches?(User.new).should be_false
      end
    end
  end

  describe "aasm events" do
    context "using one event as a symbol" do
      it "should validate a model defines the event" do
        aasm(:state, :events => :activate).matches?(User.new).should be_true
      end

      it "should validate a model doesn't define the event" do
        aasm(:state, :states => :inactivate).matches?(User.new).should be_false
      end
    end

    context "using an array with one or more events" do
      it "should validate a model defines all events" do
        aasm(:state, :events => [:register, :activate, :suspend, :delete]).matches?(User.new).should be_true
      end

      it "should validate all eventes in any order" do
        aasm(:state, :events => [:register, :activate, :suspend, :delete].shuffle).matches?(User.new).should be_true
      end

      it "should validate a model doesn't define a event" do
        aasm(:state, :events => [:register, :activate, :suspend, :delete, :inactivate]).matches?(User.new).should be_false
      end
    end
  end
end


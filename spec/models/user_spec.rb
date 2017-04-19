require 'rails_helper'

RSpec.describe User, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  subject { described_class.new(name: "navya", email: "navya@gmail.com", cost_of_meal: 60) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without an email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end
    it "is not valid without an cost_of_meal" do
    subject.cost_of_meal = nil
    expect(subject).to_not be_valid
    end
  end

  describe "Associations" do
    it "has many expenses" do
      assc = described_class.reflect_on_association(:expenses)
      expect(assc.macro).to eq :has_many
    end
    it "has many user_payments" do
      assc= described_class.reflect_on_association(:user_payment)
      expect(assc.macro).to eq :has_many
    end
  end

end
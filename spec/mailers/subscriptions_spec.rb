require "rails_helper"

RSpec.describe SubscriptionsMailer, :type => :mailer do # rubocop:disable Metrics/BlockLength
  describe "signup" do
    let(:mail) { SubscriptionsMailer.signup }

    it "renders the headers" do
      expect(mail.subject).to eq("Signup")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "lesson" do
    let(:mail) { SubscriptionsMailer.lesson }

    it "renders the headers" do
      expect(mail.subject).to eq("Lesson")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "complete" do
    let(:mail) { SubscriptionsMailer.complete }

    it "renders the headers" do
      expect(mail.subject).to eq("Complete")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "paused" do
    let(:mail) { SubscriptionsMailer.paused }

    it "renders the headers" do
      expect(mail.subject).to eq("Paused")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end
end

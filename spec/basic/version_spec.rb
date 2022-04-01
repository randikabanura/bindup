# frozen_string_literal: true

RSpec.describe Bindup::VERSION, type: :module do
  it "has a version number" do
    expect(Bindup::VERSION).not_to be nil
  end
end

# frozen_string_literal: true

RSpec.describe "HTTP::GET" do
  it "does calls a GET API endpoint" do
    response_body, = Bindup::BSSMW::V1.first_test_api

    expect(JSON.parse(response_body)["data"]).to eq(nil)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/json")
  end
end

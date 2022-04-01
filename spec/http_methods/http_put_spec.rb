# frozen_string_literal: true

RSpec.describe "HTTP::PUT" do
  it "does calls a PUT json API endpoint" do
    params = { test: "test" }
    response_body, = Bindup::BSSMW::V1.fourth_test_api(params)

    expect(JSON.parse(JSON.parse(response_body)["data"])).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/json")
  end

  it "does calls a PUT urlencoded API endpoint" do
    params = { test: "test" }
    response_body, = Bindup::Telco::V2.first_test_api(params)

    expect(JSON.parse(response_body)["form"]).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/x-www-form-urlencoded")
  end
end
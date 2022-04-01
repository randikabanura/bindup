# frozen_string_literal: true

RSpec.describe "HTTP::POST" do
  it "does calls a POST json API endpoint" do
    params = { test: "test" }
    response_body, = Bindup::BSSMW::V1.second_test_api(params, { "Content-Type": "application/test" })

    expect(JSON.parse(JSON.parse(response_body)["data"])).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/test")
  end

  it "does calls a POST json API endpoint without parameters" do
    response_body, = Bindup::BSSMW::V1.second_test_api

    expect(JSON.parse(response_body)["data"]).to eq("")
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/json")
  end

  it "does calls a POST urlencoded API endpoint" do
    params = { test: "test" }
    response_body, = Bindup::BSSMW::V1.third_test_api(params)

    expect(JSON.parse(response_body)["form"]).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/x-www-form-urlencoded")
  end
end

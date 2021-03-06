# frozen_string_literal: true

RSpec.describe "HTTP::GET" do
  it "does calls a GET API endpoint" do
    response_body, = Bindup::BSSMW::V1.first_test_api

    expect(JSON.parse(response_body)["args"]).to eq({})
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/json")
  end

  it "does calls a GET urlencoded API endpoint" do
    params = { test: "test" }
    response_body, = Bindup::BSSMW::V1.fifth_test_api(params)

    expect(JSON.parse(response_body)["args"]).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/x-www-form-urlencoded")
  end

  it "does calls a GET urlencoded API endpoint with form payload" do
    params = { test: "test" }
    response_body, = Bindup::BSSMW::V1.fifth_test_api(params, extra_params: params)

    expect(JSON.parse(response_body)["args"]).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/x-www-form-urlencoded")
  end

  it "does calls a GET json API endpoint with json payload" do
    params = { test: "test" }
    response_body, = Bindup::BSSMW::V1.first_test_api(params, extra_params: params)

    expect(JSON.parse(response_body)["args"]).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/json")
  end
end

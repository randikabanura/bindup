# frozen_string_literal: true

RSpec.describe "HTTP::PUT" do
  it "does calls a PUT json API endpoint" do
    params = { test: "test" }
    response_body, = Bindup::BSSMW::V1.fourth_test_api(params)

    expect(JSON.parse(JSON.parse(response_body)["data"])).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/json")
  end

  it "does calls a PUT json API endpoint without parameters" do
    response_body, = Bindup::BSSMW::V1.fourth_test_api

    expect(JSON.parse(response_body)["data"]).to eq("")
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/json")
  end

  it "does calls a PUT urlencoded API endpoint" do
    params = { test: "test" }
    response_body, = Bindup::Telco::V2.first_test_api(params)

    expect(JSON.parse(response_body)["form"]).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/x-www-form-urlencoded")
  end

  it "does calls a PUT urlencoded API endpoint without parameters" do
    response_body, = Bindup::Telco::V2.first_test_api

    expect(JSON.parse(response_body)["form"]).to eq({})
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/x-www-form-urlencoded")
  end

  it "does calls a PUT json API endpoint with extra parameters" do
    params = { test: "test" }
    response_body, = Bindup::BSSMW::V1.fourth_test_api(params, extra_params: params)

    expect(JSON.parse(JSON.parse(response_body)["data"])).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["args"]).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/json")
  end

  it "does calls a PUT urlencoded API endpoint with extra parameters" do
    params = { test: "test" }
    response_body, = Bindup::Telco::V2.first_test_api(params, extra_params: params)

    expect(JSON.parse(response_body)["form"]).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["args"]).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/x-www-form-urlencoded")
  end
end

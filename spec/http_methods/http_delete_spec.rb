# frozen_string_literal: true

RSpec.describe "HTTP::DELETE" do
  it "does calls a DELETE json API endpoint" do
    params = { test: "test" }
    response_body, = Bindup::Telco::V2.third_test_api(params)

    expect(JSON.parse(response_body)["args"]).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/json")
  end

  it "does calls a DELETE urlencoded API endpoint" do
    params = { test: "test" }
    response_body, = Bindup::Telco::V2.second_test_api(params)

    expect(JSON.parse(response_body)["args"]).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/x-www-form-urlencoded")
  end

  it "does calls a DELETE urlencoded API endpoint with extra parameters" do
    params = { test: "test" }
    response_body, = Bindup::Telco::V2.second_test_api(params, extra_params: params)

    expect(JSON.parse(response_body)["args"]).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["form"]).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/x-www-form-urlencoded")
  end

  it "does calls a DELETE json API endpoint with extra parameters" do
    params = { test: "test" }
    response_body, = Bindup::Telco::V2.third_test_api(params, extra_params: params)

    expect(JSON.parse(response_body)["args"]).to eq(params.stringify_keys)
    expect(JSON.parse(JSON.parse(response_body)["data"])).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/json")
  end

  it "does calls a DELETE urlencoded API endpoint with multiple extra parameters" do
    params = { test: "test", "test-2": "test-2" }
    response_body, = Bindup::Telco::V2.second_test_api(params, extra_params: params)

    expect(JSON.parse(response_body)["args"]).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["form"]).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/x-www-form-urlencoded")
  end

  it "does calls a DELETE json API endpoint with extra parameters" do
    params = { test: "test", "test-2": "test-2" }
    response_body, = Bindup::Telco::V2.third_test_api(params, extra_params: params)

    expect(JSON.parse(response_body)["args"]).to eq(params.stringify_keys)
    expect(JSON.parse(JSON.parse(response_body)["data"])).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/json")
  end
end

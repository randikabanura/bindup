# frozen_string_literal: true

RSpec.describe Bindup do
  it "has a version number" do
    expect(Bindup::VERSION).not_to be nil
  end

  it "does gets configuration" do
    expect(Bindup.configuration.config_path).to eq("./spec/config/config.yml")
  end

  it "does gets component service name" do
    service_names = Bindup.component_setup["components"].keys

    expect(Bindup.component_setup["components"][service_names[0]]["name"]).to eq("BSSMW")
  end

  it "does gets component service version" do
    service_names = Bindup.component_setup["components"].keys
    versions = Bindup.component_setup["components"][service_names[0]]["version"]

    expect(versions[0]["name"]).to eq("V1")
  end

  it "does gets component service API" do
    service_names = Bindup.component_setup["components"].keys
    versions = Bindup.component_setup["components"][service_names[0]]["version"]
    first_version_apis = versions[0]["apis"]

    expect(first_version_apis[0]["name"]).to eq("first_test_api")
  end

  it "does gets a API endpoint of a service version" do
    bssmw_api_endpoint = Bindup::BSSMW::V1.API_ENDPOINT
    telco_api_endpoint = Bindup::Telco::V2.API_ENDPOINT

    expect(bssmw_api_endpoint).to eq("https://gorest.co.in")
    expect(telco_api_endpoint).to eq("https://gorest.co.in")
  end

  it "does calls a GET API endpoint" do
    response_body, = Bindup::BSSMW::V1.first_test_api

    expect(JSON.parse(response_body)["data"]).to eq(nil)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/json")
  end

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

  it "does calls a DELETE urlencoded API endpoint with form payload" do
    params = { test: "test" }
    response_body, = Bindup::Telco::V2.second_test_api(params, body: params)

    expect(JSON.parse(response_body)["args"]).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["form"]).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/x-www-form-urlencoded")
  end

  it "does calls a DELETE json API endpoint" do
    params = { test: "test" }
    response_body, = Bindup::Telco::V2.third_test_api(params, body: params)

    expect(JSON.parse(response_body)["args"]).to eq(params.stringify_keys)
    expect(JSON.parse(JSON.parse(response_body)["data"])).to eq(params.stringify_keys)
    expect(JSON.parse(response_body)["headers"]["Content-Type"]).to eq("application/json")
  end
end

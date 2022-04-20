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
    response_body, response_headers = Bindup::BSSMW::V1.first_test_api

    expect(response_body).not_to eq(nil)
    expect(response_headers).not_to eq(nil)
  end

  it "does calls a POST json API endpoint" do
    response_body, response_headers = Bindup::BSSMW::V1.second_test_api(headers: { content_type: "application/json" },
                                                                        params: { test: "test" })

    expect(response_body).not_to eq(nil)
    expect(response_headers).not_to eq(nil)
  end

  it "does calls a POST urlencoded API endpoint" do
    response_body, response_headers = Bindup::BSSMW::V1.third_test_api(params: { test: "test" })

    expect(response_body).not_to eq(nil)
    expect(response_headers).not_to eq(nil)
  end

  it "does calls a PUT json API endpoint" do
    response_body, response_headers = Bindup::BSSMW::V1.fourth_test_api(params: { test: "test" })

    expect(response_body).not_to eq(nil)
    expect(response_headers).not_to eq(nil)
  end

  it "does calls a PUT urlencoded API endpoint" do
    response_body, response_headers = Bindup::Telco::V2.first_test_api(params: { test: "test" })

    expect(response_body).not_to eq(nil)
    expect(response_headers).not_to eq(nil)
  end
end

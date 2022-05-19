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

  it "does calls a API endpoint" do
    response = Bindup::BSSMW::V1.first_test_api
    response_body = response.body
    expect(response_body).not_to eq(nil)
  end
end

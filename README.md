# Bindup (Customizable API Wrapper)

Bindup is able to wrap API from other services so the Ruby application
use those API with out having to implement a new module to deal with
every single API or having to create a gem. Bindup will be able to
setup multiple services at once so that integrating whole new service
is easy as changing the config

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add bindup

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install bindup

## Usage

To use this gem please create a configure file for the gem. If using rails 
preferred location would be `./config/initializers/bindup.rb`. Whatever the location
config should be as followed:

```ruby
Bindup.configure do |config|
  config.config_path = "./spec/config/config.yml"
  config.log_response = true
  config.log_response_params = { headers: true, bodies: true }
end
```

You can and should change these configurations as necessary. Config path should be given to
`config.yml` that consists of your APIs.

### Basic config.yml

```yaml
components:
  bssmw:
    name: 'BSSMW'
    base_url: 'https://gorest.co.in'
    version:
      - name: 'V1'
        base_url: 'https://gorest.co.in'
        apis:
          - name: "first_test_api"
            url: "get"
            base_url: "https://httpbin.org"
            verb: "GET"
            type: "json"
          - name: "second_test_api"
            base_url: "https://httpbin.org"
            url: "post"
            verb: "POST"
            type: "json"
          - name: "third_test_api"
            base_url: "https://httpbin.org"
            url: "post"
            verb: "POST"
            type: "urlencoded"
          - name: "fourth_test_api"
            base_url: "https://httpbin.org"
            url: "put"
            verb: "PUT"
            type: "json"
  telco:
      name: 'Telco'
      version:
        - name: 'V2'
          base_url: 'https://gorest.co.in'
          apis:
            - name: "first_test_api"
              base_url: "https://httpbin.org"
              url: "put"
              verb: "PUT"
              type: "urlencoded"
            - name: "second_test_api"
              base_url: "https://httpbin.org"
              url: "delete"
              verb: "DELETE"
              type: "urlencoded"
            - name: "third_test_api"
              base_url: "https://httpbin.org"
              url: "delete"
              verb: "DELETE"
              type: "json"
```

### Basic usage

After setting config like as format given above the APIs would be usable as following.

#### Get APIs

This methods will response with `response_body` and `response_status`.

```ruby
# Which calls the API without any parameters
response_body, = Bindup::BSSMW::V1.first_test_api

# Which calls the urlencoded API with parameters
params = { test: "test" }
response_body, = Bindup::BSSMW::V1.fifth_test_api(params)

# Which calls the API with parameters and extra parameters for the body
params = { test: "test" }
response_body, = Bindup::BSSMW::V1.first_test_api(params, extra_params: params)
```

#### Post APIs

This methods will response with `response_body` and `response_status`.

```ruby
# Which calls the API without any parameters
response_body, = Bindup::BSSMW::V1.second_test_api

# Which calls the urlencoded API with parameters
params = { test: "test" }
response_body, = Bindup::BSSMW::V1.third_test_api(params)

# Which calls the API with parameters with headers and extra parameters for the query params
params = { test: "test" }
response_body, = Bindup::BSSMW::V1.second_test_api(params, { "Content-Type": "application/test" }, extra_params: params)

# Which calls the API with parameters and extra parameters for the query params
params = { test: "test" }
response_body, = Bindup::BSSMW::V1.third_test_api(params, extra_params: params)

# Which calls the API with parameters and headers
params = { test: "test" }
response_body, = Bindup::BSSMW::V1.second_test_api(params, { "Content-Type": "application/test" })
```

#### Delete Apis

This methods will response with `response_body` and `response_status`.

```ruby
#  Which calls the API with parameters
params = { test: "test" }
response_body, = Bindup::Telco::V2.third_test_api(params)

# Which calls the urlencoded API with parameters
params = { test: "test" }
response_body, = Bindup::Telco::V2.second_test_api(params)

# Which calls the API with parameters and extra parameters for the body
params = { test: "test" }
response_body, = Bindup::Telco::V2.third_test_api(params, extra_params: params)
```

#### Put APIs

```ruby
# Which calls the API without any parameters
response_body, = Bindup::BSSMW::V1.fourth_test_api

# Which calls the API with parameters
params = { test: "test" }
response_body, = Bindup::BSSMW::V1.fourth_test_api(params)

# Which calls the urlencoded API with parameters
params = { test: "test" }
response_body, = Bindup::Telco::V2.first_test_api(params)

# Which calls the urlencoded API with parameters and extra parameters for the query params
params = { test: "test" }
response_body, = Bindup::Telco::V2.first_test_api(params, extra_params: params)
```

## Do you like it? Star it!

If you use this component just star it. A developer is more motivated to improve a project when there is some interest.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/randikabanura/bindup. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/randikabanura/bindup/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT). You can review the licence [here](./LICENSE.txt).

## Code of Conduct

Everyone interacting in the Bindup project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/bindup/blob/master/CODE_OF_CONDUCT.md).

## Developer

Name: [Banura Randika Perera](https://github.com/randikabanura) <br/>
Linkedin: [randika-banura](https://www.linkedin.com/in/randika-banura/) <br/>
Email: [randika.banura@gamil.com](mailto:randika.banura@gamil.com) <br/>
Bsc (Hons) Information Technology specialized in Software Engineering (SLIIT) <br/>
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

TODO: Write usage instructions here

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
```

## Do you like it? Star it!

If you use this component just star it. A developer is more motivated to improve a project when there is some interest.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

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
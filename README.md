# rails_respond_to_pb

This gem allows you to route RPC calls via protobuf to an existing rails controller. Currently supporting:

- [Twirp](https://github.com/twitchtv/twirp-ruby)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails_respond_to_pb'
```

And then execute:

```sh
bundle install
```

Or install it yourself as:

```sh
gem install rails_respond_to_pb
```

## Usage

This gem loads Rails middleware that routes to services with Controllers as Handlers.

- assumes a single `ThingsService` per controller
  - Typical Rails namey-ness conventions are followed here
    - assumes a `ThingsService` routes to a `ThingsController`
    - looking into building generating proto files from controllers
- loads any `_twirp.rb` files that exist within your app's `lib` directory
- allows a controller to `respond_to` the `pb` format
  - currently you'd respond with a `render plain: ThingResponse.new(id: 1, name: 'Foo').to_proto`
    - looking into `render pb:`

Generate a proto like this for each of your controllers (`rpc` methods should match your controller methods. `message` is to your discretion):

```proto
syntax = "proto3";

service Things {
  // these rpc methods are important - use what's in the corresponding ThingsController.
  // whatever is sent as an argument will be made available to the controller as `params`
  rpc create (ThingParams) returns (ThingResponse);
  rpc show (ThingParams) returns (ThingResponse);
  rpc index (ThingFilter) returns (ThingList);
  rpc update (ThingParams) returns (ThingResponse);
  rpc destroy (ThingParams) returns (ThingResponse);
}

message ThingParams {
  int32 id = 1;
  string name = 2;
}

message ThingFilter {
  string name = 1;
}

message ThingResponse {
  int32 id = 1;
  string name = 2;
}

message ThingList {
  repeated ThingResponse things = 1;
}
```

### Server

This gem will allow your app to respond to Twirp requests. There is little setup required, other than having the prerequisite Service files loaded in your application.

Given a Service file of `ThingsService`, this gem assumes the presence of a `ThingsController` with actions corresponding with `rpc` methods. To allow your controller to respond to the RPC request, simply update the action accordingly:

```ruby
def index
  # ... business as usual

  respond_to do |format|
    format.pb do
      render plain: ThingList.new(things: Thing.all.map { |r| ThingResponse.new(r.as_json) }).to_proto
    end
    format.json { render: Thing.all.as_json } # or whatever your controller responds to usually
  end
end
```

The **required** setup here is:

```ruby
respond_to do |format|
    format.pb do
      render plain: YourProtoResponse.to_proto
```

### Client

Assuming you have the prerequisite Client files loaded in your application, you can connect to a Twirp server as usual:

```ruby
client = ThingsClient.new('http://localhost:3000')
query = ThingFilter.new name: 'foo'
client.index(query)
```

## Development

I typically add an alias to make working with dockerized apps easier. This assumes [docker](https://docs.docker.com/get-docker/) is running.

```sh
alias dr="docker compose run --rm "
```

After checking out the repo, run `dr bundle install` to spin up a container, and install dependencies. Then, run `dr rspec spec` to run the tests. You can also run `dr bundle console` for an interactive prompt that will allow you to experiment.

To release a new version, update the version number in `version.rb`, and then run `dr bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Building protos

For inspiration on how to build proto files locally (and working with docker-compose), here are some services to use within your application:

```yaml
services:
  bundle: &bundle # run your typical bundle commands
    env_file: .env
    stdin_open: true
    tty: true
    build: .
    entrypoint: bundle
    command: check
    volumes:
      - .:/usr/src/app:delegated # hot reload your application's code
      - bundle:/usr/local/bundle:delegated # cache bundle installs
      - ~/Projects:/local # used to install gems locally rename ~/Projects to whichever dir your code lives in

  rspec: # run your tests!!
    <<: *bundle
    entrypoint: bundle exec rspec
    command: --version

  protoc: # generate code from proto files
    build: .
    entrypoint: bundle
    command: |
      exec grpc_tools_ruby_protoc
      -I ./lib/protos --ruby_out=./lib/protobuf --twirp_ruby_out=./lib/protobuf
      ./lib/protos/things.proto
    volumes:
      - .:/usr/src/app:delegated
      - bundle:/usr/local/bundle:delegated
```

The `twirp_ruby_out` function needs to be made available to your environment. Use a multistage file, like so:

```dockerfile
FROM golang:1 AS go
RUN go get github.com/twitchtv/twirp-ruby/protoc-gen-twirp_ruby

# or whatever version of ruby you're using
FROM ruby:3
# Install necessary executable to build protos
COPY --from=go /go/bin /usr/local/bin
```

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/[USERNAME]/rails_respond_to_pb). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/rails_respond_to_pb/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RailsRespondToPb project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rails_respond_to_pb/blob/main/CODE_OF_CONDUCT.md).

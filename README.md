# Elasticlunr S3

[![Test](https://github.com/heywhy/ex_elasticlunr_s3/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/heywhy/ex_elasticlunr_s3/actions)

Elasticlunr S3 is a storage provider for use with Elasticlunr. The library is built for S3 integration and it also works well with any AWS S3 API compatible storage provider like [minio](https://min.io) and the likes.

## Installation

The library can be installed by adding `elasticlunr_s3` to your list of dependencies in mix.exs:

```elixir
def deps do
  [
    {:elasticlunr, "~> 0.6"},
    {:elasticlunr_s3, "~> 0.1"}
  ]
end
```

Documentation can be found at [hexdocs.pm](https://hexdocs.pm/elasticlunr_s3).

## Usage

To configure your app to use the S3 provider:

```elixir
import Config

config :elasticlunr,
  storage: Elasticlunr.Storage.S3

config :elasticlunr, Elasticlunr.Storage.S3,
  bucket: "elasticlunr",
  access_key_id: <AWS_ACCESS_KEY_ID>,
  secret_access_key: <AWS_SECRET_ACCESS_KEY>,
  scheme: "http://", # optional
  host: "192.168.0.164", # optional
  port: 9000 # optional
```

## License

Elasticlunr is released under the MIT License - see the [LICENSE](https://github.com/heywhy/ex_elasticlunr_s3/blob/master/LICENSE) file.

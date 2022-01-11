defmodule Elasticlunr.S3.Client do
  @moduledoc false

  @callback list_objects(bucket :: binary(), opts :: keyword()) :: Enum.t()

  @callback download_object(
              bucket :: binary(),
              object :: binary(),
              file :: binary(),
              opts :: keyword()
            ) :: {:ok, map()} | {:error, any()}

  @callback upload_object(
              bucket :: binary(),
              object :: binary(),
              file :: binary(),
              opts :: keyword()
            ) :: {:ok, map()} | {:error, any()}

  @callback delete_object(bucket :: binary(), object :: binary(), opts :: keyword()) ::
              {:ok, map()} | {:error, any()}
end

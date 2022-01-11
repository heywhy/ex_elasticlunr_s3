defmodule Elasticlunr.S3.ClientImpl do
  @moduledoc false

  alias ExAws.S3

  @behaviour Elasticlunr.S3.Client

  @impl true
  def list_objects(bucket, opts) do
    S3.list_objects_v2(bucket)
    |> ExAws.stream!(opts)
  end

  @impl true
  def download_object(bucket, object, file, opts) do
    bucket
    |> S3.download_file(object, file)
    |> ExAws.request(opts)
  end

  @impl true
  def upload_object(bucket, object, path, opts) do
    path
    |> S3.Upload.stream_file()
    |> S3.upload(bucket, object)
    |> ExAws.request(opts)
  end

  @impl true
  def delete_object(bucket, object, opts) do
    bucket
    |> S3.delete_object(object)
    |> ExAws.request(opts)
  end
end

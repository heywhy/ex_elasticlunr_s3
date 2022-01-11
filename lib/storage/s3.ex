defmodule Elasticlunr.Storage.S3 do
  @moduledoc """
  This provider writes to indexes to an s3 project. To use, you need
  to include necessary s3 dependencies, see [repository](https://github.com/ex-aws/ex_aws_s3).

  ```elixir
  config :elasticlunr,
    storage: Elasticlunr.Storage.S3

  config :elasticlunr, Elasticlunr.Storage.S3,
    bucket: "elasticlunr",
    access_key_id: "minioadmin",
    secret_access_key: "minioadmin",
    scheme: "http://", # optional
    host: "192.168.0.164", # optional
    port: 9000 # optional
  ```
  """
  use Elasticlunr.Storage

  alias Elasticlunr.S3.ClientImpl
  alias Elasticlunr.{Index, Deserializer, Serializer}
  alias Elasticlunr.Storage.Disk

  @impl true
  def load_all do
    config(:bucket)
    |> client_module().list_objects(config_all())
    |> Stream.map(fn %{key: file} ->
      name = Path.basename(file, ".index")

      read(name)
    end)
  end

  @impl true
  def write(%Index{name: name} = index) do
    bucket = config(:bucket)
    object = "#{name}.index"
    data = Serializer.serialize(index)

    with path <- tmp_file("#{name}.index"),
         :ok <- Disk.write_serialized_index_to_file(path, data),
         {:ok, _} <- upload_object(bucket, object, path) do
      File.rm(path)
    end
  end

  @impl true
  def read(name) do
    bucket = config(:bucket)
    object = "#{name}.index"

    desirialize = fn path ->
      File.stream!(path, ~w[compressed]a)
      |> Deserializer.deserialize()
    end

    with path <- tmp_file("#{name}.index"),
         {:ok, _} <- download_object(bucket, object, path),
         %Index{} = index <- desirialize.(path),
         :ok <- File.rm(path) do
      index
    end
  end

  @impl true
  def delete(name) do
    config(:bucket)
    |> client_module().delete_object("#{name}.index", config_all())
    |> case do
      {:ok, _} ->
        :ok

      err ->
        err
    end
  end

  defp download_object(bucket, object, file) do
    client_module().download_object(bucket, object, file, config_all())
  end

  defp upload_object(bucket, object, file) do
    client_module().upload_object(bucket, object, file, config_all())
  end

  defp client_module, do: config(:client_module, ClientImpl)

  defp tmp_file(file) do
    Path.join(System.tmp_dir!(), file)
  end
end

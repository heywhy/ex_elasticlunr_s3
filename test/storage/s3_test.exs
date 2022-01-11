defmodule Elasticlunr.Storage.S3Test do
  use ExUnit.Case

  alias Elasticlunr.{Index, Pipeline, Storage}
  alias Elasticlunr.S3.ClientMock

  import Mox

  @provider_config [
    bucket: "test",
    client_module: ClientMock
  ]

  setup context do
    pipeline = Pipeline.new(Pipeline.default_runners())
    index = Index.new(pipeline: pipeline, name: "test")

    Application.put_env(:elasticlunr, Storage.S3, @provider_config)

    on_exit(fn ->
      Application.delete_env(:elasticlunr, Storage.S3)
      clean_up_tmp_indexes()
    end)

    Map.put(context, :index, index)
  end

  defp serialize_index_to(index, path) do
    data = Elasticlunr.Serializer.serialize(index)
    :ok = Storage.Disk.write_serialized_index_to_file(path, data)
  end

  defp clean_up_tmp_indexes do
    match = Path.join(System.tmp_dir!(), "*.index")

    Path.wildcard(match)
    |> Enum.map(&Path.expand/1)
    |> Enum.each(&File.rm!/1)
  end

  describe "serializing an index" do
    test "writes to s3", %{index: index} do
      expect(ClientMock, :upload_object, fn
        "test", "test.index", _, _ -> {:ok, %{}}
      end)

      assert :ok = Storage.S3.write(index)
    end

    test "fails writing to s3", %{index: index} do
      expect(ClientMock, :upload_object, fn
        "test", "test.index", _, _ -> {:error, :error_occured}
      end)

      assert {:error, :error_occured} = Storage.S3.write(index)
    end
  end

  describe "unserializing an index" do
    test "reads from s3 bucket", %{index: index} do
      expect(ClientMock, :download_object, fn
        "test", "test.index", path, _ ->
          serialize_index_to(index, path)
          {:ok, %{}}
      end)

      assert ^index = Storage.S3.read("test")
    end
  end

  describe "getting all serialized indexes" do
    test "returns an empty list" do
      expect(ClientMock, :list_objects, fn
        "test", _ -> []
      end)

      assert [] = Storage.S3.load_all() |> Enum.to_list()
    end

    test "loads and deserialize indexes", %{index: index} do
      expect(ClientMock, :list_objects, fn
        "test", _ -> [%{key: "test.index"}]
      end)

      expect(ClientMock, :download_object, fn
        "test", "test.index", path, _ ->
          serialize_index_to(index, path)
          {:ok, %{}}
      end)

      assert [^index] = Storage.S3.load_all() |> Enum.to_list()
    end
  end

  describe "deleting index from storage" do
    test "works successfully" do
      expect(ClientMock, :delete_object, fn
        "test", "hello.index", _ -> {:ok, %{}}
      end)

      assert :ok = Storage.S3.delete("hello")
    end

    test "fails for missing index" do
      expect(ClientMock, :delete_object, fn
        _, _, _ -> {:error, :missing_object}
      end)

      assert {:error, :missing_object} = Storage.S3.delete("missing")
    end
  end
end

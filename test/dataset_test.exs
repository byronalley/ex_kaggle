defmodule ExKaggle.DatasetTest do
  use ExUnit.Case, async: true
  import Mox

  alias ExKaggle.Dataset

  setup :verify_on_exit!

  @dataset_url "https://www.kaggle.com/api/v1/datasets/download/test/dataset"
  @dataset_name "test/dataset"

  @tag :tmp_dir
  @tag :capture_log
  test "downloads and extracts dataset by url", %{tmp_dir: tmp_dir} do
    ExKaggle.ClientMock
    |> expect(:get, fn @dataset_url, [into: stream] ->
      File.stream!("test/files/abcd.zip")
      |> Enum.into(stream)

      {:ok, %Req.Response{status: 200, body: "abcd"}}
    end)

    assert {:ok, [filename]} = Dataset.download(@dataset_url, tmp_dir, ExKaggle.ClientMock)

    assert File.read!(filename) == "abcd\n"
  end

  @tag :tmp_dir
  @tag :capture_log
  test "downloads and extracts dataset by name", %{tmp_dir: tmp_dir} do
    ExKaggle.ClientMock
    |> expect(:get, fn @dataset_url, [into: stream] ->
      File.stream!("test/files/abcd.zip")
      |> Enum.into(stream)

      {:ok, %Req.Response{status: 200, body: "abcd"}}
    end)

    assert {:ok, [filename]} = Dataset.download(@dataset_name, tmp_dir, ExKaggle.ClientMock)

    assert File.read!(filename) == "abcd\n"
  end

  @tag :tmp_dir
  @tag :capture_log
  test "raises error when extraction fails", %{tmp_dir: tmp_dir} do
    ExKaggle.ClientMock
    |> expect(:get, fn @dataset_url, [into: stream] ->
      ["not a zip"] |> Enum.into(stream)
      {:ok, %Req.Response{status: 200, body: "not a zip"}}
    end)

    assert {:error, "Failed to unzip file: :einval"} =
             Dataset.download(@dataset_url, tmp_dir, ExKaggle.ClientMock)
  end
end

defmodule ExKaggle.DatasetTest do
  use ExUnit.Case, async: true
  import Mox

  alias ExKaggle.Dataset

  setup :verify_on_exit!

  @dummy_url "https://www.kaggle.com/api/v1/datasets/download/test/dummy"

  @tag :tmp_dir
  test "downloads and extracts dataset successfully", %{tmp_dir: tmp_dir} do
    ExKaggle.ClientMock
    |> expect(:get, fn @dummy_url, [into: stream] ->
      File.stream!("test/files/abcd.zip")
      |> Enum.into(stream)

      {:ok, %Req.Response{status: 200, body: "abcd"}}
    end)

    assert {:ok, [filename]} = Dataset.download(@dummy_url, tmp_dir, ExKaggle.ClientMock)

    assert File.read!(filename) == "abcd\n"
  end

  @tag :tmp_dir
  test "raises error when extraction fails", %{tmp_dir: tmp_dir} do
    ExKaggle.ClientMock
    |> expect(:get, fn @dummy_url, [into: stream] ->
      ["not a zip"] |> Enum.into(stream)
      {:ok, %Req.Response{status: 200, body: "not a zip"}}
    end)

    assert {:error, "Failed to unzip file: :einval"} =
             Dataset.download(@dummy_url, tmp_dir, ExKaggle.ClientMock)
  end
end

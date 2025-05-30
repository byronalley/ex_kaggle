defmodule ExKaggle.Dataset do
  @moduledoc """
  Functions for downloading and interacting with Kaggle datasets.
  """

  require Logger

  @dataset_url_prefix "https://www.kaggle.com/api/v1/datasets/download/"

  @doc """
  Downloads and unzips the given dataset to the specified destination directory.

  `dataset` is either an API URL or in the form `username/dataset_name`

  Returns a list of the extracted filenames. Often this is just one filename.
  """
  def download(dataset, dest_dir, client \\ ExKaggle.Client) do
    url =
      @dataset_url_prefix
      |> URI.merge(dataset)
      |> to_string()

    temp_zip_path =
      Path.join(System.tmp_dir!(), "kaggle_dataset_#{System.unique_integer([:positive])}.zip")

    Logger.info("Downloading dataset to temporary zip file...")

    Logger.info("Zipfile downloaded. Uncompressing...")

    temp_stream = File.stream!(temp_zip_path)

    with {:ok, _response} <- client.get(url, into: temp_stream),
         :ok <- File.mkdir_p(Path.expand(dest_dir)),
         :ok <- Logger.info("Extracting dataset to #{dest_dir}."),
         {:ok, filenames} <-
           unzip(temp_zip_path, dest_dir) do
      File.rm(temp_zip_path)

      {:ok, filenames}
    end
  end

  defp unzip(zip_path, destination_dir) do
    zip_full_path =
      zip_path
      |> Path.expand()
      |> String.to_charlist()

    dest_full_path =
      destination_dir
      |> Path.expand()
      |> String.to_charlist()

    case :zip.extract(zip_full_path, cwd: dest_full_path) do
      {:ok, filenames} ->
        {:ok, Enum.map(filenames, &to_string/1)}

      {:error, reason} ->
        {:error, "Failed to unzip file: #{inspect(reason)}"}
    end
  end
end

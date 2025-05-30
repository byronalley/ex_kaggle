defmodule ExKaggle.Dataset do
  @moduledoc """
  Functions for downloading and interacting with Kaggle datasets.
  """

  require Logger

  @doc """
  Downloads and unzips the given dataset to the specified destination directory.

  Returns a list of the extracted filenames. Usually this should just be one filename.
  """
  def download(url, dest_dir, client \\ ExKaggle.Client) do
    temp_zip_path =
      Path.join(System.tmp_dir!(), "kaggle_dataset_#{System.unique_integer([:positive])}.zip")

    Logger.info("Downloading dataset to temporary zip file...")

    dbg(temp_zip_path)

    Logger.info("Zipfile downloaded. Uncompressing...")

    temp_stream =
      File.stream!(temp_zip_path)

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

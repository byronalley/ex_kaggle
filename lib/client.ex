defmodule ExKaggle.Client do
  @moduledoc """
  A client wrapper to use credentials to access the Kaggle API

  Either username and key are in the kaggle config file ("~/.kaggle/kaggle.json")
  or stored as environment variables: `KAGGLE_USERNAME`, `KAGGLE_KEY`
  """

  require Logger

  @kaggle_config Path.expand("~/.kaggle/kaggle.json")

  @callback get(url :: String.t(), options :: keyword) ::
              {:ok, Req.Response.t()} | {:error, String.t()}

  @doc """
  Make a get request with API credentials.
  """
  def get(url, opts \\ []) do
    %{username: username, key: key} = credentials()

    opts =
      Keyword.merge(
        [
          url: url,
          redirect: true,
          auth: {:basic, "#{username}:#{key}"}
        ],
        opts
      )

    case Req.get(opts) do
      {:ok, response = %{status: 200}} ->
        {:ok, response}

      {:ok, %{status: status, body: body}} ->
        {:error, "#{status}: #{body["message"]}"}

      {:error, exception} ->
        {:error, inspect(exception)}
    end
  end

  @doc """
  Check that the credentials are working
  """
  def validate do
    case get("https://www.kaggle.com/api/v1/hello") do
      {:ok, %{body: %{"userName" => username, "time" => time}}} ->
        Logger.info("Validated #{username} at #{time}")

        {:ok, %{username: username, time: time}}

      {:error, error} ->
        IO.puts("Error validating: #{inspect(error)}")
    end
  end

  defp credentials do
    username = System.get_env("KAGGLE_USERNAME")
    key = System.get_env("KAGGLE_KEY")

    if username && key do
      %{username: username, key: key}
    else
      read_credentials_from_file()
    end
  end

  defp read_credentials_from_file do
    @kaggle_config
    |> File.read!()
    |> JSON.decode!()
    |> then(fn %{"username" => username, "key" => key} ->
      %{username: username, key: key}
    end)
  end
end

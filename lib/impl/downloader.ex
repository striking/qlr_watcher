defmodule QlrWatcher.Impl.Downloader do

@base "https://www.queenslandreports.com.au"
@url "/qlr/db-qlr-editions"
  def download_new_pdf() do
    @base <> @url
    |> get_html_from_page
    |> parse_html  
    |> get_latest_report_link
    |> download_if_new_file

    :timer.sleep(43200)

    download_new_pdf()
  end

  def download_if_new_file(url) do
    {:ok, file_list} = File.ls("priv/")
    file_name = String.slice(url, 11, 11)

    if file_name not in file_list do
      download_pdf(file_name, url)
    else
      IO.puts "#{file_name} has already been processed"
    end

  end

  def download_pdf(file_name, url) do
    write_pdf(HTTPoison.get!(@base <> url), file_name)
    IO.puts "#{file_name} has been donwloaded"
  end

  def write_pdf(%HTTPoison.Response{body: body}, file_name) do
    File.write("priv/#{file_name}", body)
    file_path = Path.expand("priv/#{file_name}")
    file_path
  end

  def write_pdf(error), do: error

  def get_html_from_page(url) do
    HTTPoison.get(url)
  end

  def parse_html({:ok, response}) do
    Floki.parse_document(response.body)
  end

  def parse_html(error), do: error

  def get_latest_report_link({:ok, html}) do
    html
    |> Floki.attribute(".latest-QLR-link", "href")
    |> List.first
  end

  def get_latest_report_link(error), do: error

  def url(), do: @base <> @url
end

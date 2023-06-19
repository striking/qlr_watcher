defmodule QlrWatcher.Server do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def download_new_file() do
    GenServer.call(__MODULE__, :download_new_file)
  end
  
  def init(_) do
    {:ok, nil}
  end

  def handle_call(:download_new_file, _from, _state) do
    QlrWatcher.Impl.Downloader.download_new_pdf()
    
    {:reply, :ok, nil}
  end

  def handle_cast({:download_file, file_path}, state) do
    QlrWatcher.Impl.Downloader.download_new_pdf()
    {:noreply, state}
  end

  def handle_info(_message, state) do
    {:noreply, state}
  end
end

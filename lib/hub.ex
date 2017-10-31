defmodule Hub do
  HTTPoison.start
  @username "chrismccord"

  {:ok, %{body: body}} = "https://api.github.com/users/#{@username}/repos"
  |> HTTPoison.get([{"User-Agent", "Elixir"}])
  
  body
  |> Poison.decode!
  |> Enum.each(fn repo ->
    def unquote(String.to_atom(repo["name"]))() do
      unquote(Macro.escape(repo))
    end
  end)

  def go(repo) do
    url = apply(__MODULE__, repo, [])["html_url"]
    IO.puts "Lauching browser to #{url}..."
    System.cmd("xdg-open", [url])
  end
end

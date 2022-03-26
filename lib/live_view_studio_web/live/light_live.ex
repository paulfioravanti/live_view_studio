defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :brightness, 10)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%"}>
          <%= @brightness %>%
        </span>
      </div>
    </div>
    """
  end
end

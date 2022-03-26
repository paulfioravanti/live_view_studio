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
    <%= @brightness %>
    """
  end
end

defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  @default_brightness 10
  @brightness_unit 10
  @min_brightness 0
  @max_brightness 100

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, :brightness, @default_brightness)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <.meter brightness={@brightness} />
      <.light_button event="off" image="light-off" />
      <.light_button event="down" image="down" />
      <.light_button event="up" image="up" />
      <.light_button event="on" image="light-on" />
      <.light_me_up_button />
    </div>
    """
  end

  defp meter(assigns) do
    ~H"""
    <div class="meter">
      <span style={"width: #{@brightness}%"}>
        <%= @brightness %>%
      </span>
    </div>
    """
  end

  defp light_button(assigns) do
    ~H"""
    <button phx-click={@event}>
      <img src={"images/#{@image}.svg"}>
    </button>
    """
  end

  defp light_me_up_button(assigns) do
    ~H"""
    <div class="light-me-up">
      <button phx-click="random">
        Light me up!
      </button>
    </div>
    """
  end

  @impl true
  def handle_event("on", _unsigned_params, socket) do
    socket = assign(socket, :brightness, @max_brightness)
    {:noreply, socket}
  end

  @impl true
  def handle_event("up", _unsigned_params, socket) do
    socket =
      update(socket, :brightness, &min(&1 + @brightness_unit, @max_brightness))

    {:noreply, socket}
  end

  @impl true
  def handle_event("down", _unsigned_params, socket) do
    socket =
      update(socket, :brightness, &max(&1 - @brightness_unit, @min_brightness))

    {:noreply, socket}
  end

  @impl true
  def handle_event("off", _unsigned_params, socket) do
    socket = assign(socket, :brightness, @min_brightness)
    {:noreply, socket}
  end

  @impl true
  def handle_event("random", _unsigned_params, socket) do
    socket = assign(socket, :brightness, Enum.random(1..100))
    {:noreply, socket}
  end
end

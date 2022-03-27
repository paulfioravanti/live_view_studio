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
      <div class="meter">
        <span style={"width: #{@brightness}%"}>
          <%= @brightness %>%
        </span>
      </div>
      <button phx-click="off">
        <img src="images/light-off.svg">
      </button>
      <button phx-click="down">
        <img src="images/down.svg">
      </button>
      <button phx-click="up">
        <img src="images/up.svg">
      </button>
      <button phx-click="on">
        <img src="images/light-on.svg">
      </button>
      <div class="light-me-up">
        <button phx-click="random">
          Light me up!
        </button>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("on", _params, socket) do
    socket = assign(socket, :brightness, @max_brightness)
    {:noreply, socket}
  end

  @impl true
  def handle_event("up", _params, socket) do
    socket =
      update(socket, :brightness, &min(&1 + @brightness_unit, @max_brightness))

    {:noreply, socket}
  end

  @impl true
  def handle_event("down", _params, socket) do
    socket =
      update(socket, :brightness, &max(&1 - @brightness_unit, @min_brightness))

    {:noreply, socket}
  end

  @impl true
  def handle_event("off", _params, socket) do
    socket = assign(socket, :brightness, @min_brightness)
    {:noreply, socket}
  end

  @impl true
  def handle_event("random", _unsigned_params, socket) do
    socket = assign(socket, :brightness, Enum.random(1..100))
    {:noreply, socket}
  end
end

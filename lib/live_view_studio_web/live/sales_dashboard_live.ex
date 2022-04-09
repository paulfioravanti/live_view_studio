defmodule LiveViewStudioWeb.SalesDashboardLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Sales

  @one_second 1000
  @refresh_rate_options [
    {"1s", 1},
    {"5s", 5},
    {"15s", 15},
    {"30s", 30},
    {"60s", 60}
  ]
  @time_format "%H:%M:%S"
  @time_zone "Australia/Sydney"

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_stats()
      |> assign(refresh_rate: 1, last_updated_at: Timex.now(@time_zone))

    if connected?(socket), do: schedule_refresh(socket)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Sales Dashboard</h1>
    <div id="dashboard">
      <div class="stats">
        <.stat value={@new_orders} name="New Orders" />
        <.stat value={@sales_amount} name="Sales Orders" prefix="$" />
        <.stat value={@satisfaction} name="Satisfaction" suffix="%" />
      </div>
      <.controls refresh_rate={@refresh_rate} />
      <div class="last-updated">
        Last updated at: <%= format_time(@last_updated_at) %>
      </div>
    </div>
    """
  end

  defp stat(assigns) do
    assigns =
      assigns
      |> assign_new(:prefix, fn -> "" end)
      |> assign_new(:suffix, fn -> "" end)

    ~H"""
    <div class="stat">
      <span class="value">
      <%= @prefix %><%= @value %><%= @suffix %>
      </span>
      <span class="name">
        <%= @name %>
      </span>
    </div>
    """
  end

  defp controls(assigns) do
    ~H"""
    <div class="controls">
      <.form
        let={f}
        for={:refresh}
        phx-change="select-refresh-rate"
        phx-submit="refresh"
      >
        <%= label f, :rate, "Refresh every:" %>
        <%= select f, :rate, refresh_rate_options(), selected: @refresh_rate %>
        <%= submit do %>
          <%= img_tag "images/refresh.svg" %>
          Refresh
        <% end %>
      </.form>
    </div>
    """
  end

  defp refresh_rate_options, do: @refresh_rate_options

  @impl true
  def handle_event("refresh", _unsigned_params, socket) do
    socket =
      socket
      |> assign_stats()
      |> assign(last_updated_at: Timex.now(@time_zone))

    {:noreply, socket}
  end

  @impl true
  def handle_event("select-refresh-rate", params, socket) do
    %{"refresh" => %{"rate" => rate}} = params
    refresh_rate = String.to_integer(rate)
    socket = assign(socket, refresh_rate: refresh_rate)
    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    socket =
      socket
      |> assign_stats()
      |> assign(last_updated_at: Timex.now(@time_zone))

    schedule_refresh(socket)
    {:noreply, socket}
  end

  defp schedule_refresh(%{assigns: %{refresh_rate: refresh_rate}}) do
    Process.send_after(self(), :tick, refresh_rate * @one_second)
  end

  defp assign_stats(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
  end

  defp format_time(time), do: Timex.format!(time, @time_format, :strftime)
end

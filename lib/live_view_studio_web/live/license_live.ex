defmodule LiveViewStudioWeb.LicenseLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Licenses
  import Number.Currency, only: [number_to_currency: 1]

  @initial_seats 2
  @min_seats 1
  @max_seats 10
  @one_second 1000

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(@one_second, self(), :tick)

    expiration_time = Timex.shift(Timex.now(), hours: 1)

    socket =
      assign(socket,
        seats: @initial_seats,
        amount: Licenses.calculate(@initial_seats),
        expiration_time: expiration_time,
        time_remaining: time_remaining(expiration_time)
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Team License</h1>
    <div id="license">
      <div class="card">
        <div class="content">
          <.heading seats={@seats} />
          <.slider seats={@seats} />
          <div class="amount">
            <%= number_to_currency(@amount) %>
          </div>
          <.countdown time_remaining={@time_remaining} />
        </div>
      </div>
    </div>
    """
  end

  defp heading(assigns) do
    ~H"""
    <div class="seats">
      <img src="images/license.svg" />
      <span>
        Your license is currently good for
        <strong><%= @seats %></strong>
        <%= ngettext("seat", "seats", @seats) %>
      </span>
    </div>
    """
  end

  defp slider(assigns) do
    ~H"""
    <.form let={f} for={:licenses} phx-change="update">
      <%= text_input f, :seats,
        type: "range",
        value: @seats,
        min: min_seats(),
        max: max_seats() %>
    </.form>
    """
  end

  defp countdown(assigns) do
    ~H"""
    <p class="m-4 font-semibold text-indigo-800">
      <%= if @time_remaining > 0 do %>
        <%= format_time(@time_remaining) %> left to save 20%
      <% else %>
        Expired!
      <% end %>
    </p>
    """
  end

  defp min_seats, do: @min_seats
  defp max_seats, do: @max_seats

  @impl true
  def handle_event("update", %{"licenses" => %{"seats" => seats}}, socket) do
    seats = String.to_integer(seats)
    socket = assign(socket, seats: seats, amount: Licenses.calculate(seats))

    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    time_remaining = time_remaining(socket.assigns.expiration_time)
    socket = assign(socket, time_remaining: time_remaining)
    {:noreply, socket}
  end

  defp time_remaining(expiration_time) do
    DateTime.diff(expiration_time, Timex.now())
  end

  defp format_time(time) do
    time
    |> Timex.Duration.from_seconds()
    |> Timex.format_duration(:humanized)
  end
end

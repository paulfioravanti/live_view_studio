defmodule LiveViewStudioWeb.LicenseLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Licenses
  import Number.Currency, only: [number_to_currency: 1]

  @initial_seats 2
  @min_seats 1
  @max_seats 10

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        seats: @initial_seats,
        amount: Licenses.calculate(@initial_seats)
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
        </div>
      </div>
    </div>
    """
  end

  defp min_seats(), do: @min_seats
  defp max_seats(), do: @max_seats

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

  @impl true
  def handle_event("update", %{"licenses" => %{"seats" => seats}}, socket) do
    seats = String.to_integer(seats)
    socket = assign(socket, seats: seats, amount: Licenses.calculate(seats))

    {:noreply, socket}
  end
end

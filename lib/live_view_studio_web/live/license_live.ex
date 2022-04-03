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
        min_seats: @min_seats,
        max_seats: @max_seats,
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
          <div class="seats">
            <img src="images/license.svg" />
            <span>
              Your license is currently good for
              <strong><%= @seats %></strong>
              <%= ngettext("seat", "seats", @seats) %>
            </span>
          </div>
          <form phx-change="update">
            <input type="range"
                   min={@min_seats}
                   max={@max_seats}
                   name="seats"
                   value={@seats} />
          </form>
          <div class="amount">
            <%= number_to_currency(@amount) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("update", %{"seats" => seats}, socket) do
    seats = String.to_integer(seats)

    socket =
      assign(socket,
        seats: seats,
        amount: Licenses.calculate(seats)
      )

    {:noreply, socket}
  end
end

defmodule LiveViewStudioWeb.LicenseLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Licenses

  @initial_seats 2

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
          <div class="seats">
            <img src="images/license.svg" />
            <span>
              Your license is currently good for
              <strong><%= @seats %></strong> seats.
            </span>
          </div>
          <form>
            <input type="range" min="1" max="10" name="seats" value={@seats} />
          </form>
          <div class="amount">
            <%= @amount %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end

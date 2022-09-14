defmodule B2Web.Live.Game.WordsSoFar do
  use B2Web, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>In WordsSoFar</div>
    """
  end
end

defmodule Doom.GroupView do
  use Doom.Web, :view

  def render("create.json", %{group: group}) do
    %{success: true, data: render_one(group, Doom.GroupView, "group.json")}
  end

  def render("group.json", %{group: group}) do
    %{id: group.id, name: group.name}
  end
end

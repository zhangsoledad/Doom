defmodule Doom.TemplateTest do
  use Doom.ModelCase

  alias Doom.Template

  @valid_attrs %{"expect"=> "{\"show\":1}", "name"=> "some content", "params"=> nil, "url" => "some content" ,"method"=> "get", "type"=> "json"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Template.save_changeset(%Template{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Template.save_changeset(%Template{}, @invalid_attrs)
    refute changeset.valid?
  end
end

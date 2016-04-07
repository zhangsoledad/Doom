defmodule Doom.ViewHelpers do
  use Phoenix.HTML

  def side_nav_tag(conn, view) do
    info = conn.private
    case info[:phoenix_view] == view do
      true ->
        tag(:li, class: "treeview active")
      _ ->
        tag(:li, class: "treeview")
    end
  end

  def side_li_tag(conn, view, action) do
    info = conn.private
    case (info[:phoenix_view] == view) && (info[:phoenix_action] == action) do
      true ->
        tag(:li, class: "active")
      _ ->
        tag(:li)
    end
  end

  def avatar_url(user_name) do
    name = Pinyin.from_string(user_name, splitter: "")
    filename = AlchemicAvatar.generate(name, 150)
    filename |> String.replace("priv/static", "")
  end

  def pagination(paginator, path_fun, params) do
    current_page = paginator.page_number
    total_pages = paginator.total_pages

    if total_pages > 1 do
      content_tag :ul, class: "pagination pagination-sm no-margin" do
        page_tags = [raw_page_link(1, current_page, path_fun, params) | inside_window_page_link(total_pages,current_page, path_fun, params)]
        if current_page > 1 do
          page_tags = [page_link(path_fun, params, current_page - 1, "«") | page_tags]
        end
        if current_page < total_pages do
          page_tags = [page_tags | page_link(path_fun, params, current_page + 1, "»")]
        end
        page_tags
      end
    end
  end

  defp page_link(path_fun, params, page) do
    content_tag :li do
      link "#{page}", to: path_fun.( Map.merge(params, %{ "page" => page}))
    end
  end

  defp page_link(path_fun, params, page, :active) do
    content_tag :li, class: "active" do
      link "#{page}", to: path_fun.( Map.merge(params, %{ "page" => page}))
    end
  end

  defp page_link(path_fun, params, page, text) do
    content_tag :li do
      link "#{text}", to: path_fun.( Map.merge(params, %{ "page" => page}))
    end
  end

  def inside_window_page_link(total_pages, current_page, path_fun, params) do
    left_out = (current_page > 4) && (total_pages > 6)
    right_out = total_pages > (current_page + 3)
    start = case left_out do
      true -> current_page - 2
      _ -> 2
    end

    endp = case (start + 4) > total_pages do
      true -> total_pages
      _ -> start + 4
    end

    tags = Enum.map(start..endp, &raw_page_link(&1,current_page, path_fun, params))
    case {left_out,right_out} do
      {true, true} -> [[gap_page_link | tags] | gap_page_link ]
      {true, false} -> [gap_page_link | tags]
      {false, true} -> [ tags | gap_page_link]
      _ -> tags
    end
  end


  defp gap_page_link do
    content_tag :li do
      content_tag :span, class: "disable" do
        "..."
      end
    end
  end

  defp raw_page_link(page, current_page, path_fun, params) do
    case current_page == page do
      true -> page_link(path_fun, params, page, :active)
      _ -> page_link(path_fun, params, page)
    end
  end
end

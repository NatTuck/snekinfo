defmodule SnekinfoWeb.FeedControllerTest do
  use SnekinfoWeb.ConnCase

  import Snekinfo.FeedsFixtures

  @create_attrs %{ingested?: true, live?: true, timestamp: ~U[2021-10-20 23:44:00Z], weight: 120.5}
  @update_attrs %{ingested?: false, live?: false, timestamp: ~U[2021-10-21 23:44:00Z], weight: 456.7}
  @invalid_attrs %{ingested?: nil, live?: nil, timestamp: nil, weight: nil}

  describe "index" do
    test "lists all feeds", %{conn: conn} do
      conn = get(conn, Routes.feed_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Feeds"
    end
  end

  describe "new feed" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.feed_path(conn, :new))
      assert html_response(conn, 200) =~ "New Feed"
    end
  end

  describe "create feed" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.feed_path(conn, :create), feed: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.feed_path(conn, :show, id)

      conn = get(conn, Routes.feed_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Feed"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.feed_path(conn, :create), feed: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Feed"
    end
  end

  describe "edit feed" do
    setup [:create_feed]

    test "renders form for editing chosen feed", %{conn: conn, feed: feed} do
      conn = get(conn, Routes.feed_path(conn, :edit, feed))
      assert html_response(conn, 200) =~ "Edit Feed"
    end
  end

  describe "update feed" do
    setup [:create_feed]

    test "redirects when data is valid", %{conn: conn, feed: feed} do
      conn = put(conn, Routes.feed_path(conn, :update, feed), feed: @update_attrs)
      assert redirected_to(conn) == Routes.feed_path(conn, :show, feed)

      conn = get(conn, Routes.feed_path(conn, :show, feed))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, feed: feed} do
      conn = put(conn, Routes.feed_path(conn, :update, feed), feed: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Feed"
    end
  end

  describe "delete feed" do
    setup [:create_feed]

    test "deletes chosen feed", %{conn: conn, feed: feed} do
      conn = delete(conn, Routes.feed_path(conn, :delete, feed))
      assert redirected_to(conn) == Routes.feed_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.feed_path(conn, :show, feed))
      end
    end
  end

  defp create_feed(_) do
    feed = feed_fixture()
    %{feed: feed}
  end
end

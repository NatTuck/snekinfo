defmodule SnekinfoWeb.SnakeController do
  use SnekinfoWeb, :controller

  alias Snekinfo.Snakes
  alias Snekinfo.Snakes.Snake
  alias Snekinfo.Feeds
  alias Snekinfo.Weights
  alias Snekinfo.Litters
  alias Snekinfo.Traits

  def index(conn, _params) do
    snakes = Snakes.list_snakes()
    render(conn, "index.html", snakes: snakes)
  end

  def new(conn, params) do
    litters = [nil | Litters.list_litters()]
    traits = Traits.list_traits()
    snake0 = %Snake{traits: [], litter_id: params["litter_id"]}
    changeset = Snakes.change_snake(snake0)
    render(conn, "new.html", changeset: changeset, litters: litters,
      traits: traits, snake_traits: [])
  end

  def create(conn, %{"snake" => snake_params}) do
    snake_params = load_traits(snake_params)
    case Snakes.create_snake(snake_params) do
      {:ok, snake} ->
        conn
        |> put_flash(:info, "Snake created successfully.")
        |> redirect(to: Routes.snake_path(conn, :show, snake))

      {:error, %Ecto.Changeset{} = changeset} ->
        litters = [nil | Litters.list_litters()]
        traits = Traits.list_traits()
        render(conn, "new.html", changeset: changeset,
          litters: litters, traits: traits, snake_traits: [])
    end
  end

  def show(conn, %{"id" => id}) do
    snake = Snakes.get_snake!(id)
    recent_feeds = Feeds.list_recent_feeds_for_snake(snake, 10)
    recent_weights = Weights.list_recent_weights_for_snake(snake, 10)
    render(conn, "show.html", snake: snake,
      recent_feeds: recent_feeds, recent_weights: recent_weights)
  end

  def edit(conn, %{"id" => id}) do
    litters = [nil | Litters.list_litters()]
    traits = Traits.list_traits()
    snake = Snakes.get_snake!(id)
    changeset = Snakes.change_snake(snake)
    render(conn, "edit.html", snake: snake, changeset: changeset,
      litters: litters, traits: traits, snake_traits: snake.traits)
  end

  def update(conn, %{"id" => id, "snake" => snake_params}) do
    snake = Snakes.get_snake!(id)
    snake_params = load_traits(snake_params)

    case Snakes.update_snake(snake, snake_params) do
      {:ok, snake} ->
        conn
        |> put_flash(:info, "Snake updated successfully.")
        |> redirect(to: Routes.snake_path(conn, :show, snake))

      {:error, %Ecto.Changeset{} = changeset} ->
        litters = [nil | Litters.list_litters()]
        traits = Traits.list_traits()
        render(conn, "edit.html", snake: snake, changeset: changeset,
          litters: litters, traits: traits, snake_traits: snake.traits)
    end
  end

  def delete(conn, %{"id" => id}) do
    snake = Snakes.get_snake!(id)
    {:ok, _snake} = Snakes.delete_snake(snake)

    conn
    |> put_flash(:info, "Snake deleted successfully.")
    |> redirect(to: Routes.snake_path(conn, :index))
  end

  def load_traits(params) do
    xs = params["traits"] || []
    ys = Enum.map xs, fn id ->
      Traits.get_trait!(id)
    end
    Map.put(params, "traits", ys)
  end
end

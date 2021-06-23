defmodule RumblWeb.VideoController do
  use RumblWeb, :controller

  alias Rumbl.Multimedia
  alias Rumbl.Multimedia.Video

  plug :load_categories when action in [:new, :create, :edit, :update]

  defp load_categories(conn, _) do
    assign(conn, :categories, Multimedia.list_alphabetical_categories())
  end
  def index(conn, _params, current_user) do
    videos = Multimedia.list_videos(current_user)
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params, _current_user) do
    changeset = Multimedia.change_video(%Video{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}, current_user) do
    case Multimedia.create_video(current_user, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: Routes.video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user) do
    video = Multimedia.get_video!(id)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}, _current_user) do
    video = Multimedia.get_video!(id)
    changeset = Multimedia.change_video(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, _current_user) do
    video = Multimedia.get_video!(id)

    case Multimedia.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: Routes.video_path(conn, :show, video))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user) do
    video = Multimedia.get_video!(id)
    {:ok, _video} = Multimedia.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: Routes.video_path(conn, :index))
  end

  def action(conn, _) do
    args = [ conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end
end

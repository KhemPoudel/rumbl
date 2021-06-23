defmodule Rumbl.MultimediaTest do
  use Rumbl.DataCase, async: true
  alias Rumbl.Multimedia
  alias Rumbl.Multimedia.Category
  import Rumbl.TestHelpers

  describe "categories" do
    test "list_alphabetical_categories/0" do
      for name <- ~w(Drama Action Comedy) do
        Multimedia.create_category!(name)
      end

      alpha_categories =
        for %Category{ name: name } <- Multimedia.list_alphabetical_categories() do
          name
        end

      assert alpha_categories == ~w(Action Comedy Drama)
    end
  end

  describe "videos" do
    alias Rumbl.Multimedia.Video

    @valid_attrs %{ description: "desc", title: "title", url: "http://local"}
    @invalid_attrs %{ description: nil, title: nil, url: nil }

    test "list_videos/1 returns all videos" do
      owner = user_fixture()

      %Video{ id: id1 } = video_fixture(owner)

      assert [ %Video{ id: ^id1 } ] = Multimedia.list_videos(owner)

      %Video{ id: id2 } = video_fixture(owner)

      assert [ %Video{ id: ^id1 }, %Video{ id: ^id2 }] = Multimedia.list_videos(owner)
    end

    test "get_video/2 returns the video with given id and the owner" do
      owner = user_fixture()

      %Video{ id: id } = video_fixture(owner)

      assert %Video{ id: ^id } = Multimedia.get_video!(owner, id)
    end

    test "create_video/2 with valid data creates video" do
      owner = user_fixture()

      assert { :ok, %Video{} = video } = Multimedia.create_video(owner, @valid_attrs)

      assert video.title == "title"

      assert video.description == "desc"

      assert video.url == "http://local"
    end

    test "create_video/2 with invalid data returns error changeset" do
      owner = user_fixture()

      assert { :error, %Ecto.Changeset{} } =
        Multimedia.create_video(owner, @invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      owner = user_fixture()

      video = video_fixture(owner)

      assert { :ok, video } =
        Multimedia.update_video(video, %{ title: "updated title" })

      assert %Video{} = video

      assert video.title == "updated title"
    end

    test "update_video/2 with invalid data return error changeset" do
      owner = user_fixture()

      %Video{ id: id } = video = video_fixture(owner)

      assert { :error, %Ecto.Changeset{} } =
        Multimedia.update_video(video, @invalid_attrs)

      assert %Video{ id: ^id } = Multimedia.get_video!(owner, id)
    end

    test "delete_video/1 deletes the video" do
      owner = user_fixture()

      video = video_fixture(owner)

      assert { :ok, video } =
        Multimedia.delete_video(video)

      assert [] == Multimedia.list_videos(owner)
    end

    test "change_video/1 returns the video changeset" do
      owner = user_fixture()

      video = video_fixture(owner)

      assert %Ecto.Changeset{} = Multimedia.change_video(video)
    end
  end
end

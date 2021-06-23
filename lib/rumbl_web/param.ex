defimpl Phoenix.Param, for: Rumbl.Multimedia.Video do
  def to_param(%{ id: id, slug: slug }) do
    "#{id}-#{slug}"
  end
end

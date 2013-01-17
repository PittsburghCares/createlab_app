module EventsHelper
  def human_readable_status(status)
    return "Published" if status
    return "Draft"
  end
end

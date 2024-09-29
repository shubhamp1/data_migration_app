module MigrationHistoriesHelper

  def format_date_time(data)
    data.strftime('%b %d %Y, %H:%m')
  end
end

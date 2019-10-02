class BackupsProcessorService

  def run

    for key in ['pages', 'courses'] do

      service_name = (key.capitalize + 'Service').constantize

      service = service_name.new(STORYBLOK_CLIENT)

      data = service.get_all

      Backup.find_or_initialize_by(key: key).update!(
        data: data
      )
    end

  end

end

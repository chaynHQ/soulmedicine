class BackupsProcessorService
  def run
    %w[pages courses].each do |key|
      service_name = (key.capitalize + 'Service').constantize

      service = service_name.new(STORYBLOK_CLIENT)

      data = service.all

      Backup.find_or_initialize_by(key: key).update!(
        data: data
      )
    end
  end
end

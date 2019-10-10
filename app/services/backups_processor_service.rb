class BackupsProcessorService
  def run
    %w[pages courses].each do |key|
      service_name = (key.capitalize + 'Service').constantize

      service = service_name.new(STORYBLOK_CLIENT)

      data = service.all

      Rails.logger.info "Creating backup of #{key.to_s} data from storyblok."

      Backup.find_or_initialize_by(key: key).update!(
        data: data
      )
    end
  end
end

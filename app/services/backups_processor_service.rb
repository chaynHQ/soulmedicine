class BackupsProcessorService
  def run
    %w[pages courses].each do |key|
      service_name = (key.capitalize + 'Service').constantize

      service = service_name.new(STORYBLOK_CLIENT)

      data = service.all

      puts 'Data with key: ' + key.to_s + ' has ' + data['data']['stories'][0].keys.length.to_s + ' keys per story.'

      Backup.find_or_initialize_by(key: key).update!(
        data: data
      )
    end
  end
end

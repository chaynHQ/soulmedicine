module SettingsHelper
  RSpec.shared_context 'settings helper' do
    let :settings do
      Settings.new(
        disguised_subject_lines: %w[foo bar],
        courses_bg_image: nil,
        announcement_banner: nil
      )
    end

    before :example do
      allow_any_instance_of(SettingsService).to receive(:get)
        .and_return(settings)
    end
  end
end

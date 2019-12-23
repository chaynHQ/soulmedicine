module CoursesServiceDouble
  RSpec.shared_context 'courses_service double' do
    let(:courses_service) { instance_double('CoursesService') }

    before do
      allow(CoursesService).to receive(:new)
        .and_return(courses_service)
    end
  end
end

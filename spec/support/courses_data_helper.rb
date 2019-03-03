module CoursesDataHelper
  RSpec.shared_context 'courses data helper' do
    def load_json(filename)
      JSON.parse file_fixture(filename).read
    end

    def load_course(filename, index: 0)
      json = load_json filename
      course_hash = if json.key?('stories')
                      json['stories'][index]
                    else
                      json['story']
                    end
      mapped = CourseMapper.map_from course_hash
      Course.new mapped
    end
  end
end

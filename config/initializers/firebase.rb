FirebaseConfig = OpenStruct.new

FirebaseConfig.api_key = ENV.fetch('FIREBASE_API_KEY') { raise 'FIREBASE_API_KEY missing' }
FirebaseConfig.project_id = ENV.fetch('FIREBASE_PROJECT_ID') { raise 'FIREBASE_PROJECT_ID missing' }

FirebaseConfig.freeze

class UserSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :firebase_id,
    :display_name,
    :email,
    :email_verified,
    :terms_accepted
  )
end

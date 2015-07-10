ActionController::Renderers.add :s3 do |obj, _options|
  s3_object = obj
  content_type = s3_object.content_type

  response.headers['Content-Type'] ||= content_type

  self.response_body = Enumerator.new do |y|
    y << s3_object.body.read
  end
end

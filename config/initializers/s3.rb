module Docrystal
  def self.s3
    @s3 ||= Aws::S3::Client.new(
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_REGION'] || 'ap-northeast-1',
      endpoint: ENV['AWS_S3_ENDPOINT'],
      force_path_style: true
    )
  end
end

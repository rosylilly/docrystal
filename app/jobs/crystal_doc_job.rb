require 'open3'

class CrystalDocJob < ActiveJob::Base
  include Sidekiq::Worker

  queue_as :default

  def perform(doc_id)
    @doc = Package::Doc.find_by(id: doc_id)

    FileUtils.mkdir_p(working_dir)

    git('clone', @doc.package.github_repository.git_url, working_dir)

    Dir.chdir(working_dir) do
      git('checkout', @doc.sha)

      FileUtils.rm_rf(working_dir.join('doc'))

      crystal('docs')

      Dir['doc/**/*'].each do |file|
        next if File.directory?(file)

        path = file.sub(%r{^doc/}, '')
        logger.info(path)

        open(file) do |f|
          @doc.save_doc_file(path, f)
        end
      end
    end

    @doc.touch(:generated_at)
    Pusher["doc-#{@doc.sha}"].trigger('generated', {})
  ensure
    if @doc && File.directory?(working_dir)
      FileUtils.rm_rf(working_dir)
    end
  end

  def working_dir
    @working_dir ||= Rails.root.join('tmp', 'crystal-doc', Digest::SHA1.hexdigest("#{@doc.id}-#{Time.current.to_i}"))
  end

  def git(cmd, *args)
    Open3.popen3("git #{cmd} #{args.join(' ')}") do |input, stdout, stderr, wait|
      input.close

      stdout.each do |line|
        logger.info(line)
      end

      stderr.each do |line|
        logger.error(line)
      end

      wait.value
    end
  end

  def crystal(cmd, *args)
    Open3.popen3("crystal #{cmd} #{args.join(' ')}") do |input, stdout, stderr, wait|
      input.close

      stdout.each do |line|
        logger.info(line)
      end

      stderr.each do |line|
        logger.error(line)
      end

      wait.value
    end
  end
end

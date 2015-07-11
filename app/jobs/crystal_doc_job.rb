require 'open3'

class CrystalDocJob < ActiveJob::Base
  include Sidekiq::Worker

  queue_as :default

  def perform(doc_id)
    @doc = Package::Doc.find_by(id: doc_id)

    return unless @doc

    logger.info(working_dir)
    FileUtils.mkdir_p(working_dir)

    git('clone', @doc.package.github_repository.git_url, working_dir)

    git('checkout', @doc.sha)

    FileUtils.rm_rf(working_dir.join('doc'))

    crystal('deps', 'install') if File.exist?(working_dir.join('Projectfile').to_s)
    crystal('docs')

    Dir[working_dir.join('doc/**/*')].each do |file|
      next if File.directory?(file)

      path = file.sub(%r{^#{Regexp.escape(working_dir.to_s)}/doc/}, '')
      logger.info(path)

      open(file) do |f|
        @doc.save_doc_file(path, f)
      end
    end

    @doc.touch(:generated_at)
    Pusher["doc-#{@doc.sha}"].trigger('generated', {}) if Pusher.key
  ensure
    FileUtils.rm_rf(working_dir) if @doc && File.directory?(working_dir)
  end

  def working_dir
    @working_dir ||= Rails.root.join('tmp', 'crystal-doc', Digest::SHA1.hexdigest("#{@doc.id}-#{Time.current.to_f}"))
  end

  def git(cmd, *args)
    Open3.popen3("git #{cmd} #{args.join(' ')}", chdir: working_dir) do |input, stdout, stderr, wait|
      input.close

      stdout.each do |line|
        logger.info(line)
      end

      stderr.each do |line|
        logger.warn(line)
      end

      wait.value
    end
  end

  def crystal(cmd, *args)
    Open3.popen3("crystal #{cmd} #{args.join(' ')}", chdir: working_dir) do |input, stdout, stderr, wait|
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

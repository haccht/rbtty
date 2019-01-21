namespace :gotty do
  desc 'setup'
  task :setup => :environment do |task, args|
    sh "wget https://github.com/yudai/gotty/releases/download/v2.0.0-alpha.3/gotty_2.0.0-alpha.3_linux_amd64.tar.gz"
    sh "tar xvzf gotty_2.0.0-alpha.3_linux_amd64.tar.gz -C #{File.join(Rails.root, 'bin', 'gotty')}"
    sh "rm -f gotty_2.0.0-alpha.3_linux_amd64.tar.gz"
  end

  desc 'start'
  task :start => :environment do |task, args|
    binfile = File.join(Rails.root, 'bin', 'gotty')
    sh "#{binfile} -w --permit-arguments --title-format rbtty-term #{ENV['GOTTY_EXTRA_ARGS']} bin/task_runner"
  end

  desc 'invoke'
  task :invoke, [:uuid] => :environment do |task, args|
    next unless command = Command.find_by(uuid: args[:uuid])

    begin
      command.accessed_at = Time.now
      command.save

      username = ENV['GOTTY_USER'] || ENV['USER']
      sh "sudo -u #{username} -i #{command.text}", verbose: false
    rescue Interrupt
      puts "Connection Closed"
    rescue
    end
  end
end

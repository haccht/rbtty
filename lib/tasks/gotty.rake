namespace :gotty do
  desc 'setup'
  task :setup => :environment do |task, args|
    sh "wget -O - https://github.com/yudai/gotty/releases/download/v2.0.0-alpha.3/gotty_2.0.0-alpha.3_linux_amd64.tar.gz | tar xvzf - -C #{File.join(Rails.root, 'bin')}"
  end

  desc 'start'
  task :start => :environment do |task, args|
    binfile = File.join(Rails.root, 'bin', 'gotty')
    pidfile = File.join(Rails.root, 'tmp', 'pids', 'gotty.pid')

    Signal.trap(:SIGTERM) do
      sh "kill -9 $(cat #{pidfile}) && rm -f ${pidfile}"
      exit 0
    end

    sh "#{binfile} -w --permit-arguments #{ENV['GOTTY_EXTRA_ARGS']} bin/task_runner & echo $! > #{pidfile}"
    sleep 1 while File.exist?(pidfile)
  end

  desc 'invoke'
  task :invoke, [:uuid] => :environment do |task, args|
    next unless command = Command.find_by(uuid: args[:uuid])

    begin
      command.accessed_at = Time.now
      command.save

      sh command.text, verbose: false
    rescue
    end
  end
end

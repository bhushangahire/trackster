# Watch the log analyser daemon

# Knowledge of deployment layout here....
RAILS_ENV = File.basename(File.expand_path("#{__FILE__}/../../../../.."))

God.watch do |w|
  w.name          = "trackster_log_analyser_#{env}"
  w.interval      = 5.seconds # default
  w.start         = "cd #{APP_DIR}/#{RAILS_ENV}/current; lib/daemons/log_analyser_ctl start"
  w.stop          = "cd #{APP_DIR}/#{RAILS_ENV}/current; lib/daemons/log_analyser_ctl stop"
  w.pid_file      = "#{APP_DIR}/#{RAILS_ENV}/current/log/log_analyser.rb.pid"
  w.start_grace   = 10.seconds
  w.stop_grace    = 20.seconds
  w.restart_grace = 20.seconds    

  # clean pid files before start if necessary
  w.behavior(:clean_pid_file)

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  
    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
    end
  end

  # start if process is not running
  #w.transition(:up, :start) do |on|
  #  on.condition(:process_exits)
  #end

  # restart if memory or cpu is too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.interval = 20
      c.above = 100.megabytes
      c.times = [3, 5]
      c.notify = 'developers'
    end
  
    on.condition(:cpu_usage) do |c|
      c.interval = 10
      c.above = 30.percent
      c.times = [3, 5]
      c.notify = 'developers'
    end
  end

  # lifecycle
  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
      c.notify = 'developers'
    end
  end
end


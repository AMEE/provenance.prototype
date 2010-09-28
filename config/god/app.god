RAILS_ROOT = File.dirname(File.dirname(File.dirname(__FILE__)))

God.contact(:email) do |c|
  c.name = 'james_h'
  c.group = 'developers'
  c.to_email = 'james.hetherington@amee.cc'
end

God.watch do |w|
    script = "provenance_daemon"

    w.name = "provenance"
    w.interval = 30.seconds
    w.start = "#{script} start --everything"
    w.stop = "#{script} stop"
    w.restart = "#{script} restart --everything"
    w.start_grace = 20.seconds
    w.restart_grace = 20.seconds
    w.stop_grace = 10.seconds
    w.pid_file = File.join("/home/jamesh/.provenance/provenance.pid")
    w.log = File.join("/home/jamesh/.provenance/provenance.log")
    w.behavior(:clean_pid_file)

    w.start_if do |start|
      start.condition(:process_running) do |c|
        c.notify = 'developers'
        c.interval = 5.seconds
        c.running = false
      end
    end

    w.restart_if do |restart|
      restart.condition(:memory_usage) do |c|
        c.notify = 'developers'
        c.above = 150.megabytes
        c.times = [3, 5] # 3 out of 5 intervals
      end
      restart.condition(:cpu_usage) do |c|
        c.notify = 'developers'
        c.above = 50.percent
        c.times = 5
      end
    end

    # lifecycle
    w.lifecycle do |on|
      on.condition(:flapping) do |c|
        c.notify = 'developers'
        c.to_state = [:start, :restart]
        c.times = 5
        c.within = 5.minute
        c.transition = :unmonitored
        c.retry_in = 10.minutes
        c.retry_times = 5
        c.retry_within = 2.hours
      end
    end

end
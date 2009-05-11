class TimerCommand
  
  def initialize(unit)
    @unit = unit
  end
  
  def help
    "/#{self.command} <interval as number> <command> - executes the given command after the specified interval"
  end
  
  def command
    :timer
  end
  
  def opmsg?
    false
  end
  
  # TODO: can we eliminate complete_target and target from the method signature?
  def execute(cmd_string, complete_target = true, target = nil, sel = nil)
    DebugTools.log_outbound_command(self.command, cmd_string, complete_target, target)

    interval = cmd_string.token!
    if interval =~ /^\d+$/
      @unit.add_timed_command( [interval.to_i, sel, cmd_string] )
    else
      @unit.print_both(@unit, :error_reply, self.help) 
    end
    return true
    
  end
  
end
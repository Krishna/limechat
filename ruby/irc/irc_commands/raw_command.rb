class RawCommand
  
  def initialize(unit, options = {})
    @unit = unit
    @command = options[:invoked_command] || :raws
  end
  
  def help
    "/#{self.command} <text to send> - sends the specified text 'raw'."
  end
  
  def command
    @command
  end
  
  def opmsg?
    false
  end
  
  # TODO: can we eliminate complete_target and target from the method signature?
  def execute(cmd_string, complete_target = true, target = nil, sel = nil)
    DebugTools.log_outbound_command(self.command, cmd_string, complete_target, target)

    @unit.send_raw(cmd_string.token!, cmd_string)
    return true    
  end
  
end
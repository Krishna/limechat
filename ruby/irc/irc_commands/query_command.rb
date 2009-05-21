class QueryCommand
  
  def initialize(unit)
    @unit = unit
  end
  
  def help
    "/#{self.command} <nick> - opens a new window and start a private chat."
  end
  
  def command
    :query
  end
  
  def opmsg?
    false
  end
  
  # TODO: can we eliminate complete_target and target from the method signature?
  def execute(cmd_string, complete_target = true, target = nil, sel = nil)
    #DebugTools.log_outbound_command(self.command, cmd_string, complete_target, target)

    target = cmd_string.token!
    if target.empty?
	    @unit.print_both(@unit, :error_reply, self.help) 
	    return true
	  end

    # open a new talk
    channel = @unit.find_channel(target)
    unless channel
      @unit.world.clear_text
      channel = @unit.world.create_talk(@unit, target)
    end
    @unit.world.select(channel)

    return true         
  end
  
end
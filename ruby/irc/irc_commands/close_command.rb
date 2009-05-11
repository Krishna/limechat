class CloseCommand
  
  def initialize(unit)
    @unit = unit
  end
  
  def help
    "/#{self.command} <chat channel> - closes the specified chat channel."
  end
  
  def command
    :close
  end
  
  def opmsg?
    false
  end
  
  # TODO: can we eliminate complete_target and target from the method signature?
  def execute(cmd_string, complete_target = true, target = nil, sel = nil)
    DebugTools.log_outbound_command(self.command, cmd_string, complete_target, target)

    target = cmd_string.token!
    channel = if target.empty?
                @unit.world.selchannel
              else
                @unit.find_channel(target)
              end
    
    if channel && channel.talk?
      @unit.world.destroy_channel(channel)
    end
    
    return true
  end
  
end
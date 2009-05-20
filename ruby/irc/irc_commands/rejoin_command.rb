class RejoinCommand
  
  def initialize(unit, options = {})
    @unit = unit
    @command = options[:invoked_command] || :rejoin
  end
  
  def help
    "/#{self.command} - leaves and rejoins the current chat channel."
  end
  
  def command
    @command
  end
  
  def opmsg?
    false
  end
  
  # TODO: can we eliminate complete_target and target from the method signature?
  def execute(cmd_string, complete_target = true, target = nil, sel = nil)
    #DebugTools.log_outbound_command(self.command, cmd_string, complete_target, target)

    channel = @unit.world.selchannel
    if channel
      pass = channel.mode.k
      pass = nil if pass.empty?
      @unit.part_channel(channel)
      @unit.join_channel(channel, pass, true)
    end
    return true
    
  end
  
end
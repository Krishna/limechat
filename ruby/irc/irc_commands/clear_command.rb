class ClearCommand
  
  def initialize(unit)
    @unit = unit
  end
  
  def help
    "/#{self.command} - clears the current window"
  end
  
  def command
    :clear
  end
  
  def opmsg?
    false
  end
  
  # TODO: can we eliminate complete_target and target from the method signature?
  def execute(cmd_string, complete_target = true, target = nil, sel = nil)
    #DebugTools.log_outbound_command(self.command, cmd_string, complete_target, target)

		u, c = @unit.world.sel
		if c
			c.log.clear
		elsif u
			u.log.clear
		end
		return true
             
  end
  
end
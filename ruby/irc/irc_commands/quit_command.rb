class QuitCommand

  def initialize(unit, options = {})
    @unit = unit
  end
  
  def help
    "/#{command_and_aliases} <comment> - disconnects from the server, using comment as a quit message"
  end
  
  def command_and_aliases
    c = "/#{command}"
    a = aliases.collect {|a| "/#{a}" }
    [c, a].join(' | ')
  end
  
  def aliases
    []
  end
  
  def command
    :quit
  end
  
  def opmsg?
    false
  end
    
  def cut_colon!(cmd_string)
    if cmd_string[0] == ?:
      cmd_string[0] = ''
      return true
    end
    return false
  end  
    
  
  # TODO: can we eliminate complete_target from the method signature?
  def execute(cmd_string, complete_target = true, target = nil, sel = nil)
    DebugTools.log_outbound_command(self.command, cmd_string, complete_target, target)

    cut_colon = cut_colon!(cmd_string)        

    @unit.quit(cmd_string)
    
    return true
  end  
  
  
  
end
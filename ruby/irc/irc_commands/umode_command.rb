#TODO: Get umode command to actually work
class UmodeCommand

  def initialize(unit, options = {})
     @unit = unit
  end
  
  def help
    "/#{command_and_aliases} <modes> - Not functioning correctly"
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
    :umode
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
        
  # TODO: can we eliminate complete_target and target from the method signature?
  def execute(cmd_string, complete_target = true, target = nil, sel = nil)
    DebugTools.log_outbound_command(self.command, cmd_string, complete_target, target)

    cmd_string = @unit.mynick      
    cut_colon = cut_colon!(cmd_string)        

    #printf("umode execute | cmd_string:%s | target: %s\n", cmd_string, target)

    @unit.send(:mode, target, cmd_string)

    return true

  end
  
  
end
=begin rdoc
Handles any unknown/unregonised commands.
=end
class UnknownCommand

  def initialize(unit, options = {})
    @unit = unit
    @command = options[:command]
  end
  
  def help
    ''
  end
    
  def command
    @command
  end
          
  # TODO: can we eliminate complete_target from the method signature?
  def execute(cmd_string, complete_target = true, target = nil, sel = nil)
    DebugTools.log_outbound_command(self.command, cmd_string, complete_target, target)

    @unit.send_raw(self.command, cmd_string)
    
    return true
  end  
  
end
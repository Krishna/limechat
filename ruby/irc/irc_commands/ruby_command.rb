class RubyCommand
  
  def initialize(unit)
    @unit = unit
  end
  
  def help
    "/#{self.command} - evaluates a Ruby expression and ouputs the result to the console and to the current channel"
  end
  
  def command
    :ruby
  end
  
  def opmsg?
    false
  end
  
  # TODO: can we eliminate complete_target and target from the method signature?
  def execute(cmd_string, complete_target = true, target = nil, sel = nil)
    DebugTools.log_outbound_command(self.command, cmd_string, complete_target, target)
             
    c = @unit.world.selchannel || @unit

    if cmd_string.empty?
      @unit.print_both(c, :error_reply, self.help)
      return true
    end

    begin
      result = eval(cmd_string).inspect
    rescue SyntaxError => e          
      @unit.send_text(c, :privmsg, "syntax error >> #{cmd_string}")
    rescue Exception => e
      @unit.send_text(c, :privmsg, "exception #{e} >> #{cmd_string}")
    else
      @unit.send_text(c, :privmsg, "=> #{result}")
    end
    
    return true    
  end
  
end
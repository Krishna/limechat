class CtcpCommand

  def initialize(unit, options = {})
    @unit = unit
  end
  
  def help
    "/#{command_and_aliases}  <request> <nick> - sends the CTCP <request> to the specified nick."
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
    :ctcp
  end
  
  def opmsg?
    false
  end
  
  def channel_is_selected?(sel)
    sel && sel.channel?
  end

  def talk_is_selected?(sel)
    sel && sel.talk?
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

    cmd = self.command

    # pull out the CTCP command (or subcommand)...
    t = cmd_string.dup
    subcmd = t.token!

    # special case: CTCP ACTION... just use an ActionCommand object...
    if subcmd.downcase == 'action'
      cmd_string = t

      action_command = ActionCommand.new(@unit)
      return action_command.execute(cmd_string, complete_target, target, sel)
    end

    # action the CTCP command...
    subcmd = cmd_string.token!
    unless subcmd.empty?
      target = cmd_string.token!            
      if subcmd.downcase == 'ping'
        @unit.send_ctcp_ping(target)
      else
        @unit.send_ctcp_query(target, "#{subcmd} #{cmd_string}")
      end
    end

    return true
  end  
  
  
end
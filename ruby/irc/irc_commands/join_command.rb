class JoinCommand
  
  def initialize(unit, options = {})
    @unit = unit
  end
  
  def help
    "/#{command_and_aliases} <channel name> - joins the specified channel"
  end
  
  def command_and_aliases
    c = "/#{command}"
    a = aliases.collect {|a| "/#{a}" }
    [c, a].join (' | ')
  end
  
  def aliases
    [:j]
  end
  
  def command
    :join
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
  
  def get_target(cmd_string, sel)
    return sel.name if (channel_is_selected?(sel) && !sel.active? && cmd_string.empty?)
      
    channel = cmd_string.token!
    return channel if channel.channelname?    
    '#' + channel  
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

    target = get_target(cmd_string, sel) # note... this method will mutate cmd_string
    cut_colon = cut_colon!(cmd_string)        

    @unit.send(self.command, target, cmd_string)    
    return true
  end
  
end
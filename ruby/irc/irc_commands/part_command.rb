class PartCommand
  
  def initialize(unit, options = {})
    @unit = unit
    @invoked_command = options[:invoked_command] || :part
  end
  
  def help
    "/#{command_and_aliases}  [channel name] - leaves the current channel, or the specified channel."
  end
  
  def command_and_aliases
    c = "/#{command}"
    a = aliases.collect {|a| "/#{a}" }
    [c, a].join(' | ')
  end
  
  def aliases
    [:leave]
  end
  
  def command
    :part
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
    return sel.name if (channel_is_selected?(sel) && !cmd_string.channelname?)
    cmd_string.token!
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

    if talk_is_selected?(sel) && !cmd_string.channelname?
      @unit.world.destroy_channel(sel)
      return true
    end

    target = get_target(cmd_string, sel) # note... this method will mutate cmd_string
    cut_colon = cut_colon!(cmd_string)        
    
    #return action_cmd(cmd, s, target, opmsg, cut_colon)                
    @unit.send(self.command, target, cmd_string)
    return true
  end
  
end
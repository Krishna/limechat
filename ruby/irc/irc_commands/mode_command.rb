class ModeCommand
  
  def initialize(unit, options = {})
    @unit = unit
  end
  
  def help
    "/#{command_and_aliases} [<channel>|<nick>] <modes> - changes the user or channel mode"
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
    :mode
  end
  
  def command_sent_over_wire
    self.command
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
    return sel.name if channel_is_selected?(sel) && !cmd_string.modechannelname?
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
    #DebugTools.log_outbound_command(self.command, cmd_string, complete_target, target)

    target = get_target(cmd_string, sel) # note... this method will mutate cmd_string
    cut_colon = cut_colon!(cmd_string)        

    @unit.send(self.command_sent_over_wire, target, cmd_string)

    return true
  end
  
end
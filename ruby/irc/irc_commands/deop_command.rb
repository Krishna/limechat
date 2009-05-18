class DeopCommand
  
  def initialize(unit, options = {})
    @unit = unit
  end
  
  def help
    "/#{command_and_aliases} <nick> [<nick> ...] - removes operator status from the specified user nicks"
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
    :deop
  end
  
  def opmsg?
    false
  end
  
  def channel_is_selected?(sel)
    sel && sel.channel?
  end

=begin
  def talk_is_selected?(sel)
    sel && sel.talk?
  end
=end
  
  def get_target(cmd_string, sel)
    return sel.name if channel_is_selected?(sel) && !cmd_string.modechannelname?
    cmd_string.token!
  end

=begin  
  def cut_colon!(cmd_string)
    if cmd_string[0] == ?:
      cmd_string[0] = ''
      return true
    end
    return false
  end  
=end
  
  # TODO: can we eliminate complete_target and target from the method signature?
  def execute(cmd_string, complete_target = true, target = nil, sel = nil)
    DebugTools.log_outbound_command(self.command, cmd_string, complete_target, target)

    target = get_target(cmd_string, sel) # note... this method will mutate cmd_string

    params = cmd_string.split(/ +/)
    return true if params.empty? # TODO output help text
    
    mode_command_string = "-" + ("o" * params.size) + ' ' + cmd_string    
    @unit.send(:mode, target, mode_command_string)
    return true    
  end
  
end
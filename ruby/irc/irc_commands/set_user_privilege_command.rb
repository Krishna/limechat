=begin rdoc
Base class for commands that set user privilieges (eg: :op, :deop etc)
=end
class SetUserPrivilegeCommand
  def initialize(unit, options = {})
    @unit = unit
    @command = options[:command]
    @help_text = options[:help_text] || 'no help available'
    @aliases = options[:aliases] || []

    @mode_command = options[:privilege]
    @privilege_modifier = '+' if options[:set_privilege]
    @privilege_modifier = '-' if options[:clear_privilege]                                                         
  end

  def help
    "/#{command_and_aliases} - #{@help_text}"
  end

  def command_and_aliases
    c = "/#{command}"
    a = aliases.collect {|a| "/#{a}" }
    [c, a].join(' | ')
  end

  def aliases
    @aliases
  end

  def command
    @command
  end

  def opmsg?
    false
  end

  def channel_is_selected?(sel)
    sel && sel.channel?
  end

  def get_target(cmd_string, sel)
    return sel.name if channel_is_selected?(sel) && !cmd_string.modechannelname?
    cmd_string.token!
  end

  # TODO: can we eliminate complete_target and target from the method signature?
  def execute(cmd_string, complete_target = true, target = nil, sel = nil)
    DebugTools.log_outbound_command(self.command, cmd_string, complete_target, target)

    target = get_target(cmd_string, sel) # note... this method will mutate cmd_string

    params = cmd_string.split(/ +/)
    return true if params.empty? # TODO output help text

    mode_command_string = @privilege_modifier + (@mode_command * params.size) + ' ' + cmd_string    
    @unit.send(:mode, target, mode_command_string)
    return true    
  end  
  
end
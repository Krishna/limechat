require 'set_user_privilege_command.rb'

class BanCommand < SetUserPrivilegeCommand
  
  def initialize(unit, options = {})
    options[:cmd] = :ban
    options[:privilege] = 'b'
    options[:set_privilege] = true 
    options[:help_text] = '<mask> - removes channel ban from the specified mask (nick!username@hostname)'

    super(unit, options)    
  end
  
  # TODO: can we eliminate complete_target from the method signature?
  def execute(cmd_string, complete_target = true, target = nil, sel = nil)
    #DebugTools.log_outbound_command(self.command, cmd_string, complete_target, target)

    target = get_target(cmd_string, sel) # note... this method will mutate cmd_string

    params = cmd_string.split(/ +/)

    mode_command_string = if params.empty? # TODO output help text
                            @privilege_modifier + @mode_command
                          else
                            @privilege_modifier + (@mode_command * params.size) + ' ' + cmd_string
                          end

    @unit.send(:mode, target, mode_command_string)
    return true    
  end  
  

end
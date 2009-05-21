require 'set_user_privilege_command.rb'

class OpCommand < SetUserPrivilegeCommand
  
  def initialize(unit, options = {})
    options[:privilege] = 'o'    
    options[:set_privilege] = true
    super(unit, options)    
  end
  
  def help
    "/#{command_and_aliases} <nick> [<nick> ...] - promotes the specified user nicks to operator status"
  end
    
  def command
    :op
  end

end
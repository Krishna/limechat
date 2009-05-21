require 'set_user_privilege_command.rb'

class DeopCommand < SetUserPrivilegeCommand
  
  def initialize(unit, options = {})
    options[:privilege] = 'o'    
    options[:clear_privilege] = true
    super(unit, options)
  end
  
  def help
    "/#{command_and_aliases} <nick> [<nick> ...] - removes operator status from the specified user nicks"
  end
      
  def command
    :deop
  end
  
end
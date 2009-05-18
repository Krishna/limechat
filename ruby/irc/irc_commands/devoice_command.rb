require 'set_user_privilege_command.rb'

class DevoiceCommand < SetUserPrivilegeCommand
  
  def initialize(unit, options = {})
    options[:privilege] = 'v'    
    options[:clear_privilege] = true
    super(unit, options)
  end
  
  def help
    "/#{command_and_aliases} <nick> [<nick> ...] - removes voiced status from the specified user nicks"
  end
      
  def command
    :devoice
  end
  
end
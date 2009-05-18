require 'set_user_privilege_command.rb'

class VoiceCommand < SetUserPrivilegeCommand
  
  def initialize(unit, options = {})
    options[:privilege] = 'v'    
    options[:set_privilege] = true
    super(unit, options)    
  end
  
  def help
    "/#{command_and_aliases} <nick> [<nick> ...] - promotes the specified user nicks to voiced status"
  end
    
  def command
    :voice
  end

end
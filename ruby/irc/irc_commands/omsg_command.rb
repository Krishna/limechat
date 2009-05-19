require 'privmsg_command.rb'

class OmsgCommand < PrivmsgCommand
  
  def help
    "/#{command_and_aliases} <text> - sends a message to all the operators in the channel"
  end
    
  def command
    :omsg
  end

  def command_sent_over_wire
    :privmsg
  end
  
  def opmsg?
    true
  end
   
end
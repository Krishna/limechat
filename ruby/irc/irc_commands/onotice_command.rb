require 'notice_command.rb'

class OnoticeCommand < NoticeCommand

  def help
    "/#{command_and_aliases} <text> - sends a message to all operators in the channel"
  end

  def aliases
    []
  end
  
  def command
    :onotice
  end
  
  def opmsg?
    true
  end

  def get_target(cmd_string, sel)
    return sel.name if channel_is_selected?(sel) && !cmd_string.channelname?
    cmd_string.token!
  end
  
end
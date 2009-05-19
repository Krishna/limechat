class NoticeCommand
  
  def initialize(unit, options = {})
    @unit = unit
  end
  
  def help
    #TODO: put in a help message
    "/#{command_and_aliases} ??????????"
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
    :notice
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
    # return sel.name if channel_is_selected?(sel) && !cmd_string.channelname?
    cmd_string.token!    
  end
  
  def cut_colon!(cmd_string)
    if cmd_string[0] == ?:
      cmd_string[0] = ''
      return true
    end
    return false
  end  
  
  def process_multiple_targets(cmd, cmd_string, target)

    cmd_string = @unit.to_local_encoding(@unit.to_common_encoding(cmd_string))

    loop do
      break if cmd_string.empty?
      t = @unit.truncate_text(cmd_string, cmd, target)
      break if t.empty?

      targets = target.split(/,/)

      targets.each do |chname|
        next if chname.empty?

        # support for @#channel
        #
        if chname =~ /^@/
          chname.replace($~.post_match)
          op_prefix = true
        else
          op_prefix = false
        end

        c = @unit.find_channel(chname)
        if !c && !chname.channelname? && !@unit.eq(chname, 'NickServ') && !@unit.eq(chname, 'ChanServ')
          c = @unit.world.create_talk(@unit, chname)
        end
        @unit.print_both(c || chname, cmd, @unit.mynick, t)

        # support for @#channel and omsg/onotice
        #
        if chname.channelname?
          if opmsg? || op_prefix
            chname.replace("@#{chname}")
          end
        end
      end

      if cmd == :action
        cmd = :privmsg
        t = "\x01ACTION #{t}\x01"
      end

      @unit.send(cmd, targets.join(','), t)
    end    
  end
  
  def process_text_commands(cmd, cmd_string)
  end  
  
  
  # TODO: can we eliminate complete_target from the method signature?
  def execute(cmd_string, complete_target = true, target = nil, sel = nil)
    DebugTools.log_outbound_command(self.command, cmd_string, complete_target, target)

    target = get_target(cmd_string, sel) # note... this method will mutate cmd_string
    cut_colon = cut_colon!(cmd_string)        

    cmd = self.command
    # extracted from process_text()...
    if cmd_string[0] == 0x1
      cmd = :ctcpreply
      cmd_string[0] = ''
      n = cmd_string.index("\x01")
      cmd_string = cmd_string[0...n] if n
    end

    return false unless target
    return false if cmd_string.empty?

    process_multiple_targets(cmd, cmd_string, target)

    return true
  end
  
end
class WeightsCommand
  
  def initialize(unit)
    @unit = unit
  end
  
  def help
    "/#{self.command} - displays weights information"
  end
  
  def command
    :weights
  end
  
  def opmsg?
    false
  end
  
  # TODO: can we eliminate complete_target and target from the method signature?
  def execute(cmd_string, complete_target = true, target = nil, sel = nil)
    DebugTools.log_outbound_command(self.command, cmd_string, complete_target, target)

    sel = @unit.world.selchannel
    if sel
      @unit.print_both(@unit, :reply, "WEIGHTS: ") 
      sel.members.each do |m|
        if m.weight > 0
          out = "#{m.nick} - sent: #{m.incoming_weight} received: #{m.outgoing_weight} total: #{m.weight}" 
          @unit.print_both(@unit, :reply, out) 
        end
      end
    end
    return true
             
  end
  
end
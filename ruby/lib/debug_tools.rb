#  Created by Krishna Kotecha.
# You can redistribute it and/or modify it under the Ruby's license or the GPL2.

=begin
A utility class to hold debugging and development tools.
Handy for storing code that is solely for exploring the code base during development.
=end
class DebugTools

  def self.log_send_command(s, complete_target, target)
    complete_target_string = complete_target ? "true" : "false"
    target_str = if target
	               target.to_s
			     else
				   "nil"
			     end
    printf "[send_command] s:%s | complete_target: %s | target: %s\n", s, complete_target_string, target_str
  end

end

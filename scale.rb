
module ScaleBalance
	LEFT = -1
	BALANCED = 0
	RIGHT = 1
end

class Scale

	def initialize
		@moves = 0
	end

	def moves
		@moves
	end

	def balance( left, right )
		# puts "in balance() left = #{left}  right = #{right}"
		@moves = moves + 1

		left_weight = 0
		right_weight = 0

		left.each do |x| 
			# puts "loop x = #{x}, x.weight = #{x.weight}, left_weight = #{left_weight}"
			left_weight =  x.weight + left_weight 
		end

		right.each do |x| 
			right_weight = x.weight + right_weight
		end

		if( left_weight > right_weight ) 
			ScaleBalance::LEFT
		elsif right_weight > left_weight
			ScaleBalance::RIGHT
		else
			ScaleBalance::BALANCED
		end
	end
end

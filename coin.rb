
class Coin
	def initialize( weight=4 )
		@weight = weight
		@depth = 0
	end

	def weight
		# @depth = @depth+1
		# puts "@depth #{@depth}"
		# puts caller # Kernel#caller returns an array of strings
		@weight
	end

	def to_s
		"[weight=#{weight}]"
	end

end
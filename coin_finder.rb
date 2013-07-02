
require './scale'
require './coin'

module SearchType
	BINARY = 2
	TRINARY = 3
end

class CoinFinder


	def initialize( count, search_type )

		@search_type = search_type
		@coins = Array.new(count)
		@scale = Scale.new

		hollow_coin = rand(count-1)
		# puts "hollow_coin = [#{hollow_coin}]"
		i = 0

		while i < count do
			@coins[i] = Coin.new
			i = i+1
		end

		@coins[ hollow_coin ] = Coin.new(1)
		# puts "ctor coins = #{@coins}"
			
	end

	def find_coin
		if @search_type == SearchType::BINARY
			do_binary( @coins )
		else 
			do_trinary( @coins )
		end
	end

	def do_binary( coins ) 
		# puts "in do_binary coins.length = [#{coins.length}]"
		if coins.length == 1
			# puts "Found the coin in #{@scale.moves} moves coin = #{coins[0]}"
			return @scale.moves
		end

		even = false
		extra_coin = Coin.new
		if coins.length % 2 == 0
			even = true
		end

		index = even ? coins.length / 2 : (coins.length - 1) / 2
		left = coins.slice( 0..index-1 )
		enddex = (index * 2) - 1
		right = coins.slice( index..enddex )
		extra_coin = even ? nil : coins[ coins.length-1]

		# puts "in do_binary index = [#{index}], enddex = #{enddex}, extra_coin = #{extra_coin}"
		
		scale_balance = @scale.balance( left, right )

		if ScaleBalance::LEFT == scale_balance
			# puts "heavy left, going right"
			do_binary( right )
		elsif ScaleBalance::RIGHT == scale_balance
			# puts "heavy right, going left"
			do_binary( left )
		else
			if extra_coin.nil?
				puts "Scale error"
			else 
				# puts "Found the coin in #{@scale.moves} moves extra_coin = #{extra_coin}"
				return @scale.moves
			end
		end
	end


	def do_trinary( coins ) 
		# puts "\nin do_ternary coins.length = [#{coins.length}] "
		# puts "hollow index = #{hollow_index(coins)}"
		if coins.length == 1
			# puts "Found the coin in #{@scale.moves} moves coin = #{coins[0]}"
			return @scale.moves
		end

		if coins.length > 2
			left_over = coins.length % 3
			chunk_size = (coins.length / 3).floor

			left = coins.slice( 0..chunk_size-1 )
			chunk_middex = (chunk_size * 2) 
			middle = coins.slice( chunk_size..chunk_middex-1 )
			right = coins.slice( chunk_middex..coins.length-1 )
		else
			left = coins.slice( 0..0 )
			middle = coins.slice( 1..1 )
			right = nil
		end			
		# puts "in do_ternary chunk_size(index) = [#{chunk_size}], middex = #{chunk_middex}, left_over = #{left_over}"
		# puts "in do_ternary left = [#{left.length}], middle = #{middle.length}, right = #{right.length}"

		scale_balance = @scale.balance( left, middle )
		# puts "scale_balance == #{scale_balance}"
		if ScaleBalance::LEFT == scale_balance
			# puts "heavy left, going middle\n"
			do_trinary( middle )
		elsif ScaleBalance::RIGHT == scale_balance
			# puts "heavy middle, going left\n"
			do_trinary( left )
		else
			# puts "balanced, going right\n"
			do_trinary( right )
		end
	end

	# def hollow_index( coins )
	# 	i = 0
	# 	coins.each do |x|
	# 		if( x.weight == 1 ) 
	# 			return i
	# 		end
	# 		i = i+1
	# 	end
	# end
end

runs = 100
num_coins = Array[10, 100, 1000, 10000, 100000]
tally = 0

num_coins.each do |coins|
	runs.times do 
		finder = CoinFinder.new( coins, SearchType::BINARY)
		tally = tally + finder.find_coin
	end
	puts "Binary search averaged #{tally/runs} moves for #{coins} coins"
end


tally= 0

num_coins.each do |coins|
	runs.times do 
		finder = CoinFinder.new( coins, SearchType::TRINARY)
		tally = tally + finder.find_coin
	end
	puts "Trinary search averaged #{tally/runs} moves for #{coins} coins"
end

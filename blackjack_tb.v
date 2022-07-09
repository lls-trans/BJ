`timescale 1ns/1ns

module blackjack_tb;

reg clock,card_rdy;
reg [0:3]card_value;
wire win,lost,request_card;

blackjack U1(.card_rdy(card_rdy),.clock(clock),.card_value(card_value),.win(win),.lost(lost),.request_card(request_card));

always #50 clock = !clock;

initial 
	begin
	clock = 0;
	card_rdy = 0;
	card_value = 4'b0;
	
	wait(request_card == 1)
	begin
	#50 card_rdy = 1;
	card_value = 3;
	#200 card_rdy =0;
	end

	wait(request_card == 1)
	begin
	#50 card_rdy = 1;
	card_value = 4;
	#200 card_rdy =0;
	end

	wait(request_card == 1)
	begin
	#50 card_rdy = 1;
	card_value = 5;
	#200 card_rdy =0;
	end

	wait(request_card == 1)
	begin
	#50 card_rdy = 1;
	card_value = 1;
	#200 card_rdy =0;
	end
	
	wait(request_card == 1)
	begin
	#50 card_rdy = 1;
	card_value = 8;
	#200 card_rdy =0;
	end
	
	end
endmodule
//second commit？
//what's the difference between "feat"and "fix"?

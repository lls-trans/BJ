
module blackjack(card_rdy,card_value,request_card,win,lost,clock);

input card_rdy,clock;
input [0:3] card_value;
output win,lost,request_card;

parameter INITIAL_ST = 0,GETCARD_ST = 1, REMCARD_ST = 2,ADD_ST = 3, CHECK_ST = 4,
	  WIN_ST = 5,BACKUP_ST = 6, LOST_ST = 7;

reg request_card,win,lost;
reg [0:2] bj_state;
reg [0:3] current_card_value;
reg [0:4] total;
reg ace_as_11;

always @(negedge clock)
	case(bj_state)
	
	INITIAL_ST:
		begin 
		total <= 0;
		ace_as_11 <= 0;
		win <= 0;
		lost <= 0;
		bj_state <= GETCARD_ST;
		end

	GETCARD_ST:
		begin
		request_card <= 1;

		if(card_rdy)
			begin
			current_card_value <= card_value;
			bj_state <= REMCARD_ST;
			end
		end

	REMCARD_ST:
		if(card_rdy)
			request_card <= 0;
		else
			bj_state <= ADD_ST;

	ADD_ST:
		begin
			if(~ace_as_11 && current_card_value)
				begin
				current_card_value <= 11;
				ace_as_11 <= 1;
				end
			total <= total + current_card_value;
			bj_state <= CHECK_ST;
		end

	CHECK_ST:
		if(total < 17)
			bj_state <= GETCARD_ST;
		else
			begin
			if(total < 22)
				bj_state <= WIN_ST;
			else
				bj_state <= BACKUP_ST;
			end

	BACKUP_ST:
		if(ace_as_11)
		begin
			total <= total - 10;
			ace_as_11 <= 0;
			bj_state <= CHECK_ST;
		end
		else
			bj_state <= LOST_ST;

	LOST_ST:
		begin
			lost <= 1;
			request_card <= 1;
			if(card_rdy)
				bj_state <= INITIAL_ST;
		end

	WIN_ST:
		begin
			win <= 1;
			request_card <= 1;
			if(card_rdy)
				bj_state <= INITIAL_ST;
		end

	default: bj_state <= INITIAL_ST;
	endcase

endmodule


module miniproject(receipt,card_insert,pin,language,type,amount,clock,cancel);
output reg receipt ;
input card_insert,pin,language,type,amount,clock,cancel ;
reg [2:0] q,d;
integer counter;
initial
begin
 counter = 4'b0000;
end

parameter idle=3'b000 , welcome=3'b001 , choose_lang=3'b010 , type_acc=3'b011 , enter_amount = 3'b100 , waiting=3'b101 ;

always @ (*)
 begin receipt=0;
   case(q)
	   idle : d<=card_insert  ? welcome      : idle         ;
        welcome : d<=pin          ? choose_lang  : welcome      ;
    choose_lang : d<=language     ? type_acc     : choose_lang  ;
       type_acc : d<=type         ? enter_amount : type_acc     ;
   enter_amount : d<=amount       ? waiting      : enter_amount ;
        waiting : begin
			d<=idle;
			receipt=1;
		  end
	default : d<=3'bxxx;
   endcase
 end

always @ (posedge clock)
begin 
 if(cancel == 1)
    q<=0;
 else
    q<=d;
end
endmodule

module miniprojecttb();
wire receipt ;
reg card_insert,pin,language,type,amount,clock,cancel ;

miniproject mini(receipt,card_insert,pin,language,type,amount,clock,cancel);

initial 
 begin
      clock  = 0;
      cancel = 1;
  #12  cancel = 0;
 end

always
    #10 clock = ~clock;

initial
 begin
		card_insert = 0;
	#10	card_insert = 0;
	#20	card_insert = 1;
	#20	pin         = 0;
	#20	pin         = 1;
	#20	language    = 1;
	#20	type        = 1;
	#20	amount      = 1;
 end

endmodule

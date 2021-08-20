class wrap;

    bit [31:0]temp_lower_boundry;
	bit [31:0]temp_upper_boundry;
	
//______________________________________________________________________________________________
//______________________________________________________________________________________________
    function bit [4:0]hburst_decoder(input bit [2:0]hburst);
       case(hburst)
          3'b010  : return 4;                           // WRAP 4
          3'b100  : return 8;                           // WRAP 8
          3'b110  : return 16;                          // WRAP 16
          default : $display("NOT A VALID WRAP!!!");
       endcase
    endfunction
//______________________________________________________________________________________________	
//______________________________________________________________________________________________
    function bit [7:0]hsize_decoder(input bit [2:0]hsize);
         case(hsize)
            3'b000 : return 1;
            3'b001 : return 2;
            3'b010 : return 4;
            3'b011 : return 8;   
            3'b100 : return 16;
            3'b101 : return 32;
            3'b110 : return 64;
            3'b111 : return 128;
        endcase
    endfunction
//______________________________________________________________________________________________
//______________________________________________________________________________________________
    function bit [31:0]lower_boundry(input bit [ 2:0]hsize,
	                               input bit [ 2:0]hburst,
	                               input bit [31:0]haddr);						   
        return (((haddr)/(hsize*hburst_decoder(hburst)))*((hsize*hburst_decoder(hburst))));
    endfunction
//______________________________________________________________________________________________
//______________________________________________________________________________________________
	
    function bit [31:0]upper_boundry(input bit [ 2:0]hsize,
                                   input bit [ 2:0]hburst,
                                   input bit [31:0]haddr);
        return (lower_boundry(hsize, hburst, haddr) + (hsize*hburst_decoder(hburst)));
    endfunction
//______________________________________________________________________________________________
//______________________________________________________________________________________________

    task wrap_calc(input bit [ 2:0]hsize,
                   input bit [ 2:0]hburst,
                   input bit [31:0]haddr);
    			
        temp_lower_boundry = lower_boundry(hsize, hburst, haddr);
        temp_upper_boundry = upper_boundry(hsize, hburst, haddr);

        $display("%0h %0h", temp_lower_boundry, temp_upper_boundry);
    endtask
//______________________________________________________________________________________________
//______________________________________________________________________________________________

endclass

/*
module test;
 wrap wrap_;
 
 initial begin
    wrap_ = new();
    
    wrap_.wrap_calc(3'h4, 3'h4, 32'h34);
 end
endmodule
*/
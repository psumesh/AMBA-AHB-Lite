class wraper_class;
	
//_____________________________________________________________________________________________________________________
//_____________________________________________________________________________________________________________________
    function bit [4:0]hburst_decoder(input bit [2:0]hburst);
       case(hburst)
          3'b010  : return 4;                           // WRAP 4
          3'b100  : return 8;                           // WRAP 8
          3'b110  : return 16;                          // WRAP 16
          default : $display("NOT A VALID WRAP!!!");
       endcase
    endfunction
//_____________________________________________________________________________________________________________________	
//_____________________________________________________________________________________________________________________
    function bit [7:0]hsize_decoder(input bit [2:0]hsize);
         case(hsize)
            3'b000 : return 1;          // byte
            3'b001 : return 2;          // half word
            3'b010 : return 4;          // word
            3'b011 : return 8;          // double word
            3'b100 : return 16;         // 4 word line
            3'b101 : return 32;         // 8 word line
            3'b110 : return 64;         // 16 word line
            3'b111 : return 128;        // 32 word line
        endcase
    endfunction
//_______________________________________________________________________________________________________________________
//_______________________________________________________________________________________________________________________
    function bit [31:0]lower_boundry(input bit [ 2:0]hsize,
	                                 input bit [ 2:0]hburst,
	                                 input bit [31:0]haddr);						   
        return (((haddr)/(hsize_decoder(hsize)*hburst_decoder(hburst)))*((hsize_decoder(hsize)*hburst_decoder(hburst))));
    endfunction
//_______________________________________________________________________________________________________________________
//_______________________________________________________________________________________________________________________
	
    function bit [31:0]upper_boundry(input bit [ 2:0]hsize,
                                   input bit [ 2:0]hburst,
                                   input bit [31:0]haddr);
        return (lower_boundry(hsize, hburst, haddr) + (hsize_decoder(hsize)*hburst_decoder(hburst)));
    endfunction
//_________________________________________________________________________________________________________________________
//_________________________________________________________________________________________________________________________

     task wrap_calc(input bit [ 2:0]hsize,
                   input bit [ 2:0]hburst,
                   input bit [31:0]haddr,
                   output bit [31:0]queue[$]);
        
        bit [31:0]temp_lower_boundry;
        bit [31:0]temp_upper_boundry;
		bit [31:0] out_address;
    			
        temp_lower_boundry = lower_boundry(hsize, hburst, haddr);
        temp_upper_boundry = upper_boundry(hsize, hburst, haddr);

        //$display("%0h %0h", temp_lower_boundry, temp_upper_boundry);
		
		
		
		repeat((hburst_decoder(hburst) + 1)) begin
		    if(haddr <= temp_upper_boundry) begin
			    out_address = haddr;
				haddr = (haddr + hsize_decoder(hsize));
				queue.push_back(out_address);
			end
			
			else if(haddr > temp_upper_boundry) begin
			    out_address = (haddr - temp_upper_boundry);
				haddr = temp_lower_boundry + out_address;
			end
		end
		//$display("%p", queue);
		
		
		
		
    endtask
//_________________________________________________________________________________________________________________________
//_________________________________________________________________________________________________________________________

endclass

/*
module test;
 wrap wrap_;
 bit [31:0] queue[$];
 
 initial begin
    wrap_ = new();
    
    
	wrap_.wrap_calc(3'h2, 3'h4, 32'h34, queue);         //hsize, hburst, haddr
    foreach(queue[i])
	   $display("%0h", queue[i]);

    $display();
  wrap_.wrap_calc(3'h2, 3'h4, 32'h50, queue);         //hsize, hburst, haddr
    foreach(queue[i])
	   $display("%0h", queue[i]);
 end
 

 
endmodule
*/

// Umesh Prasad
//github : https://www.github.com/psumesh


interface intf(input bit hresetn, hclk);

     logic       hsel;
     logic       hwrite;
     logic       hmaster;
     logic       hmastlock;
     logic [1:0] htrans;
     logic [2:0] hsize;
     logic [2:0] hburst;
     logic [31:0]haddr;
     logic [31:0]hwdata;
	 
	 
  // ouput of slave
     logic       hready = 1;
  // logic       hsplit;
     logic [1:0] hresp;
     logic [31:0]hrdata;

endinterface
	
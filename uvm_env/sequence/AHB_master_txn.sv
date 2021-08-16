// Umesh Prasad
//github : https://www.github.com/psumesh


class AHB_master_txn extends uvm_sequence_item;

  // input to ahb_slave
     rand bit       hsel;
	 rand logic       hwrite;
	 rand bit       hmaster;
	 rand bit       hmastlock;
	 rand bit   [ 1:0]htrans;
	 rand logic [ 2:0]hsize;
	 rand logic [ 2:0]hburst;
	 rand logic [31:0]haddr;
	 rand logic [31:0]hwdata;
	 
	 
  // ouput of slave_salve
	 bit       hready;
  // bit       hsplit;
	 bit [ 1:0]hresp;
	 bit [31:0]hrdata;
	 
	`uvm_object_utils_begin(AHB_master_txn)
		`uvm_field_int(hsel,      UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(hwrite,    UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(hmaster,   UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(hmastlock, UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(htrans,    UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(hsize,     UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(hburst,    UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(hsize,     UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(hburst,    UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(haddr,     UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(hwdata,    UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(hready,    UVM_ALL_ON|UVM_DEC)
		//`uvm_field_int(hsplit,    UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(hresp,     UVM_ALL_ON|UVM_DEC)
		`uvm_field_int(hrdata,    UVM_ALL_ON|UVM_DEC)
    `uvm_object_utils_end

	function new(string name = "AHB_master_txn");
		super.new(name);
	endfunction
	 
endclass

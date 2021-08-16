// Umesh Prasad
//github : https://www.github.com/psumesh


class AHB_base_sequence extends uvm_sequence #(AHB_master_txn);

	  string str_hwrite;
	  string hwdata_cfg;
	  string haddr_cfg;
	  string htrans_cfg;
	  
	  string h_hwdata;
	  string h_haddr;
	  
	  AHB_master_txn master_txn;
	  
	  `uvm_declare_p_sequencer(AHB_sequencer)
	
	`uvm_object_utils_begin(AHB_base_sequence)
	    `uvm_field_string(str_hwrite,    UVM_DEFAULT)
        `uvm_field_string(hwdata_cfg, UVM_DEFAULT)
	    `uvm_field_string(haddr_cfg,  UVM_DEFAULT)
		`uvm_field_string(htrans_cfg, UVM_DEFAULT)
    `uvm_object_utils_end
	 
	function new(string name = "AHB_base_sequence");
	      super.new(name);
	 endfunction
	 
	 
	 virtual task body();
	    master_txn = AHB_master_txn::type_id::create("master_txn");
		void'(p_sequencer.get_config_string("str_hwrite", str_hwrite));    //getting data from m to p sequencer
		void'(p_sequencer.get_config_string("hwdata_cfg", hwdata_cfg));
		void'(p_sequencer.get_config_string("haddr_cfg", haddr_cfg));
		void'(p_sequencer.get_config_string("htrans_cfg", htrans_cfg));
		
		h_hwdata = hwdata_cfg;
		h_haddr  = haddr_cfg;
		
		case(str_hwrite)
		"WR" : begin
		      case(htrans_cfg)
		            "IDLE"    : begin
		                        repeat(30) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1;
			                                                            master_txn.htrans    == 2'b00;
												                        master_txn.hsize     == 0;
                                                                        master_txn.hburst    == 0;
                                                                        master_txn.haddr     == haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;})
					                finish_item(master_txn);
					            end
		
		            end
		
		            "BUSY"    : begin
		                        repeat(30) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b1;
			                                                            master_txn.htrans    == 2'b01;
												                        master_txn.hsize     == 'z;
                                                                        master_txn.hburst    == 'z;
                                                                        master_txn.haddr     == haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;})
					                finish_item(master_txn);
					            end
		
		            end
		
		            "NON_SEQ" : begin
		                        repeat(30) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b1;
			                                                            master_txn.htrans    == 2'b10;
												                        master_txn.hsize     == 'z;
                                                                        master_txn.hburst    == 'z;
                                                                        master_txn.haddr     == haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;})
					                finish_item(master_txn);
					            end
		
		            end
		
		            "SEQ"     : begin
		                        repeat(30) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b1;
			                                                            master_txn.htrans    == 2'b11;
												                        master_txn.hsize     == 'z;
                                                                        master_txn.hburst    == 'z;
                                                                        master_txn.haddr     == haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;})
					                finish_item(master_txn);
					            end
		
		            end
		
		            default   : begin
		                              `uvm_error("SEQUENCE", "ENTER CORRECT TRANSFER TYPE")
		            end
		        endcase
		end
		
		"RD" : begin
		      case(htrans_cfg)
		            "IDLE"    : begin
		                        repeat(30) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 'x;
			                                                            master_txn.htrans    == 2'b00;
												                        master_txn.hsize     == 'z;
                                                                        master_txn.hburst    == 'z;
                                                                        master_txn.haddr     == haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;})
					                finish_item(master_txn);
					            end
		
		            end
		
		            "BUSY"    : begin
		                        repeat(30) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b1;
			                                                            master_txn.htrans    == 2'b01;
												                        master_txn.hsize     == 'z;
                                                                        master_txn.hburst    == 'z;
                                                                        master_txn.haddr     == haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;})
					                finish_item(master_txn);
					            end
		
		            end
		
		            "NON_SEQ" : begin
		                        repeat(30) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b1;
			                                                            master_txn.htrans    == 2'b10;
												                        master_txn.hsize     == 'z;
                                                                        master_txn.hburst    == 'z;
                                                                        master_txn.haddr     == haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;})
					                finish_item(master_txn);
					            end
		
		            end
		
		            "SEQ"     : begin
		                        repeat(30) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b1;
			                                                            master_txn.htrans    == 2'b11;
												                        master_txn.hsize     == 'z;
                                                                        master_txn.hburst    == 'z;
                                                                        master_txn.haddr     == haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;})
					                finish_item(master_txn);
					            end
		
		            end
		
		            default   : begin
		                              `uvm_error("SEQUENCE", "ENTER CORRECT TRANSFER TYPE")
		            end
		        endcase
		end
		
		"WR_RD" : begin
		      case(htrans_cfg)
		            "IDLE"    : begin
		                        repeat(30) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 'x;
			                                                            master_txn.htrans    == 2'b00;
												                        master_txn.hsize     == 'z;
                                                                        master_txn.hburst    == 'z;
                                                                        master_txn.haddr     == haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;})
					                finish_item(master_txn);
					            end
		
		            end
		
		            "BUSY"    : begin
		                        repeat(30) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b1;
			                                                            master_txn.htrans    == 2'b01;
												                        master_txn.hsize     == 'z;
                                                                        master_txn.hburst    == 'z;
                                                                        master_txn.haddr     == haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;})
					                finish_item(master_txn);
					            end
		
		            end
		
		            "NON_SEQ" : begin
		                        repeat(30) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b1;
			                                                            master_txn.htrans    == 2'b10;
												                        master_txn.hsize     == 'z;
                                                                        master_txn.hburst    == 'z;
                                                                        master_txn.haddr     == haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;})
					                finish_item(master_txn);
					            end
		
		            end
		
		            "SEQ"     : begin
		                        repeat(30) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b1;
			                                                            master_txn.htrans    == 2'b11;
												                        master_txn.hsize     == 'z;
                                                                        master_txn.hburst    == 'z;
                                                                        master_txn.haddr     == haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;})
					                finish_item(master_txn);
					            end
		
		            end
		
		            default   : begin
		                              `uvm_error("SEQUENCE", "ENTER CORRECT TRANSFER TYPE")
		            end
		        endcase
		end
		
		default : begin
		          `uvm_error("SEQUNECE", "CHECK HWRITE TYPE!")
		end
		endcase
	 endtask
	 
	 
	 

endclass

// Umesh Prasad
//github : https://www.github.com/psumesh

class AHB_base_sequence extends uvm_sequence #(AHB_master_txn);

	  string str_hwrite;
	  string hwdata_cfg;
	  string htrans_cfg;
	  
	  bit [ 2:0] hsize_cfg;
	  bit [ 2:0] hburst_cfg;
	  bit [31:0]initial_haddr;
	  
	  string h_hwdata;
	  
	  
	  bit [31:0] hwdata = 1000;
	  
	  AHB_master_txn master_txn;
	  
	  `uvm_declare_p_sequencer(AHB_sequencer)
	
	`uvm_object_utils_begin(AHB_base_sequence)
	    `uvm_field_string(str_hwrite, UVM_DEFAULT)
        `uvm_field_string(hwdata_cfg, UVM_DEFAULT)
		`uvm_field_string(htrans_cfg, UVM_DEFAULT)
		`uvm_field_int(hsize_cfg,  UVM_DEFAULT)
    `uvm_object_utils_end
	 
	function new(string name = "AHB_base_sequence");
	      super.new(name);
	 endfunction
	 
	 
	 virtual task body();
	    master_txn = AHB_master_txn::type_id::create("master_txn");
		void'(p_sequencer.get_config_string("str_hwrite", str_hwrite));    //getting data from m to p sequencer
		void'(p_sequencer.get_config_string("hwdata_cfg", hwdata_cfg));
		void'(p_sequencer.get_config_string("htrans_cfg", htrans_cfg));
		
		// void'(p_sequencer.get_config_int("num_inst",num_inst)); //syntax at sequnce
		
		
		h_hwdata = hwdata_cfg;
		
		case(str_hwrite)
		"WR" : begin
		      case(htrans_cfg)
		            "IDLE"    : begin
		                        repeat(2) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1;                       //? unknown
			                                                            master_txn.htrans    == 2'b00;
												                        master_txn.hsize     == hsize_cfg;                       //hsize 
                                                                        master_txn.hburst    == hburst_cfg;                       //hburst type
                                                                        master_txn.haddr     == initial_haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;                       //?
												                        master_txn.hmaster   == 1;                       //?
												                        master_txn.hmastlock == 0;
																		master_txn.hready    == 1;})
									else
									    `uvm_error("SEQUENCE", "RANDOMIZE FAILED AT WR IDLE")
									hwdata        = hwdata        + 1000;
									initial_haddr = initial_haddr + 50;
					                finish_item(master_txn);
									
					            end
		
		            end
		
		            "BUSY"    : begin
		                        repeat(2) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1;
			                                                            master_txn.htrans    == 2'b01;
												                        master_txn.hsize     == hsize_cfg;
                                                                        master_txn.hburst    == hburst_cfg;
                                                                        master_txn.haddr     == initial_haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;
																		master_txn.hready    == 1;})
					                
									finish_item(master_txn);
					            end
		
		            end
		
		            "NON_SEQ" : begin
		                        repeat(30) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1;
			                                                            master_txn.htrans    == 2'b10;
												                        master_txn.hsize     == hsize_cfg;
                                                                        master_txn.hburst    == hburst_cfg;
                                                                        master_txn.haddr     == initial_haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;
																		master_txn.hready    == 1;})
																		
									
					                finish_item(master_txn);
									initial_haddr = initial_haddr + 50;
					            end
		
		            end
		
		            "SEQ"     : begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1;
			                                                            master_txn.htrans    == 2'b11;
												                        master_txn.hsize     == hsize_cfg;
                                                                        master_txn.hburst    == hburst_cfg;
                                                                        master_txn.haddr     == initial_haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;
																		master_txn.hready    == 1;})
					                finish_item(master_txn);
		
		            end
		
		            default   : begin
		                              `uvm_error("SEQUENCE", "ENTER CORRECT TRANSFER TYPE")
		            end
		        endcase
		end
		
		"RD" : begin
		      case(htrans_cfg)
		            "IDLE"    : begin
		                        repeat(2) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 0;
			                                                            master_txn.htrans    == 2'b00;
												                        master_txn.hsize     == hsize_cfg;
                                                                        master_txn.hburst    == hburst_cfg;
                                                                        master_txn.haddr     == initial_haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;
																		master_txn.hready    == 1;})
					                finish_item(master_txn);
					            end
		
		            end
		
		            "BUSY"    : begin
		                        repeat(2) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 0;
			                                                            master_txn.htrans    == 2'b01;
												                        master_txn.hsize     == hsize_cfg;
                                                                        master_txn.hburst    == hburst_cfg;
                                                                        master_txn.haddr     == initial_haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;
																		master_txn.hready    == 1;})
					                finish_item(master_txn);
					            end
		
		            end
		
		            "NON_SEQ" : begin
		                        repeat(30) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 0;
			                                                            master_txn.htrans    == 2'b10;
												                        master_txn.hsize     == hsize_cfg;
                                                                        master_txn.hburst    == hburst_cfg;
                                                                        master_txn.haddr     == initial_haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;
																		master_txn.hready    == 1;})
																		
									initial_haddr = initial_haddr + 50;
					                finish_item(master_txn);
					            end
		
		            end
		
		            "SEQ"     : begin
		                        repeat(1) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b0;
			                                                            master_txn.htrans    == 2'b11;
												                        master_txn.hsize     == hsize_cfg;
                                                                        master_txn.hburst    == hburst_cfg;
                                                                        master_txn.haddr     == initial_haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;
																		master_txn.hready    == 1;})
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
		                        repeat(2) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b1;
			                                                            master_txn.htrans    == 2'b00;
												                        master_txn.hsize     == hsize_cfg;
                                                                        master_txn.hburst    == hburst_cfg;
                                                                        master_txn.haddr     == initial_haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;
																		master_txn.hready    == 1;})
					                finish_item(master_txn);
									
									start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b0;
			                                                            master_txn.htrans    == 2'b00;
												                        master_txn.hsize     == hsize_cfg;
                                                                        master_txn.hburst    == hburst_cfg;
                                                                        master_txn.haddr     == initial_haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;
																		master_txn.hready    == 1;})
																		
									
					                finish_item(master_txn);
					            end
		
		            end
		
		            "BUSY"    : begin
		                        repeat(2) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b1;
			                                                            master_txn.htrans    == 2'b01;
												                        master_txn.hsize     == hsize_cfg;
                                                                        master_txn.hburst    == hburst_cfg;
                                                                        master_txn.haddr     == initial_haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;
																		master_txn.hready    == 1;})
					                finish_item(master_txn);
									
									start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b0;
			                                                            master_txn.htrans    == 2'b01;
												                        master_txn.hsize     == hsize_cfg;
                                                                        master_txn.hburst    == hburst_cfg;
                                                                        master_txn.haddr     == initial_haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;
																		master_txn.hready    == 1;})
					                finish_item(master_txn);
					            end
		
		            end
		
		            "NON_SEQ" : begin
		                        repeat(30) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b1;
			                                                            master_txn.htrans    == 2'b10;
												                        master_txn.hsize     == hsize_cfg;
                                                                        master_txn.hburst    == hburst_cfg;
                                                                        master_txn.haddr     == initial_haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;
																		master_txn.hready    == 1;})
					                finish_item(master_txn);
									
									start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b0;
			                                                            master_txn.htrans    == 2'b10;
												                        master_txn.hsize     == hsize_cfg;
                                                                        master_txn.hburst    == hburst_cfg;
                                                                        master_txn.haddr     == initial_haddr;
												                        master_txn.hwdata    == 0;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;
																		master_txn.hready    == 1;})
									initial_haddr = initial_haddr + 50;
					                finish_item(master_txn);
					            end
		
		            end
		
		            "SEQ"     : begin
		                        repeat(1) begin
		                            start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b1;
			                                                            master_txn.htrans    == 2'b11;
												                        master_txn.hsize     == hsize_cfg;
                                                                        master_txn.hburst    == hburst_cfg;
                                                                        master_txn.haddr     == initial_haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;
																		master_txn.hready    == 1;})
									hwdata = hwdata + 1000;
					                finish_item(master_txn);
									
									start_item(master_txn);
					                assert(master_txn.randomize() with {master_txn.hwrite    == 1'b0;
			                                                            master_txn.htrans    == 2'b11;
												                        master_txn.hsize     == hsize_cfg;
                                                                        master_txn.hburst    == hburst_cfg;
                                                                        master_txn.haddr     == initial_haddr;
												                        master_txn.hwdata    == hwdata;
                                                                        master_txn.hsel      == 1;
												                        master_txn.hmaster   == 1;
												                        master_txn.hmastlock == 1;
																		master_txn.hready    == 1;})
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

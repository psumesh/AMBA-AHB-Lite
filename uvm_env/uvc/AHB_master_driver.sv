class AHB_master_driver extends uvm_driver #(AHB_master_txn);

	`uvm_component_utils(AHB_master_driver)
	
	virtual intf vif;
	AHB_master_txn master_txn;
	bit [31:0] temp_addr;
	bit [31:0] temp_wdata = 100;
	string data_type;
	
	int infinity_increment = 1;
	
	function new(string name = "AHB_master_driver", uvm_component parent);
		super.new(name, parent);		
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual intf)::get(this, "", "vif", vif))
		   `uvm_error("DRIVER", "UVM CONFIG DB NOT FOUND!")
		   
		master_txn = AHB_master_txn::type_id::create("master_txn", this);
	endfunction
	
	function bit [31:0]data(string data_type);
	    case(data_type)
		 "INCREMENT" : return (temp_wdata+50);
		 "DECREMENT" : return (temp_wdata-72);
		 "RANDOM"    : return $random;
		 default     :`uvm_error("DRIVER", "CHECK UVM TEST FOR HWDATA DATA")
		endcase
	endfunction
	
	task idle();
            vif.hsel      <= master_txn.hsel;
			vif.hwrite    <= 'x;
			vif.hmaster   <= master_txn.hmaster;
			vif.hmastlock <= master_txn.hmastlock;
			vif.htrans    <= master_txn.htrans;
			vif.hsize     <= master_txn.hsize;
			vif.hburst    <= master_txn.hburst;
			vif.haddr     <= master_txn.haddr;
			vif.hwdata    <= master_txn.hwdata;
	endtask
	
	task busy();
	        vif.hsel      <= master_txn.hsel;
			vif.hwrite    <= master_txn.hwrite;
			vif.hmaster   <= master_txn.hmaster;
			vif.hmastlock <= master_txn.hmastlock;
			vif.htrans    <= master_txn.htrans;
			vif.hsize     <= master_txn.hsize;
			vif.hburst    <= master_txn.hburst;
			vif.haddr     <= master_txn.haddr;
			vif.hwdata    <= master_txn.hwdata;
			//vif.hready    <= master_txn.hready;
	endtask
	
	task non_seq();
	    while(!vif.hreadyout) begin
		    @(posedge vif.hclk);
		    end
			
	        vif.hsel      <= 1;
			vif.hwrite    <= master_txn.hwrite;
			vif.hmaster   <= master_txn.hmaster;
			vif.hmastlock <= master_txn.hmastlock;
			vif.htrans    <= master_txn.htrans;
			vif.hsize     <= 'x;
			vif.hburst    <= 'x;
			vif.haddr     <= master_txn.haddr;
			vif.hwdata    <= master_txn.hwdata;
			vif.hready    <= master_txn.hready;
			@(posedge vif.hclk);
	endtask
	
	task seq();
	    case(master_txn.hsize)
		3'b000 : begin                    //Byte         8
		
		        while(!vif.hreadyout) begin
                    @(posedge vif.clk);
                end
		            case(master_txn.hburst)
					    3'b000 : begin                                          //single burst
						         vif.hsel      <= 1;
			                     vif.hwrite    <= master_txn.hwrite;
			                     vif.hmaster   <= master_txn.hmaster;
			                     vif.hmastlock <= master_txn.hmastlock;
			                     vif.htrans    <= 2'b10;
			                     vif.hsize     <= master_txn.hsize;
			                     vif.hburst    <= master_txn.hburst;
			                     vif.haddr     <= master_txn.haddr;
			                     vif.hwdata    <= master_txn.hwdata;
								 vif.hready    <= master_txn.hready;
								  @(posedge vif.hclk);
								 
						end
						
						3'b001 : begin                                         //increment	
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= 3'b000;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
									 @(posedge vif.hclk);
									 
									begin
								         master_txn.haddr  = master_txn.haddr  + 1;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
								 
								 
								 while(infinity_increment) begin
								       while(vif.hreadyout == 0 || 'z || 'x) begin
								           @(posedge vif.hclk);
								        end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								     @(posedge vif.hclk);
								     begin
								         master_txn.haddr  = master_txn.haddr  + 1;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end								 
								 end
								 
						end
						
						3'b010 : begin
						
						end
						
						3'b011 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 1;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(3) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 1;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
						
						3'b100 : begin
						
						end
						
						3'b101 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 1;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(7) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 1;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
						
						3'b110 : begin
						
						end
						
						3'b111 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 1;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(15) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 1;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
					endcase
		end
		
		3'b001 : begin                    //Halfword     16
		         while(!vif.hreadyout) begin
                    @(posedge vif.clk);
                end
		            case(master_txn.hburst)
					    3'b000 : begin                                          //single burst
						         vif.hsel      <= 1;
			                     vif.hwrite    <= master_txn.hwrite;
			                     vif.hmaster   <= master_txn.hmaster;
			                     vif.hmastlock <= master_txn.hmastlock;
			                     vif.htrans    <= 2'b10;
			                     vif.hsize     <= master_txn.hsize;
			                     vif.hburst    <= master_txn.hburst;
			                     vif.haddr     <= master_txn.haddr;
			                     vif.hwdata    <= master_txn.hwdata;
								 vif.hready    <= master_txn.hready;
								  @(posedge vif.hclk);
								 
						end
						
						3'b001 : begin                                         //increment	
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= 3'b000;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
									 @(posedge vif.hclk);
									 
									begin
								         master_txn.haddr  = master_txn.haddr  + 2;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
								 
								 
								 while(infinity_increment) begin
								       while(vif.hreadyout == 0 || 'z || 'x) begin
								           @(posedge vif.hclk);
								        end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								     @(posedge vif.hclk);
								     begin
								         master_txn.haddr  = master_txn.haddr  + 2;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end								 
								 end
								 
						end
						
						3'b010 : begin
						
						end
						
						3'b011 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 2;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(3) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 2;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
						
						3'b100 : begin
						
						end
						
						3'b101 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 2;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(7) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 2;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
						
						3'b110 : begin
						
						end
						
						3'b111 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 2;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(15) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 2;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
					endcase
		end
		
		3'b010 : begin                    //Word         32
		         while(!vif.hreadyout) begin
                    @(posedge vif.clk);
                end
				
		            case(master_txn.hburst)
					    3'b000 : begin                                          //single burst
						         vif.hsel      <= 1;
			                     vif.hwrite    <= master_txn.hwrite;
			                     vif.hmaster   <= master_txn.hmaster;
			                     vif.hmastlock <= master_txn.hmastlock;
			                     vif.htrans    <= 2'b10;
			                     vif.hsize     <= master_txn.hsize;
			                     vif.hburst    <= master_txn.hburst;
			                     vif.haddr     <= master_txn.haddr;
			                     vif.hwdata    <= master_txn.hwdata;
								 vif.hready    <= master_txn.hready;
								  @(posedge vif.hclk);
								 
						end
						
						3'b001 : begin                                         //increment	
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= 3'b000;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
									 @(posedge vif.hclk);
									 
									begin
								         master_txn.haddr  = master_txn.haddr  + 4;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
								 
								 
								 while(infinity_increment) begin
								       while(vif.hreadyout == 0 || 'z || 'x) begin
								           @(posedge vif.hclk);
								        end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								     @(posedge vif.hclk);
								     begin
								         master_txn.haddr  = master_txn.haddr  + 4;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end								 
								 end
								 
						end
						
						3'b010 : begin
						
						end
						
						3'b011 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 4;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(3) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 4;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
						
						3'b100 : begin
						
						end
						
						3'b101 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 4;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(7) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 4;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
						
						3'b110 : begin
						
						end
						
						3'b111 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 4;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(15) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 4;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
					endcase
		end
		
		3'b011 : begin                    //Doubleword   64
		         while(!vif.hreadyout) begin
                    @(posedge vif.clk);
                end
		
		            case(master_txn.hburst)
					    3'b000 : begin                                          //single burst
						         vif.hsel      <= 1;
			                     vif.hwrite    <= master_txn.hwrite;
			                     vif.hmaster   <= master_txn.hmaster;
			                     vif.hmastlock <= master_txn.hmastlock;
			                     vif.htrans    <= 2'b10;
			                     vif.hsize     <= master_txn.hsize;
			                     vif.hburst    <= master_txn.hburst;
			                     vif.haddr     <= master_txn.haddr;
			                     vif.hwdata    <= master_txn.hwdata;
								 vif.hready    <= master_txn.hready;
								  @(posedge vif.hclk);
								 
						end
						
						3'b001 : begin                                         //increment	
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= 3'b000;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
									 @(posedge vif.hclk);
									 
									begin
								         master_txn.haddr  = master_txn.haddr  + 8;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
								 
								 
								 while(infinity_increment) begin
								       while(vif.hreadyout == 0 || 'z || 'x) begin
								           @(posedge vif.hclk);
								        end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								     @(posedge vif.hclk);
								     begin
								         master_txn.haddr  = master_txn.haddr  + 8;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end								 
								 end
								 
						end
						
						3'b010 : begin
						
						end
						
						3'b011 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 8;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(3) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 8;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
						
						3'b100 : begin
						
						end
						
						3'b101 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 8;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(7) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 8;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
						
						3'b110 : begin
						
						end
						
						3'b111 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 8;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(15) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 8;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
					endcase
		end
		
		3'b100 : begin                    //4-word line  128
		         while(!vif.hreadyout) begin
                    @(posedge vif.clk);
                end
		            case(master_txn.hburst)
					    3'b000 : begin                                          //single burst
						         vif.hsel      <= 1;
			                     vif.hwrite    <= master_txn.hwrite;
			                     vif.hmaster   <= master_txn.hmaster;
			                     vif.hmastlock <= master_txn.hmastlock;
			                     vif.htrans    <= 2'b10;
			                     vif.hsize     <= master_txn.hsize;
			                     vif.hburst    <= master_txn.hburst;
			                     vif.haddr     <= master_txn.haddr;
			                     vif.hwdata    <= master_txn.hwdata;
								 vif.hready    <= master_txn.hready;
								  @(posedge vif.hclk);
								 
						end
						
						3'b001 : begin
						
						end
						
						3'b010 : begin
						
						end
						
						3'b011 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 16;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(3) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 16;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
						
						3'b100 : begin
						
						end
						
						3'b101 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 16;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(7) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 16;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
						
						3'b110 : begin
						
						end
						
						3'b111 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 16;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(15) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 16;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
					endcase
		end
		
		3'b101 : begin                    //8-word line  256
		         while(!vif.hreadyout) begin
                    @(posedge vif.clk);
                end
				
		            case(master_txn.hburst)
					    3'b000 : begin                                          //single burst
						         vif.hsel      <= 1;
			                     vif.hwrite    <= master_txn.hwrite;
			                     vif.hmaster   <= master_txn.hmaster;
			                     vif.hmastlock <= master_txn.hmastlock;
			                     vif.htrans    <= 2'b10;
			                     vif.hsize     <= master_txn.hsize;
			                     vif.hburst    <= master_txn.hburst;
			                     vif.haddr     <= master_txn.haddr;
			                     vif.hwdata    <= master_txn.hwdata;
								 vif.hready    <= master_txn.hready;
								  @(posedge vif.hclk);
								 
						end
						
						3'b001 : begin                                         //increment	
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= 3'b000;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
									 @(posedge vif.hclk);
									 
									begin
								         master_txn.haddr  = master_txn.haddr  + 32;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
								 
								 
								 while(infinity_increment) begin
								       while(vif.hreadyout == 0 || 'z || 'x) begin
								           @(posedge vif.hclk);
								        end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								     @(posedge vif.hclk);
								     begin
								         master_txn.haddr  = master_txn.haddr  + 32;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end								 
								 end
								 
						end
						
						3'b010 : begin
						
						end
						
						3'b011 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 32;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(3) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 32;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
						
						3'b100 : begin
						
						end
						
						3'b101 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 32;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(7) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 32;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
						
						3'b110 : begin
						
						end
						
						3'b111 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 32;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(15) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 32;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
					endcase
		end
		
		3'b110 : begin                    //16-word line 512
		         while(!vif.hreadyout) begin
                    @(posedge vif.clk);
                end
				
		            case(master_txn.hburst)
					    3'b000 : begin                                          //single burst
						         vif.hsel      <= 1;
			                     vif.hwrite    <= master_txn.hwrite;
			                     vif.hmaster   <= master_txn.hmaster;
			                     vif.hmastlock <= master_txn.hmastlock;
			                     vif.htrans    <= 2'b10;
			                     vif.hsize     <= master_txn.hsize;
			                     vif.hburst    <= master_txn.hburst;
			                     vif.haddr     <= master_txn.haddr;
			                     vif.hwdata    <= master_txn.hwdata;
								 vif.hready    <= master_txn.hready;
								  @(posedge vif.hclk);
								 
						end
						
						3'b001 : begin                                         //increment	
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= 3'b000;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
									 @(posedge vif.hclk);
									 
									begin
								         master_txn.haddr  = master_txn.haddr  + 64;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
								 
								 
								 while(infinity_increment) begin
								       while(vif.hreadyout == 0 || 'z || 'x) begin
								           @(posedge vif.hclk);
								        end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								     @(posedge vif.hclk);
								     begin
								         master_txn.haddr  = master_txn.haddr  + 64;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end								 
								 end
								 
						end
						
						3'b010 : begin
						
						end
						
						3'b011 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 64;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(3) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 64;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
						
						3'b100 : begin
						
						end
						
						3'b101 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 64;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(7) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 64;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
						
						3'b110 : begin
						
						end
						
						3'b111 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 64;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(15) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 64;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
					endcase
		end
		
		3'b111 : begin                    //32-word line 1024
		         while(!vif.hreadyout) begin
                    @(posedge vif.clk);
                end
				
		            case(master_txn.hburst)
					    3'b000 : begin                                          //single burst
						         vif.hsel      <= 1;
			                     vif.hwrite    <= master_txn.hwrite;
			                     vif.hmaster   <= master_txn.hmaster;
			                     vif.hmastlock <= master_txn.hmastlock;
			                     vif.htrans    <= 2'b10;
			                     vif.hsize     <= master_txn.hsize;
			                     vif.hburst    <= master_txn.hburst;
			                     vif.haddr     <= master_txn.haddr;
			                     vif.hwdata    <= master_txn.hwdata;
								 vif.hready    <= master_txn.hready;
								  @(posedge vif.hclk);
								 
						end
						
						3'b001 : begin                                         //increment	
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= 3'b111;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
									 @(posedge vif.hclk);
									 
									begin
								         master_txn.haddr  = master_txn.haddr  + 128;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
								 
								 
								 while(infinity_increment) begin
								       while(!vif.hreadyout) begin
								           @(posedge vif.hclk);
								        end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								     @(posedge vif.hclk);
								     begin
								         master_txn.haddr  = master_txn.haddr  + 128;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end								 
								 end
								 
						end
						
						3'b010 : begin
						
						end
						
						3'b011 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 128;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(3) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 128;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
						
						3'b100 : begin
						
						end
						
						3'b101 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 128;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(7) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 128;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
						
						3'b110 : begin
						
						end
						
						3'b111 : begin
						        begin
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b10;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 end
								     @(posedge vif.hclk);
									 
									 begin
								         master_txn.haddr  = master_txn.haddr  + 128;
									     master_txn.hwdata = master_txn.hwdata + 10;
                                     end
							     
								 repeat(15) begin
								 while(!vif.hreadyout) begin
								    @(posedge vif.hclk);
								 end
								 
								     vif.hsel      <= 1;
			                         vif.hwrite    <= master_txn.hwrite;
			                         vif.hmaster   <= master_txn.hmaster;
			                         vif.hmastlock <= master_txn.hmastlock;
			                         vif.htrans    <= 2'b11;
			                         vif.hsize     <= master_txn.hsize;
			                         vif.hburst    <= master_txn.hburst;
			                         vif.haddr     <= master_txn.haddr;
			                         vif.hwdata    <= master_txn.hwdata;
									 vif.hready    <= master_txn.hready;
								 
								     @(posedge vif.hclk);
								 
								    master_txn.haddr  = master_txn.haddr  + 128;
									master_txn.hwdata = master_txn.hwdata + 10;
                                 								 
								 end
						end
					endcase
		end
		
		default : `uvm_error("DRIVER", "check hsize type")
		
		endcase
	endtask
	
	task basic_setups();
	    while(!vif.hresetn) begin
			 @(posedge vif.hclk);
		end
		
		while(vif.hreadyout != 1) begin
		     @(posedge vif.hclk);
		end
			
	    while(vif.hresp != 0) begin
			 @(posedge vif.hclk);
		end
	
	endtask
	
	task run_phase(uvm_phase phase);
	
		forever begin
		seq_item_port.get_next_item(master_txn);
        // `uvm_info("DRIVER",$sformatf("port connected to %0d export", seq_item_port.size()), UVM_MEDIUM)
			basic_setups();
			
			@(posedge vif.hclk);
			case(master_txn.htrans)
			    2'b00 : idle();
			    2'b01 : busy();
			    2'b10 : non_seq();
			    2'b11 : seq();
			endcase
		 
				
		seq_item_port.item_done();
		end
	endtask
	
	
endclass

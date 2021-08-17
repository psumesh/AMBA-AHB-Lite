class AHB_driver extends uvm_driver #(AHB_master_txn);

	`uvm_component_utils(AHB_driver)
	
	virtual intf vif;
	AHB_master_txn master_txn;
	
	function new(string name = "AHB_driver", uvm_component parent);
		super.new(name, parent);		
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual intf)::get(this, "", "vif", vif))
		   `uvm_error("DRIVER", "UVM CONFIG DB NOT FOUND!")
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
	endtask
	
	task non_seq();
	    while(!vif.hready) begin
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
			@(posedge vif.hclk)
			vif.hwdata    <= master_txn.hwdata;
	endtask
	
	task seq();
	    while(!vif.hready) begin
		    @(posedge vif.hclk);
		end
	endtask
	
	task run_phase(uvm_phase phase);
	
		forever begin
		seq_item_port.get_next_item(master_txn);
			@(negedge vif.hclk);
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

class AHB_monitor1 extends uvm_monitor;

	`uvm_component_utils(AHB_monitor1)
	
	function new(string name = "AHB_monitor1", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	AHB_master_txn master_txn;
	virtual intf vif;
	
	uvm_analysis_port#(AHB_master_txn) item_collected_port;
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual intf)::get(this,"","vif",vif))
		     `uvm_error("ACTIVE MONITOR", "CONFIG DB NOT FOUND!")
			 
		item_collected_port = new("item_collected", this);
	endfunction
	
	task run_phase(uvm_phase phase);
		master_txn = AHB_master_txn::type_id::create("master_txn", this);
		forever begin
		    #10
			master_txn.hsel      = vif.hsel;
			master_txn.hwrite    = vif.hwrite;
			master_txn.hmaster   = vif.hmaster;
			master_txn.hmastlock = vif.hmastlock;
			master_txn.htrans    = vif.htrans;
			master_txn.hsize     = vif.hsize;
			master_txn.hburst    = vif.hburst;
			master_txn.haddr     = vif.haddr;
			master_txn.hwdata    = vif.hwdata;
			master_txn.hready    = vif.hready;
			item_collected_port.write(master_txn);
			//`uvm_info("ACTIVE MONITOR", "TRANSACTIONS", UVM_NONE)
		end
	endtask

endclass

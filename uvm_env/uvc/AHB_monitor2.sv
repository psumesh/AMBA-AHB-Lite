class AHB_monitor2 extends uvm_monitor;

	`uvm_component_utils(AHB_monitor2)
	
	function new(string name = "AHB_monitor2", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	AHB_master_txn master_txn;
	virtual intf vif;
	
	uvm_analysis_port#(AHB_master_txn) item_collected_port;
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual intf)::get(this,"","vif",vif))
		     `uvm_error(get_name(), "CONFIG DB NOT FOUND!")
			 
		item_collected_port = new("item_collected", this);
	endfunction
	
	task run_phase(uvm_phase phase);
		master_txn = AHB_master_txn::type_id::create("master_txn", this);
		forever begin
		    #10
			master_txn.hreadyout = vif.hreadyout;
			master_txn.hresp     = vif.hresp;
			master_txn.hrdata    = vif.hrdata;

			item_collected_port.write(master_txn);
			//`uvm_info(get_name(), "TRANSACTIONS", UVM_NONE)
		end
	endtask

endclass

   `uvm_analysis_imp_decl(_from_monitor1)    
   `uvm_analysis_imp_decl(_from_monitor2)
   	

class AHB_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(AHB_scoreboard);
	
	AHB_master_txn t1_q[$];
	AHB_master_txn t2_q[$];


	uvm_analysis_imp_from_monitor1 #(AHB_master_txn, AHB_scoreboard) mon1_rec;
	uvm_analysis_imp_from_monitor2 #(AHB_master_txn, AHB_scoreboard) mon2_rec;
	
	function new(string name = "AHB_scoreboard", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon1_rec  = new("mon1_rec", this);
		mon2_rec  = new("mon2_rec", this);
	endfunction
	
	/*
   virtual function void write_from_monitor1(AHB_master_txn t1);
    `uvm_info(get_type_name(), $psprintf( "Received from monitor1" ), UVM_NONE)
	t1_q.push_back(t1);
   endfunction : write_from_monitor1
  
  
   virtual function void write_from_monitor2(AHB_master_txn t2);
    `uvm_info(get_type_name(), $psprintf( "Received from monitor2" ), UVM_NONE)
	t2_q.push_back(t2);
   endfunction : write_from_monitor2
	*/
	
	
	function void extract_phase(uvm_phase phase);
	
	endfunction
	
	function void check_phase(uvm_phase phase);
	
	endfunction
	
	function void report_phase(uvm_phase phase);
	
	endfunction
	

endclass
	
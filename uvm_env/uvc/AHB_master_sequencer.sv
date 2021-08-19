class AHB_master_sequencer extends uvm_sequencer #(AHB_master_txn);
	`uvm_component_utils(AHB_master_sequencer)

	function new(string name = "AHB_master_sequencer", uvm_component parent);
		super.new(name, parent);
	endfunction

endclass

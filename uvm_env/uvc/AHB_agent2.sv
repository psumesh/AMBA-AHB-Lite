class AHB_agent2 extends uvm_agent;

    `uvm_component_utils(AHB_agent2)
	
	AHB_monitor2  monitor2;
	
	
	function new(string name = "AHB_agent2", uvm_component parent);
	    super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		monitor2  = AHB_monitor2::type_id::create("monitor2", this);
	endfunction

endclass

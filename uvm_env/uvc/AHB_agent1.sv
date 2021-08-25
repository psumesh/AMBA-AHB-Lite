class AHB_agent1 extends uvm_agent;

    `uvm_component_utils(AHB_agent1)
	
	AHB_sequencer sequencer;
	AHB_driver    driver;
	AHB_monitor1  monitor1;
	
	
	function new(string name = "AHB_agent1", uvm_component parent);
	    super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
	    sequencer = AHB_sequencer::type_id::create("sequencer", this);
		driver    = AHB_driver::type_id::create("driver", this);
		monitor1  = AHB_monitor1::type_id::create("monitor1", this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		driver.seq_item_port.connect(sequencer.seq_item_export);
	endfunction

endclass

class AHB_env extends uvm_env;

    `uvm_component_utils(AHB_env)
	
	AHB_agent1 agent1;
	AHB_agent2 agent2;
	
	AHB_scoreboard scorebaord;
	AHB_subscriber coverage1;
	
	
	function new(string name = "AHB_env", uvm_component parent);
	    super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
	    agent1     = AHB_agent1::type_id::create("agent1", this);
		agent2     = AHB_agent2::type_id::create("agent2", this);
		scorebaord = AHB_scoreboard::type_id::create("scorebaord", this);
		coverage1  = AHB_subscriber::type_id::create("coverage1", this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agent1.monitor1.item_collected_port.connect(scorebaord.mon1_rec);
		agent2.monitor2.item_collected_port.connect(scorebaord.mon2_rec);
		agent1.monitor1.item_collected_port.connect(coverage1.analysis_export);
	endfunction

endclass

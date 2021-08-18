class AHB_test extends uvm_test;

	`uvm_component_utils(AHB_test)

	 AHB_env              env;
	 AHB_base_sequence    seq; 
	 
	 // set_config_int("sequencer", "num_inst",3);   syntax at test class
	 
	function new(string name = "AHB_test", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		env = AHB_env::type_id::create("env", this);
		seq = AHB_base_sequence::type_id::create("seq", this);
		
		seq.hsize_cfg  = 3'b100;
		seq.hburst_cfg = 3'b101;   //Byte, Halfword, Doubleword, 4-word line, 8-word line, 16-word line, 32-word line, 64-word line
		seq.initial_haddr = 50;
		
		set_config_string("env.agent1.sequencer", "str_hwrite",  "WR");            //WR, RD, WR_RD
		set_config_string("env.agent1.sequencer", "hwdata_cfg",  "random");        //random, increment, decrement
		//set_config_string("env.agent1.sequencer", "haddr_cfg",   "500");
		set_config_string("env.agent1.sequencer", "htrans_cfg",  "IDLE");          //IDLE, BUSY, NON_SEQ, SEQ
		
	endfunction
	
	task run_phase(uvm_phase phase);
		
		phase.raise_objection(this);
			seq.start(env.agent1.sequencer);
			#100;
		phase.drop_objection(this);
	endtask
	
endclass


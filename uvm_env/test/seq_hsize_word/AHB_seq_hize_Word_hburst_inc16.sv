class AHB_seq_hize_Word_hburst_inc16 extends uvm_test;

	`uvm_component_utils(AHB_seq_hize_Word_hburst_inc16)

	 AHB_env              env;
	 AHB_base_sequence    AHB_seq; 
	 
	function new(string name = "AHB_seq_hize_Word_hburst_inc16", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		env = AHB_env::type_id::create("env", this);
		AHB_seq = AHB_base_sequence::type_id::create("AHB_seq");
		
		set_config_string("env.agent1.sequencer", "str_hwrite",  "WR_RD");            //WR, RD, WR_RD
		set_config_string("env.agent1.sequencer", "hwdata_cfg",  "random");        //random, increment, decrement
		set_config_string("env.agent1.sequencer", "htrans_cfg",  "SEQ");          //IDLE, BUSY, NON_SEQ, SEQ
		
		AHB_seq.hsize_cfg  = 3'b010;
		AHB_seq.hburst_cfg = 3'b111;   //Byte, Halfword, word, Doubleword, 4-word line, 8-word line, 16-word line, 32-word line, 64-word line
		AHB_seq.initial_haddr = 50;
		
		
	endfunction
	
	task run_phase(uvm_phase phase);
	    env.agent1.driver.data_type = "INCREMENT";
		
		phase.raise_objection(this);
			AHB_seq.start(env.agent1.sequencer);
			#50;
		phase.drop_objection(this);
	endtask
	
endclass


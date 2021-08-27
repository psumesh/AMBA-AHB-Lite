import uvm_pkg::*;

`include "uvm_macros.svh"
`include "AHB_interface.sv"
`include "ahblite_slave1.v"
`include "pkg_hwdata.sv"
`include "AHB_master_txn.sv"
`include "AHB_sequencer.sv"
`include "AHB_driver.sv"
`include "AHB_monitor1.sv"
`include "AHB_monitor2.sv"
`include "AHB_agent1.sv"
`include "AHB_agent2.sv"
`include "AHB_subscriber.sv"
`include "AHB_scoreboard.sv"
`include "AHB_env.sv"
`include "AHB_base_sequence.sv"
`include "AHB_test.sv"
`include "AHB_test_non_seq_WR_RD.sv"


module top;
	 
	bit hclk;
	bit hresetn;
   
   
	always #5 hclk = ~hclk;
 

  	initial begin
		    hresetn = 1'b0;
		#20 hresetn = 1'b1;
	end
	
	wire temp;
	
	
	 
	 intf vif(hresetn, hclk);
	 
	 ahb_s1 dut(vif.hsel, vif.haddr, vif.hwrite, vif.hsize, vif.htrans, vif.hburst, vif.hready, 
	            vif.hwdata, vif.hreadyout, vif.hresp, vif.hrdata, hresetn, hclk);

	initial begin

		uvm_config_db#(virtual intf) :: set(null, "*", "vif", vif);
			 run_test("AHB_test");
	end
	
	initial begin
        $dumpfile("AHB_waveform.vcd");
        $dumpvars(0, top, vif, dut);
    end
	


/* 
    initial begin          //for cadence xcelium/ncverilog waveform dump
          $shm_open("AHB_waves.shm"); 
		  $shm_probe("AS");
	end
*/
	 
endmodule
	 
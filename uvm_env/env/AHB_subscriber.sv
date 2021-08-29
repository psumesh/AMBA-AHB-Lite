class AHB_subscriber extends uvm_subscriber #(AHB_master_txn);

    `uvm_component_utils(AHB_subscriber)

     AHB_master_txn AHB_txn;
	 real cov_percentage_report1;
	 real cov_percentage_report2;

     covergroup seq_cov;
         option.per_instance = 1;
		 option.name         = "coverage for seq_cov";
		 
        write_mode : coverpoint AHB_txn.hwrite{
		      bins write1 = {0, 1};
		}
		
		htrans_mode : coverpoint AHB_txn.htrans{
		     bins htrans1 = {[0:3]};
			 
		}
		
		hsize_mode : coverpoint AHB_txn.hsize{
		             bins hsize1 = {[0:5]};
			 illegal_bins hsize2 = {6, 7};
		}
		
		hburst_mode : coverpoint AHB_txn.hburst{
		      bins hburst1 = {[0:7]};
		}
		
		haddr_mode : coverpoint AHB_txn.haddr{
		      bins haddr1 = {[0    : 100]};
			  bins haddr2 = {[100  : 1000]};
			  bins haddr3 = {[1000 : 10000]};
		}
		
		hwdata_mode : coverpoint AHB_txn.hwdata{
		      bins hwdata1 = {[0    :100]};
			  bins hwdata2 = {[100  : 1000]};
			  bins hwdata3 = {[1000 : 10000]};
			  ignore_bins hwdata4 = {[10001:$]};
		}
		
     endgroup

     covergroup non_seq_cov;
         option.per_instance = 1;
		 option.name         = "coverage for non_seq_cov";
		 
        write_mode : coverpoint AHB_txn.hwrite{
		      bins write1 = {0, 1};
		}
		
		htrans_mode : coverpoint AHB_txn.htrans{
		     bins htrans1 = {2};
			 ignore_bins htrans2 = {0, 1, 3};
			 
		}
		
		hsize_mode : coverpoint AHB_txn.hsize{
		             ignore_bins hsize1 = {[0:5]};
					 illegal_bins hsize2 = {6, 7};
		}
		
		hburst_mode : coverpoint AHB_txn.hburst{
		      bins hburst1 = {[0:7]};
		}
		
		haddr_mode : coverpoint AHB_txn.haddr{
		      bins haddr1 = {[0    : 100]};
			  bins haddr2 = {[100  : 1000]};
			  bins haddr3 = {[1000 : 10000]};
		}
		
		hwdata_mode : coverpoint AHB_txn.hwdata{
		      bins hwdata1 = {[0    : 100]};
			  bins hwdata2 = {[100  : 1000]};
			  bins hwdata3 = {[1000 : 10000]};
			  ignore_bins hwdata4 = {[10001:$]};
		}
		
     endgroup


	
     function new(string name = "AHB_subscriber", uvm_component parent);
         super.new(name, parent);	
	     seq_cov = new();
         non_seq_cov = new(); 		 
     endfunction

     function void build_phase(uvm_phase phase);
     endfunction

	 
     function void write(AHB_master_txn t);
               AHB_txn = t;
			   seq_cov.sample();
			   non_seq_cov.sample();
     endfunction

     function void extract_phase(uvm_phase phase);
	        cov_percentage_report1 = seq_cov.get_coverage();
			cov_percentage_report2 = non_seq_cov.get_coverage();
	 endfunction
	 
	 function void report_phase(uvm_phase phase);
	    `uvm_info(get_type_name(), $sformatf("Coverage is: %f", cov_percentage_report1), UVM_MEDIUM)
		`uvm_info(get_type_name(), $sformatf("Coverage is: %f", cov_percentage_report2), UVM_MEDIUM)
	 endfunction

     

endclass

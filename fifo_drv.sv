class fifo_drv extends uvm_driver#(fifo_transaction);
  virtual interface fifo_itf vif;
  `uvm_component_utils(fifo_drv)
  
    function new(string name,uvm_component parent);
      super.new(name,parent);
    
  	endfunction
  
  function void build_phase(uvm_phase phase);
//     $display("Build Phase of driver");
    `uvm_info("fifo","Driver Build Phase",UVM_MEDIUM);
    super.build_phase(phase);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual fifo_itf)::get(null,"fifo","vif",vif)) `uvm_fatal("death","failed to get interface")
  endfunction
      
    task run_phase(uvm_phase phase);
    	fifo_transaction ft;
    	vif.A=0;
    	vif.wr=0;
    	vif.rd = 0;
    	vif.rst =0;
    	vif.full = 0;
    	vif.empty = 0;
    	
    	forever begin
          seq_item_port.get_next_item(ft);
          @(posedge vif.clk);
         	 vif.rst = ft.rst;
         	 vif.A= ft.A;
         	 vif.wr = ft.wr;
          	 vif.rd = ft.rd;
          
          
          
          seq_item_port.item_done();
        end
    
    endtask
  
endclass
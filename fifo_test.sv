class fifo_test extends uvm_test;
 `uvm_component_utils(fifo_test)
  
  fifo_env env;
  fifo_seq seq;
  
  function new(string name, uvm_component parent); 
    super.new(name, parent);
  endfunction
    
    function void build_phase(uvm_phase phase);
      `uvm_info("fifo","Test Build Phase",UVM_MEDIUM);    
      super.build_phase(phase);
      env = fifo_env::type_id::create("env",this);
    endfunction
      
    task run_phase(uvm_phase phase);
      `uvm_info("fifo","Test Run Phase",UVM_MEDIUM);
      phase.raise_objection(this);
      seq = fifo_seq::type_id::create("seq",this);
      seq.start(env.sqr);
      #50;
      phase.drop_objection(this);
    endtask

endclass:fifo_test
     
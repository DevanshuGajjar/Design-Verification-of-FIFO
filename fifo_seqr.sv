
class fifo_seqr extends uvm_sequencer #(fifo_transaction);
  `uvm_component_utils(fifo_seqr)
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass
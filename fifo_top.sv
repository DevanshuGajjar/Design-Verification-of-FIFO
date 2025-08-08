interface fifo_itf #(parameter width=4)(input logic clk);
//   logic clk;
  logic rst;
  logic [width-1:0] w_data;
  logic wr;
  logic rd;
  logic [width-1:0] r_data;
  logic full;
  logic empty;
  
endinterface

//`include "uvm_macros.svh"
// `include "interface.sv"
`include "fifo_pkg.sv"
import uvm_pkg::*;
import fifo_pkg::*;

module fifo_top();
	
  bit clk;
  fifo_itf vif(clk);
  
  initial begin
    clk = 1'b0;
  end
  
  
  always begin
    #5clk = ~clk;
  end 
  
  initial begin
    $display("starting run test fifo");
    uvm_config_db #(virtual fifo_itf)::set(null,"*","vif",vif);
    run_test("fifo_test");
  end
  
   fifo f1 (
    .clk(vif.clk),
    .rst(vif.rst),
    .w_data(vif.w_data),
    .wr(vif.wr),
    .rd(vif.rd),
    .r_data(vif.r_data),
    .full(vif.full),
    .empty(vif.empty)
  );  
  
  initial begin
    $dumpvars();
    $dumpfile("data.vcd");
  end
  
endmodule:fifo_top
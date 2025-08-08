`include "uvm_macros.svh"
package fifo_pkg;

import uvm_pkg::*;
`include "fifo_trans.sv"
`include "fifo_seq.sv"
`include "fifo_seqr.sv"
`include "fifo_drv.sv"
`include "fifo_mon.sv"
`include "fifo_scoreboard.sv"
`include "fifo_env.sv"
`include "fifo_test.sv"

endpackage
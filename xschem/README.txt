CPLZ-LS01 xschem capture -- GENERATED from cplz_ls01_ltspice.cir
================================================================
cplz_ls01/        one .sch + .sym per subckt, plus tb_channel.sch
sg13cmos5l_pr/    STUB device symbols (same names, pin order d g s b and
                  netlist format as the PDK primitives Tim's repos use).
                  In IIC-OSIC-TOOLS, delete this dir and let xschemrc
                  resolve sg13cmos5l_pr/ from the installed PDK instead.

Connectivity is by net label (lab_pin on every terminal) -- correct by
construction, ugly by construction. Beautify against Figure 6 of the doc:
same net names, same hierarchy. The testbench sheet embeds placeholder
models; swap the code block for the PDK .lib lines for signoff.
Verify after any edit:  xschem -x -n -q -o . cplz_ls01/tb_channel.sch
then ngspice -b tb_channel.spice

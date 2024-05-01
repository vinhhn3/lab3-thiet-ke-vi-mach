fsm_110:
	vhdlan -kdb -nc ../src/mealy_110_detector.vhd 
	vhdlan -kdb -nc ../src/moore_110_detector.vhd 
	vhdlan -kdb -nc ../tb/fsm_110_detector_tb.vhd 
	vcs -nc -kdb -debug_access+all fsm_110_detector_tb
	./simv -nc -ucli -do scripts/fsm_110_detector_tb.tcl
	verdi -nc -warn none -ssf fsm_110_detector_tb.fsdb
.PHONY: clean
clean:
	-rm -rf 64 csrc simv simv.* ucli.key novas* verdi* DVE* work.lib* *.fsdb

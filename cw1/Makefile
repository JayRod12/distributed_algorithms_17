### Jaime Rodriguez (jr1713) 

#MAKE = make
.PHONY:	all sys1 sys2 sys3 sys4 sys5 clean

all:	sys1 sys2 sys3 sys4 sys5 sys6

sys1:
	+$(MAKE) -C sys1
sys2:
	+$(MAKE) -C sys2
sys3:
	+$(MAKE) -C sys3
sys4:
	+$(MAKE) -C sys4
sys5:
	+$(MAKE) -C sys5
sys6:
	+$(MAKE) -C sys6

clean:
	rm -r **/ebin

run1:		all
	+$(MAKE) run -C sys1

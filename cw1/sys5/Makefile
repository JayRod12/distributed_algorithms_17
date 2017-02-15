### Jaime Rodriguez (jr1713)

.SUFFIXES:	.erl .beam

MODULES		= system5 process5 app lossy_p2p_links best_effort_broadcast

ERLC			= erlc -o ebin

ebin/%.beam:	%.erl
	$(ERLC) $<

all:	ebin ${MODULES:%=ebin/%.beam}


ebin:
	mkdir ebin

debug:
	erl -s crashdump_viewer start

.PHONY:	clean
clean:	rm -f ebin/* erl_crash.dump

SYSTEM 	= system5
L_ERL			= erl -noshell -pa ebin -setcookie pass -run

processes ?= 5
messages 	?= 1000
timeout 	?= 3000
kill 			?= 0
killtimeout	?= 5

run: 	all
	$(L_ERL) $(SYSTEM) start $(processes) $(messages) $(timeout) $(kill) $(killtimeout)


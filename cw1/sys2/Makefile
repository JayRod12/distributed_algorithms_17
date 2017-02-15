### Jaime Rodriguez (jr1713)

.SUFFIXES:	.erl .beam

MODULES		= system2 process2 app perfect_p2p_links

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

SYSTEM 	= system2
L_ERL			= erl -noshell -pa ebin -setcookie pass -run

processes ?= 5
messages 	?= 1000
timeout 	?= 3000

run: 	all
	$(L_ERL) $(SYSTEM) start $(processes) $(messages) $(timeout)


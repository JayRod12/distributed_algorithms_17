### Jaime Rodriguez (jr1713)

.SUFFIXES:	.erl .beam

MODULES		= system1 process1

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

SYSTEM1 	= system1
L_ERL			= erl -noshell -pa ebin -setcookie pass -run

processes ?= 5
messages 	?= 1000
timeout 	?= 3000

run: 	all
	$(L_ERL) $(SYSTEM1) start $(processes) $(messages) $(timeout)


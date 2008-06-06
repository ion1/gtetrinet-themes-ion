sources := blocks.xcf
targets := $(sources:%.xcf=%.png)
dist    := README theme.cfg

gimp := gimp -nidfc

all : $(targets)

%.png : %.xcf convert-to-png.scm.in
	sed -re 's/%SOURCE%/$</g; s/%TARGET%/$@/g' convert-to-png.scm.in | \
	  $(gimp) -b -

.PHONY : dist
dist : ../ion.tar.gz
	@printf "dist: %s\n" "$<"

../ion.tar.gz : $(targets) $(dist)
	$(RM) -r dist

	install -m0755 -d dist/ion
	install -m0644 -t dist/ion $^
	tar zcf "$@" -C dist ion

	$(RM) -r dist

.PHONY : clean
clean ::
	$(RM) -r dist
	$(RM) $(targets)

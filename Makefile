sources := blocks.xcf
targets := $(sources:%.xcf=%.png)
dist    := README theme.cfg

release := 0.1
tarball := ion-$(release).tar.gz

gimp := gimp -nidfc

all : $(targets)

%.png : %.xcf convert-to-png.scm.in
	sed -re 's/%SOURCE%/$</g; s/%TARGET%/$@/g' convert-to-png.scm.in | \
	  $(gimp) -b -

.PHONY : dist
dist : ../$(tarball)
	@printf "dist: %s\n" "$<"

../$(tarball) : $(targets) $(dist)
	$(RM) -r dist

	@if ! pristine-tar checkout "$@"; then \
	  printf "No preexisting release, creating one...\n" && \
	  install -m0755 -d dist/ion &&  \
	  install -m0644 -t dist/ion $^ && \
	  tar zcf "$@" -C dist ion && \
	  pristine-tar commit "$@" master; fi

	$(RM) -r dist

.PHONY : clean
clean ::
	$(RM) -r dist
	$(RM) $(targets)

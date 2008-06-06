sources := blocks.xcf
targets := $(sources:%.xcf=%.png) theme.cfg
dist    := README theme.cfg

release := 0.1
tarball := ion-$(release).tar.gz

gimp := gimp -nidfc

all : $(targets)

%.png : %.xcf convert-to-png.scm.in
	sed -re 's/%SOURCE%/$</g; s/%TARGET%/$@/g' convert-to-png.scm.in | \
	  $(gimp) -b -
	@printf "\n"  # Gimp likes to leave \n out from the last line.

theme.cfg : theme.cfg.in
	sed -re 's/%RELEASE%/$(release)/g' "$<" >"$@"

.PHONY : dist
dist : ../$(tarball)
	@printf "dist: %s\n" "$<"

../$(tarball) : $(targets) $(dist)
	$(RM) -r dist

	@if ! pristine-tar checkout "$@"; then \
	  printf "No preexisting release, creating one...\n" && \
	  install -m0755 -d dist/ion-$(release) &&  \
	  install -m0644 -t dist/ion-$(release) $^ && \
	  tar zcf "$@" -C dist ion-$(release) && \
	  pristine-tar commit "$@" master; fi

	$(RM) -r dist

.PHONY : clean
clean ::
	$(RM) -r dist
	$(RM) $(targets)

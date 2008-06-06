sources := blocks.xcf
targets := $(sources:%.xcf=%.png)

gimp := gimp -nidfc

all : $(targets)

%.png : %.xcf convert-to-png.scm.in
	sed -re 's/%SOURCE%/$</g; s/%TARGET%/$@/g' convert-to-png.scm.in | \
	  $(gimp) -b -

.PHONY : clean
clean ::
	$(RM) $(targets)

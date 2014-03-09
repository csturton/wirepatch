EXE_OBJS = hw
all: $(EXE_OBJS)

CC = or32-linux-gcc
OBJDUMP = or32-linux-objdump
CPPFLAGS = -g -I/opt/or32-linux/include
LDFLAGS =  -L/opt/or32-linux/lib
#LFLAGS = -Ttext=0x08000000

OBJS = main.o bug3.o bug1.o bug4.o bug5.o

-include $(OBJS:.o=.d)

hw: $(OBJS)	
	$(CC) $(CPPFLAGS) $(LDFLAGS) -o $@ $(OBJS)
	$(OBJDUMP) -D $@ > $@.asm	

%.d: %.c
	@echo "Calculating dependencies of $<..."
	@set -e; $(CC) -MM $(CFLAGS) $< \
		| sed 's/\($*\)\.o[ :]*/\1.o $@ : /g' > $@; 
	@[ -s $@ ] || rm -f $@


%.o: %.c
	$(CC) $(CPPFLAGS) -c $< -o $@

%.o: %.S
	$(CC) $(CPPFLAGS) -c $< -o $@

clean:
	rm -f *.d *.o *.asm *~ $(EXE_OBJS)

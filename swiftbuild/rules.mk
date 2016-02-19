include $(TOPSRCDIR)/swiftbuild/checkconfig.mk

ifndef OBJS
_OBJS = $(patsubst %.swift,%.o,$(SOURCES))
OBJS    = $(strip $(_OBJS))
endif

ifdef APP_NAME
OBJS += main.o
endif

IMPORTS += -I $(OBJDIR)/modules

build: dirs $(OBJS)
ifdef DIRS
endif # DIRS
		$(shell mkdir -p $(OBJDIR)/modules)
ifdef MODULE_NAME
ifdef SOURCES
		# building lib$(MODULE_NAME).dylib and $(MODULE_NAME).swiftmodule
		@$(SWIFTC) $(CFLAGS) $(IMPORTS) -emit-library -emit-module -emit-module-path $(OBJDIR)/modules/$(MODULE_NAME).swiftmodule -module-name $(MODULE_NAME) -L $(OBJDIR) $(LIBS) -sdk $(SDK_PATH) $(SOURCES)
		# fixing rpath in lib$(MODULE_NAME).dylib
	  @install_name_tool -id @rpath/lib$(MODULE_NAME).dylib lib$(MODULE_NAME).dylib
		# installing lib$(MODULE_NAME).dylib in $(OBJDIR)
		@install lib$(MODULE_NAME).dylib $(OBJDIR)
endif # SOURCES
endif # MODULE_NAME
ifdef APP_NAME
		# creating executable $(APP_NAME) in $(OBJDIR)
		@$(LD) $(LDFLAGS) -o $(OBJDIR)/main -L$(TOOLCHAIN_PATH) -Lbin $(LIBS) -rpath @executable_path main.o
		# DONE!
endif #APP_NAME

dirs: $(DIRS)
		@for d in $(DIRS); do (cd $$d; $(MAKE) build ); done

%.o: %.swift
		#   building $(shell echo "$*.swift")
		@$(SWIFT) $(CFLAGS) $(IMPORTS) -primary-file $*.swift \
			$(filter-out $*.swift,$(SOURCES)) -sdk $(SDK_PATH) \
			-module-name $(MODULE_NAME) -o $*.o -emit-module \
			-emit-module-path $*~partial.swiftmodule

main.o: main.swift
		# building main.swift
		@$(SWIFT) $(CFLAGS) $(IMPORTS) -emit-object -o main.o -sdk $(SDK_PATH) main.swift

clean:
		$(shell rm -fr  _obj *.o *~partial.swiftmodule lib$(MODULE_NAME).dylib*)
ifdef DIRS
		@for d in $(DIRS); do (cd $$d; $(MAKE) clean ); done
endif

OBJDIR              = $(TOPSRCDIR)/bin
PLATFORM            = macosx
ARCH                = x86_64

SWIFTC              = $(shell xcrun -f swiftc)
SWIFT               = $(shell xcrun -f swift) -frontend -c -color-diagnostics
SDK_PATH            = $(shell xcrun --show-sdk-path -sdk $(PLATFORM))
SDK_VERSION         = $(shell xcrun --show-sdk-version -sdk $(PLATFORM))

TOOLCHAIN           = Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/$(PLATFORM)
TOOLCHAIN_PATH      = $(shell xcode-select --print-path)/$(TOOLCHAIN)

CFLAGS       = -g -O

## LINKER SETTINGS ##
LD           = $(shell xcrun -f ld)
LDFLAGS      = -syslibroot $(SDK_PATH) -lSystem -arch $(ARCH) \
               -macosx_version_min $(SDK_VERSION) \
               -no_objc_category_merging -L $(TOOLCHAIN_PATH) \
               -rpath $(TOOLCHAIN_PATH)

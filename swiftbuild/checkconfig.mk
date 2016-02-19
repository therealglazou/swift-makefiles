ifdef MODULE_NAME
ifndef SOURCES
$(error $(PWD): MODULE_NAME defined but no SOURCES to build)
endif
endif 

ifdef SOURCES
ifndef MODULE_NAME
$(error $(PWD): SOURCES defined but no MODULE_NAME specified)
endif
endif 


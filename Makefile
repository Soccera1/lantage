# Simple Makefile for Lantage

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin

.PHONY: all install uninstall

all:
	@echo "Usage: make [install|uninstall]"

install:
	@echo "Installing lantage scripts to $(BINDIR)..."
	@install -d -m 755 "$(DESTDIR)$(BINDIR)"
	@install -m 755 lantage "$(DESTDIR)$(BINDIR)/lantage"
	@install -m 755 lantaged "$(DESTDIR)$(BINDIR)/lantaged"
	@echo "Installation complete."

uninstall:
	@echo "Uninstalling lantage scripts from $(BINDIR)..."
	@rm -f "$(DESTDIR)$(BINDIR)/lantage"
	@rm -f "$(DESTDIR)$(BINDIR)/lantaged"
	@echo "Uninstallation complete."

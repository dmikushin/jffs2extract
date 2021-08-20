all: jffs2extract
	
jffs2extract: jffs2extract.o minilzo.o lzo_crc.o
	$(CC) $^ -o $@ -lz

%.o: %.c
	$(CC) -g -O3 -c -Iinclude $< -o $@

VMLINUZ_SHA256=8544797b46641ed31f31523071de8f01443e0d52e3b39f0e5f1991fdbb0de092

verify: jffs2extract
	@./jffs2extract -x -f sample.jffs2 && \
	VMLINUZ_SHA256="$$(sha256sum vmlinuz | cut -d ' ' -f1)" && \
	if [ "$$VMLINUZ_SHA256" = "$(VMLINUZ_SHA256)" ]; then echo "Verification OK"; else echo "Verification failed"; false; fi

install: jffs2extract
	install -m 0755 jffs2extract /usr/bin

clean:
	rm -f jffs2extract.o minilzo.o jffs2extract

.PHONY: clean install

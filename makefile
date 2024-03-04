remake:
	-$(MAKE) clean
	$(MAKE) ls

ls:
	nasm -f elf64 ls.asm
	ld -m elf_x86_64 ls.o -o ls

clean:
	rm ls.o ls

.PHONY:
	remake clean
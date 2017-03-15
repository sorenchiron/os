target=test
source_suffix=s
img=$(target)
bs=512
count=1
target_src=$(target).$(source_suffix)
svname=$(target_src)
svdir=learning

csrc=$(target).c
cout=bin.o

all: $(target_src) $(img).img
	nasm $(target_src) -o $(target).o
	dd if=$(target).o of=$(img).img bs=$(bs) count=$(count) conv=notrunc

boot: cc dd
	@echo 'build success'

archive: $(target_src)
	rm $(svdir)/$(svname)
	cp ./$(target_src) $(svdir)/$(svname)
	rm $(target_src) $(target).o

nasmpie: $(target_src)
	nasm -f macho $(target_src) -o $(target).o

ccpie: $(csrc)
	cc -m32 $(csrc) -c -O0 -fPIC

ld: $(target)
	ld -static -r $(target) -o $(cout)

dd: $(img).img
	dd if=$(target).o of=$(img).img bs=$(bs) count=$(count) conv=notrunc

cc: $(csrc)
	cc -m16 $(csrc) -S -O0 -fPIC -ffreestanding
	as -arch i386 $(target).s -o $(target).o -O0
	cp $(target).o $(target)_mid.o
	otool -l $(target)_mid.o > tmp.txt
	dd if=$(target)_mid.o of=$(target).o iseek=`python strip.py tmp.txt` bs=1 count=3000
	rm tmp.txt
	@echo 'locating int08 function entry...'
	@echo '----------------------'
	@objdump -D syscall_mid.o | grep 'int08>:'
	@echo '----------------------'

clean:
	rm $(target).o

help:
	@echo Usage: make [objective] [param=val,]
	@echo targets are one of the followings:
	@echo all,boot,archive,nasmpie,ccpie,ld,c,clean
	@echo "--------------------------------------"
	@echo 'target:source file prefix (default:test)'
	@echo 'source_suffix:file suffix (s)'
	@echo 'img:image name prefix? (test)'
	@echo 'bs: bs option of \"dd\" command (512)'
	@echo 'count: count option of dd command (1)'
	@echo 'cout: (bin.o)'
	@echo 'svname: savename=target.suffix (test.s)'
	@echo 'svdir: savedir=learning'
	@echo '@by Chen Siyu'


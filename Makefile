all:
	fteqcc64 ./csqc/progs.src
	fteqcc64 ./ssqc/progs.src
	cp ./csprogs.dat /home/danni/Games/quake-team-fortress-server/qwmoba/csprogs.dat
	cp ./qwprogs.dat /home/danni/Games/quake-team-fortress-server/qwmoba/qwprogs.dat

clean:
	rm -f $(TARGET) qwprogs.lno files.dat progdefs.h

all: main.exe

main.exe:
	g++ -std=c++11 main.cc -o main.exe
	chmod +x main.exe

.PHONY: run
run: main.exe
	@./main.exe

.PHONY: clean
clean:
	@rm main.exe 2>/dev/null || true

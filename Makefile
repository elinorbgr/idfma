PATH := node_modules/.bin:$(PATH)
ELM_SOURCES := $(shell find src -name \*.elm -print)

default: build

install-deps:
	which elm || npm install elm
	which elm-css || npm install elm-css
	elm package install -y

build: main.js main.css

main.js: $(ELM_SOURCES)
	elm make src/Main.elm --yes --output=main.js

main.css: src/Style.elm
	elm css src/Stylesheets.elm

clean:
	rm main.js main.css

purge:
	rm -rf node_modules elm-stuff main.js main.css

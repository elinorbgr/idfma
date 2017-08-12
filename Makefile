
install-deps:
	npm install -g elm elm-css
	elm package install

build: main.js main.css

main.js: src/*.elm
	elm make src/Main.elm --output=main.js

main.css: src/Style.elm
	elm css src/Stylesheets.elm


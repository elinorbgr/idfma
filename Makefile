
install-deps:
	npm install -g elm-css
	elm package install -y

build: main.js main.css

main.js: src/*.elm
	elm make src/Main.elm --yes --output=main.js

main.css: src/Style.elm
	elm css src/Stylesheets.elm


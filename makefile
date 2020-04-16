all:
	docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex -V lang="es" --metadata-file=metadata.yaml --toc -V colorlinks -V linkcolor=blue -s -o PEC.pdf PEC_1.md
clean:
	rm PEC.pdf
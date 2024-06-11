help:
	@echo "Liste des commandes disponibles :"
	@grep -E '^[1-9a-zA-Z_-]+(\.[1-9a-zA-Z_-]+)?:.*?## .*$$|(^#--)' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m %-43s\033[0m %s\n", $$1, $$2}' \
	| sed -e 's/\[32m #-- /[33m/'

#-- GIT
push: ## Push les modifications avec un nouveau tag
	@echo "\033[1;31mN'oubliez pas de modifier la version dans le fichier ./homebrew-optimize/optimize.rb\033[0m"
	@read -p "Entrez le message du commit : " message; \
	git add .; \
	git commit -m "$$message"; \
	git push; \
	read -p "Entrez le numéro de version : " version; \
	git tag -a $$version -m "Version $$version"; \
	git push --tags; \
	cd ./homebrew-taps && git add . && git commit -m "Version $$version" && git push; \
	echo "\033[1;32mPush terminé\033[0m"

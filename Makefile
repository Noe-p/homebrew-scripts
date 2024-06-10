help:
	@echo "Liste des commandes disponibles :"
	@grep -E '^[1-9a-zA-Z_-]+(\.[1-9a-zA-Z_-]+)?:.*?## .*$$|(^#--)' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m %-43s\033[0m %s\n", $$1, $$2}' \
	| sed -e 's/\[32m #-- /[33m/'

#-- GIT
push: ## Push les modifications avec un nouveau tag
	@echo "N'oubliez pas de modifier la version dans le fichier ./homebrew-optimize/optimize.rb"

	@cd ./homebrew-optimize/
	git add .
	git commit -m "$message"
	git push
	@cd ../
	@echo "Push terminé"
	
	

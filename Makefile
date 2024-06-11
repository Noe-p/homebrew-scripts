help:
	@echo "Liste des commandes disponibles :"
	@grep -E '^[1-9a-zA-Z_-]+(\.[1-9a-zA-Z_-]+)?:.*?## .*$$|(^#--)' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m %-43s\033[0m %s\n", $$1, $$2}' \
	| sed -e 's/\[32m #-- /[33m/'

#-- GIT
push: ## Push les modifications avec un nouveau tag
	@echo "\033[1;31mN'oubliez pas de modifier la version dans le fichier ./homebrew-taps/\033[0m"
	@read -p "Entrez le message du commit : " message; \
	git add .; \
	git commit -m "$$message"; \
	git push; \
	read -p "Entrez le numéro de version : " version; \
	git tag -a $$version -m "Version $$version"; \
	git push --tags; \
	cd ./homebrew-taps && git add . && git commit -m "Version $$version" && git push; \
	echo "\033[1;32mPush terminé\033[0m"

#-- FORMULA
new: ## Crée une nouvelle formule Homebrew
	@printf "\033[1;33mEntrez le nom de la commande : \033[0m"; \
	read name; \
	printf "\033[1;33mEntrez la description de la commande : \033[0m"; \
	read description; \
	class_name=$$(echo $$name | awk '{print toupper(substr($$0,1,1)) tolower(substr($$0,2))}'); \
	version="v1.0.0"; \
	echo "class $$class_name < Formula" > homebrew-taps/$$name.rb; \
	echo "  desc \"$${description}\"" >> homebrew-taps/$$name.rb; \
	echo "  homepage \"https://github.com/Noe-p/homebrew-scripts\"" >> homebrew-taps/$$name.rb; \
	echo "  url \"https://github.com/Noe-p/homebrew-scripts.git\", :tag => \"$$version\"" >> homebrew-taps/$$name.rb; \
	echo "  license \"MIT\"" >> homebrew-taps/$$name.rb; \
	echo "" >> homebrew-taps/$$name.rb; \
	echo "  depends_on \"imagemagick\"" >> homebrew-taps/$$name.rb; \
	echo "" >> homebrew-taps/$$name.rb; \
	echo "  def install" >> homebrew-taps/$$name.rb; \
	echo "    bin.install \"$$name.sh\" => \"$$name\"" >> homebrew-taps/$$name.rb; \
	echo "  end" >> homebrew-taps/$$name.rb; \
	echo "" >> homebrew-taps/$$name.rb; \
	echo "  test do" >> homebrew-taps/$$name.rb; \
	echo "    system \"#{bin}/$$name\", \"--help\"" >> homebrew-taps/$$name.rb; \
	echo "  end" >> homebrew-taps/$$name.rb; \
	echo "end" >> homebrew-taps/Formula/$$name.rb; \
	printf "\033[1;32mFormule créée avec succès : homebrew-taps/$$name.rb\033[0m\n"

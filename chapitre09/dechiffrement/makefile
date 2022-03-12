AS    = as
LD    = ld
ENTRY = main
NAME  = dechiffrer

all: $(NAME)
	@echo "Veuillez exécuter: ./$(NAME)"

$(NAME): $(NAME).o
	@echo -n "Édition des liens... "
	@$(LD) $(NAME).o -o $(NAME) -e $(ENTRY) -lc
	@echo "OK."

$(NAME).o: $(NAME).s
	@echo -n "Assemblage... "
	@$(AS) -gstabs $(NAME).s -o $(NAME).o
	@echo "OK."

clean:
	@echo -n "Nettoyage... "
	@rm -f *.o $(NAME)
	@echo "OK."

# Charger la grille
entree=`cat $1`
taille=`echo "$entree" | head -n 1`
grille=`echo "$entree" | tail -n +2`

while true
do
    # Substituer les bits de la grille par des carrés
    grille_=$grille
    grille_=${grille_//0/□}
    grille_=${grille_//1/■}

    # Afficher la grille et évaluer la prochaine itération
    grille=`echo "$taille $grille" | ./vie`
    clear
    echo "$grille_"
    sleep 0.1
done

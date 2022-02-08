# Multiplication d'entiers signés

Rappelons qu'en classe nous avons vu un algorithme «simple» afin de multiplier deux entiers signés _x_
et _y_ de _n_ bits:

1. Étendre _x_ et _y_ à _2n_ bits en répétant _n_ fois leur bit de signe respectif;
2. Multiplier ces deux nombres comme s'ils étaient non signés;
3. Tronquer le résultat aux _2n_ bits de poids faible.

Il s'agit de l'algorithme que vous avez implémenté au labo 2.

Nous allons maintenant démontré que cet algorithme est correct, c'est-à-dire qu'il retourne toujours la bonne sortie.
Nous considérons deux cas: celui où y ≥ 0, qui est plus simple, puis celui où y < 0, qui est plus complexe (pour être
honnête: aucun des cas n'est vraiment simple!)

## Cas où y ≥ 0

Similairement au cas non signé, nous avons
_x · y = x · (y<sub>0</sub> · 2<sup>0</sup> + ... + y<sub>n-2</sub> · 2<sup>n-2</sup>) = x · y<sub>0</sub> · 2<sup>0</sup> + ... + x · y<sub>n-2</sub> · 2<sup>n-2</sup>_.
Par exemple, _-2 · 3 = -2 · 1 + -2 · 2 = -6_.
Ainsi, afin d'obtenir _x · y_, nous pouvons utiliser la même approche que la multiplication non signée.
Sous pseudocode, il s'agit de:

```
  acc ← 0
  
  pour i de 0 à n-2:
    si y[i] = 1:
      acc ← acc + x
      
    x ← 2·x
      
  retourner acc
```

Toutefois, un détail technique surgit lorsqu'on considère le comportement interne de l'addition. Par exemple, considérons
le cas où _x = -2_ et _y = 3_ sur _n = 3_ bits. En binaire, nous avons ```x = 110``` et ```y = 011```. En suivant aveuglement l'algorithme
de multiplication non signée, nous obtenons ce résultat erroné:

```
   110
+ 1100
¯¯¯¯¯¯
 10010  (-14) 
```

Cela survient car on additionne un nombre de 3 bits à un nombre de 4 bits. Pour que cela fasse du sens, il faut étendre avec le bit de signe:

```
extension du bit de signe
  |
  |
  v
  
  1110
+ 1100
¯¯¯¯¯¯
 11010   (-6)
```

Comme il y a au plus _n_ termes à la somme, il suffit d'étendre chaque terme à _2n_ bits. Plutôt que de réaliser cette extension lors des additions, nous pouvons
étendre directement _x_ sur _2n_ bits avant la multiplication:

```
extension ici
    |
    |
   vvv
   
   111110  (-2)
×     011   (3)
¯¯¯¯¯¯¯¯¯
   111110
+ 1111100
¯¯¯¯¯¯¯¯¯
 10111010 (-70)
```

Remarquons que le résultat est encore erroné! Cela se produit à nouveau car les deux termes de l'addition ne sont pas sur le même nombre de bits.
Par contre, sur les _2n_ positions de poids faible, tous les bits y sont. Comme le résultat d'une multiplication entre
forcément dans _2n_ bits, toute l'information pertinente s'y trouve. Il suffit donc d'enlever les bits excédentaires en troquant
à _2n_ bits. Nous obtenons ainsi:

```
   111110  (-2)
×     011   (3)
¯¯¯¯¯¯¯¯¯
   111110
+ 1111100
¯¯¯¯¯¯¯¯¯
 xx111010  (-6)  
```

## Cas où y < 0

Considérons maintenant le cas où _y_ est négatif. Par exemple, considérons _x = 3_ et _y = -2_ sur _n = 3_ bits.
En binaire, nous avons ```x = 011``` et ```y = 110```. Rappelons que l'algorithme de multiplication signée étend
ces deux nombres à 6 bits, effectue la multiplication non signée sur 12 bits, puis tronque aux 6 bits de poids faible:

```
       000011   (3)
×      111110  (-2)
¯¯¯¯¯¯¯¯¯¯¯¯¯
       000000
      0000110
     00001100
+   000011000
   0000110000
  00001100000
¯¯¯¯¯¯¯¯¯¯¯¯¯
  xxxxx111010  (-6)
```

Les termes de la suite d'additions peuvent être scindés en deux blocs que nous appelons «bloc A» et «bloc B»:

```
       000011   (3)
×      111110  (-2)
¯¯¯¯¯¯¯¯¯¯¯¯¯
       000000    ###########################################################################
      0000110    #  Bloc A: termes qui proviennent de 110 (valeur non signée de y)
     00001100    ###########################################################################
+
    000011000    ###########################################################################
   0000110000    #  Bloc B: termes qui proviennent de 111 (répétition du bit de signe de y)
  00001100000    ###########################################################################
¯¯¯¯¯¯¯¯¯¯¯¯¯
  xxxxx111010  (-6)
```

Analysons ces deux blocs afin d'identifier leur valeur respective.

### Bloc A

Cette partie calcule le produit de ```x``` et la valeur _non signée_ de ```y```. Dans notre exemple,
nous avons ```BlocA = 3 · 2¹ + 3 · 2²```. En général, nous obtenons:
<code>
BlocA = x · y<sub>0</sub> · 2<sup>0</sup> + ... + x · y<sub>n-1</sub> · 2<sup>n-1</sup>.
</code>

### Bloc B

Cette partie additionne _n_ fois des décalages de ```x```, car on considère le bit de
signe répété _n_ fois. Dans notre exemple, nous avons ```BlocB =  3 · 2³ + 3 · 2⁴ + 3 · 2⁵```.
En général, nous obtenons
<code>
BlocB = x · 2<sup>n</sup> + ... + x · 2<sup>2n-1</sup>.
</code>

La valeur de ```BlocB``` se réécrit plus simplement:
<pre>
 Proposition: BlocB = x · (2<sup>2n</sup> - 2<sup>n</sup>).
 
 Preuve:  BlocB = (x · 2<sup>n</sup> + ... + x · 2<sup>2n-1</sup>)
                = x · 2<sup>n</sup> · (2<sup>0</sup> + ... + 2<sup>n-1</sup>)
                = x · 2<sup>n</sup> · (2<sup>n</sup> - 1)
                = x · (2<sup>2n</sup> - 2<sup>n</sup>).         □
</pre>

### Bloc A + bloc B (informel)

La sortie de l'algorithme devrait être  _x · y_, c'est-à-dire _x_ multiplié par:

| -2<sup>n-1</sup> | 2<sup>n-2</sup> | ... | 2<sup>1</sup> | 2<sup>0</sup> |
|:-:|:-:|:-:|:-:|:-:|
| y<sub>n-1</sub> | y<sub>n-2</sub> | ... | y<sub>1</sub> | y<sub>0</sub> |

Comme l'extension d'un nombre par son bit de signe ne modifie pas sa valeur,
il est également correct de retourner _x_ multiplié par:

| -2<sup>n</sup> | 2<sup>n-1</sup> | 2<sup>n-2</sup> | ... | 2<sup>1</sup> | 2<sup>0</sup> |
|:-:|:-:|:-:|:-:|:-:|:-:|
| y<sub>n-1</sub> | y<sub>n-1</sub> | y<sub>n-2</sub> | ... | y<sub>1</sub> | y<sub>0</sub> |

Le bloc A correspond précisément aux _n_ dernières «colonnes» du nombre ci-dessus:

| 2<sup>n-1</sup> | 2<sup>n-2</sup> | ... | 2<sup>1</sup> | 2<sup>0</sup> |
|:-:|:-:|:-:|:-:|:-:|
| y<sub>n-1</sub> | y<sub>n-2</sub> | ... | y<sub>1</sub> | y<sub>0</sub> |

Ce qu'il manque au bloc A est le terme négatif _y<sub>n-1</sub> · -2<sup>n</sup>_. Le bloc
B vient ajouter cette «colonne» manquante. En effet, par la proposition, le bloc B contribue aux puissances _2<sup>2n</sup>_ et _-2<sup>n</sup>_.
Comme l'algorithme tronque aux _2n_ bits de poids faible, seule _-2<sup>n</sup>_ est ajoutée, ce
qui correspond précisément à la «colonne» manquante.

### Bloc A + bloc B (formel)

Plus formellement, la sortie de l'algorithme est <code>(BlocA + BlocB) mod 2<sup>2n</sup></code>. Ici, le modulo correspond
à la troncation sur les _2n_ bits de poids faible. Nous avons donc:

<pre>
  Sortie de l'algorithme
= (BlocA + BlocB) mod 2<sup>2n</sup>
= (BlocA mod 2<sup>2n</sup>) + (BlocB mod 2<sup>2n</sup>) mod 2<sup>2n</sup>             [car ab mod c = ((a mod c) + (b mod c)) mod c]
= (BlocA + (BlocB mod 2<sup>2n</sup>)) mod 2<sup>2n</sup>                    [car BlocA < 2<sup>2n</sup>]
= (BlocA + (x · (2<sup>2n</sup> - 2<sup>n</sup>) mod 2<sup>2n</sup>)) mod 2<sup>2n</sup>            [par la proposition]
= (BlocA + (x · -2<sup>n</sup> mod 2<sup>2n</sup>)) mod 2<sup>2n</sup>                   [car 2<sup>2n</sup> mod 2<sup>2n</sup> = 0]
= (BlocA + (2<sup>2n</sup> - x · 2<sup>n</sup>)) mod 2<sup>2n</sup>                      [car -a mod b = b - a lorsque a < b]
= (BlocA - x · 2<sup>n</sup>) mod 2<sup>2n</sup>                             [car 2<sup>2n</sup> mod 2<sup>2n</sup> = 0]
= BlocA - x · 2<sup>n</sup>                                       [car BlocA - x · 2<sup>n</sup> < 2<sup>2n</sup>]
= BlocA + x · y<sub>n-1</sub> · -2<sup>n</sup>                                [car y<sub>n-1</sub> = 1 puisque y est négatif]
= x · y<sub>0</sub> · 2<sup>0</sup> + ... + x · y<sub>n-1</sub> · 2<sup>n-1</sup> + x · y<sub>n-1</sub> · -2<sup>n</sup>    [par définition de BlocA]
= x · (y<sub>0</sub> · 2<sup>0</sup> + ... + y<sub>n-1</sub> · 2<sup>n-1</sup> + y<sub>n-1</sub> · -2<sup>n</sup>)          [mise en évidence de x]
= x · (y<sub>0</sub> · 2<sup>0</sup> + ...+ y<sub>n-2</sub> · 2<sup>n-2</sup> + y<sub>n-1</sub> · -2<sup>n-1</sup>)         [car y<sub>n-1</sub> · 2<sup>n-1</sup> - y<sub>n-1</sub> · 2<sup>n</sup> = y<sub>n-1</sub> · -2<sup>n-1</sup>]
= x · y.                                               🤯
</pre>

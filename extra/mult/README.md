 ___Ce billet est en construction; à lire à vos risques et périls!___

# Multiplication d'entiers signés

...

## Cas où y ≥ 0

Comme dans le cas non signé, nous avons
_x · y = x · (y<sub>0</sub> · 2<sup>0</sup> + ... + y<sub>n-1</sub> · 2<sup>n-1</sup>) = x · y<sub>0</sub> · 2<sup>0</sup> + ... + x · y<sub>n-1</sub> · 2<sup>n-1</sup>_.
Par exemple, _-2 · 3 = -2 · 1 + -2 · 2 = -6_.
Ainsi, afin d'obtenir _x · y_, nous pouvons utiliser la même approche que dans le cas non signé:

```
  acc ← 0
  
  pour i de 0 à n-1:
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
  1110
+ 1100
¯¯¯¯¯¯
 11010   (-6)
```

Comme il y a au plus _n_ termes à la somme, il suffit d'étendre chaque terme à _2n_ bits. Plutôt que de réaliser cette extension lors des additions, nous pouvons
étendre directement _x_ et _y_ sur _2n_ bits avant la multiplication:

```
   111110  (-2)
×  000011   (3)
¯¯¯¯¯¯¯¯¯
   111110
+ 1111100
¯¯¯¯¯¯¯¯¯
 10111010 (-70)
```

Remarquons que le résultat est encore erroné! Cela se produit à nouveau car les deux termes ne sont pas sur le même nombre de bits.
Par contre, sur les _2n_ bits de poids faible, les termes sont de la même taille. Comme le résultat d'une multiplication entre
forcément dans _2n_ bits, toute l'information pertinente s'y trouve. Il suffit donc d'enlever les bits excédentaires et de tronquer
à _2n_ bits. Nous obtenons ainsi:

```
   111110  (-2)
×  000011   (3)
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

Les termes de l'addition peuvent être scindés en deux blocs que nous appelons «bloc A» et «bloc B»:

```
       000 011   (3)
×      111 110  (-2)
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

### Bloc A

La première partie calcule le produit de ```x``` et la valeur _non signée_ de ```y```. Dans notre exemple,
nous avons ```BlocA = 3 · 2¹ + 3 · 2² = 18```. En général, nous obtenons:
<code>
 BlocA = x · y<sub>0</sub> · 2<sup>0</sup> + ... + x · y<sub>n-1</sub> · 2<sup>n-1</sup>.
</code>

### Bloc B

La deuxième partie additionne _n_ fois des décalages de ```x```, car on considère le bit de
signe répété _n_ fois. Dans notre exemple, nous avons ```BlocB =  3 · 2³ + 3 · 2⁴ + 3 · 2⁵ = 168```.
En général, nous obtenons
<code>
 BlocB = (2<sup>n</sup> · x + ... + 2<sup>2n-1</sup> · x)
</code>.

Il est possible de démontrer que ```BlocB``` se réécrit plus simplement:
<pre>
 Proposition: BlocB = (2<sup>2n</sup> · x - 2<sup>n</sup> · x).
 
 Preuve:
 
 BlocB = (2<sup>n</sup> · x + ... + 2<sup>2n-1</sup> · x)
       = 2<sup>n</sup> · (2<sup>0</sup> + ... + 2<sup>n-1</sup>) · x
       = 2<sup>n</sup> · (2<sup>n</sup> - 1) · x
       = (2<sup>2n</sup> · x - 2<sup>n</sup> · x). □
</pre>

### Bloc A + Bloc B

<pre>
  Sortie de l'algorithme
= (BlocA + BlocB) mod 2<sup>2n</sup>
= (BlocA mod 2<sup>2n</sup>) + (BlocB mod 2<sup>2n</sup>) mod 2<sup>2n</sup>             [car ab mod c = ((a mod c) + (b mod c)) mod c]
= (BlocA + (BlocB mod 2<sup>2n</sup>)) mod 2<sup>2n</sup>                    [car BlocA < 2<sup>2n</sup>]
= (BlocA + ((2<sup>2n</sup> · x - 2<sup>n</sup> · x) mod 2<sup>2n</sup>) mod 2<sup>2n</sup>         [par la proposition]
= (BlocA + (-2<sup>n</sup> · x mod 2<sup>2n</sup>)) mod 2<sup>2n</sup>                   [car 2<sup>2n</sup> · x mod 2<sup>2n</sup> = 0]
= (BlocA + (2<sup>2n</sup> - 2<sup>n</sup> · x)) mod 2<sup>2n</sup>
= (BlocA - 2<sup>n</sup> · x) mod 2<sup>2n</sup>
= BlocA - 2<sup>n</sup> · x                                       [car BlocA - ... ≤ BlocA < 2<sup>2n</sup>]
= BlocA - x · y<sub>n-1</sub> · -2<sup>n</sup>                                [y<sub>n-1</sub> = 1 car y est négatif]
= x · y<sub>0</sub> · 2<sup>0</sup> + ... + x · y<sub>n-1</sub> · 2<sup>n-1</sup> - x · y<sub>n-1</sub> · -2<sup>n</sup>    [par déf. de BlocA].
= x · (y<sub>0</sub> · 2<sup>0</sup> + ... + y<sub>n-1</sub> · 2<sup>n-1</sup> - y<sub>n-1</sub> · -2<sup>n</sup>)
= x · (valeur signée de y sur n + 1 bits)
</pre>
Remarquons que le dernier terme de la chaîne d'équations correspond précisément au produit signé de x par y étendu d'un bit.
Comme étendre y d'un bit ne change pas sa valeur, l'algorithme retourne la bonne sortie!

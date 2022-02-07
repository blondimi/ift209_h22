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

...

<code>
 Proposition: (2<sup>0</sup>·x + ... + 2<sup>n-1</sup>·x) mod 2<sup>n</sup> = 2<sup>n</sup> - x.
</code>

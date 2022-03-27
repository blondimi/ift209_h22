# Convention d'appel et valeurs de retour

J'ai affirmé en classe que la convention d'appel d'ARMv8 demande à ce
que le retour d'un sous-programme se fasse via ```x0``` s'il n'y a
qu'une valeur d'au plus 64 bits, ou, à défaut, via une adresse
spécifiée par l'appelant dans ```x8```. La convention est en fait plus
permissive; il est *parfois* permis de retourner plusieurs valeurs via
plusieurs registres. Les règles exactes (et assez techniques) sont
décrites à la section 6.5 de [ce
document](https://github.com/ARM-software/abi-aa/releases/download/2020Q4/aapcs64.pdf).

## Exemple de retour via deux registres

Rappelons qu'il n'y a pas de concept d'objets en C (contrairement à
C++), mais qu'il est possible d'utiliser une [```struct```](https://en.wikipedia.org/wiki/Struct_(C_programming_language))
afin de stocker un bloc contigu de données. Par exemple, cette
structure représente un vecteur 2D (au sens mathématique) sur 16
octets consécutifs:

```c
struct Point2D {
  unsigned long x;
  unsigned long y;
};
```

La fonction ```plus``` ci-dessous implémente l'addition de deux
vecteurs, alors que la fonction ```doubler``` permet de doubler un
vecteur. Notons qu'elles retournent leur résultat par valeur sur 128
bits.

```c
struct Point2D plus(struct Point2D u, struct Point2D v)
{
  struct Point2D w;

  w.x = u.x + v.x;
  w.y = u.y + v.y;
  
  return w;
}

struct Point2D doubler(struct Point2D v)
{
  struct Point2D w;

  w = plus(v, v);

  return w;
}
```

En compilant ce code avec ```gcc -S -Og``` dans la machine virtuelle
du cours (donc avec peu d'optimisations), et en nettoyant les
méta-données, on obtient ce code ARMv8:

```c
plus:                                 // [u64, u64] plus(u64 u.x, u64 u.y, u64 v.x, u64 v.y)
                                      // {
	add	x0, x0, x2            //
	add	x1, x1, x3            //
	ret                           //   return [u.x + v.x, u.y + v.y]
                                      // }
```

Pour simplifier la notation, le «pseudocode à la C» en commentaires
utilise l'abréviation ```u64``` pour spécifier ```unsigned long```,
et les crochets pour spécifier une paire de valeurs.
Ainsi, le compilateur représente les deux vecteurs ```u``` et ```v```
par quatre valeurs passées dans les registres ```x0``` à ```x3```. La
somme ```w``` des deux vecteurs est quant à elle retournée via
```x0``` et ```x1``` (donc deux registres!)

Voyons maintenant le code ARMv8 généré par le compilateur pour
```doubler```:

```c
doubler:                              // [u64, u64] doubler(u64 v.x, u64 v.y)
	stp	x29, x30, [sp, -16]!  // {
	add	x29, sp, 0            //   sauvegarder [x29, x30] sur la pile
                                      //
        mov	x2, x0                //
	mov	x3, x1                //
	bl	plus                  //   [w.x, w.y] = plus(v.x, v.y, v.x, v.y)
                                      //
	ldp	x29, x30, [sp], 16    //   restaurer [x29, x30]
	ret                           //   return [w.x, x.y]
                                      // }
```

Les deux premières et l'avant-dernière lignes correspondent à nos
macros ```SAVE``` et ```RESTORE``` (ici ```mov x29, sp``` est écrit
plus cryptiquement par ```add x29, sp, 0```). L'appel à ```plus```
passe simplement les deux vecteurs en tant que quatre valeurs.

## Exemple de retour via ```x8```

Ajoutons maintenant une structure de vecteur 3D (au sens
mathématique):

```c
struct Point3D {
  unsigned long x;
  unsigned long y;
  unsigned long z;
};
```

Cette fonction étend un vecteur 2D à un vecteur 3D dont la dernière
composante est nulle:

```c
struct Point3D etendre(struct Point2D v)
{
  struct Point3D w;

  w.x = v.x;
  w.y = v.y;
  w.z = 0;
  
  return w;
}
```

Cette fois, le compilateur n'utilise pas ```x0``` à ```x2``` pour
retourner ```w```. On s'attend plutôt à ce que l'appelant alloue 24
octets afin de stocker ```w```, et que l'adresse qui pointe vers ces
octets soit spécifiée à l'appel dans le registre ```x8```:

```c
etendre:                              // void etendre(u64 v.x, u64 v.y, Point3D* w)
                                      // {
	str	x0, [x8]              //   (*w).x = v.x
	str	x1, [x8, 8]           //   (*w).y = v.y 
	str	xzr, [x8, 16]         //   (*w).z = 0
                                      //
	mov	x0, x8                //
	ret                           // }
                                      //
```

Afin d'inspecter le code généré par le compilateur pour un appel à
```etendre```, ajoutons cet appel bidon:

```c
int main()
{
  struct Point2D v;

  v.x = 42;
  v.y = 9000;
  
  struct Point3D w = etendre(v);
}
```

Ce code est compilé de cette façon:

```c
main:                                 // int main()
	stp	x29, x30, [sp, -48]!  // {
	add	x29, sp, 0            //   sauvegarder [x29, x30] au sommet de la pile
                                      //    et laisser de l'espace pour quatre double mots
                                      //
	add	x8, x29, 24           //   struct Point3D* w = pile + 24 octets
	mov	x0, 42                //
	mov	x1, 9000              //   
	bl	etendre               //   etendre(42, 9000, w)
                                      //
	mov	w0, 0                 //
	ldp	x29, x30, [sp], 48    //   restaurer la pile
                                      //
	ret                           //   return 0
                                      // }
```

Imaginons les éléments de la pile comme des double mots (8 octets) et
le sommet de la pile comme l'élément ```0``` (après la réservation des
48 octets). Le code ci-dessus sauvegarde ```x29``` et ```x30``` dans
```pile[0]``` et ```pile[1]```, et réserve ```pile[2]``` à
```pile[5]``` pour des données locales. L'appel à ```etendre``` se
fait en passant ```42``` et ```9000``` respectivement dans ```x0``` et
```x1```, et l'adresse associée à ```pile[3]``` dans
```x8```. L'appelé stocke donc le vecteur 3D résultant dans
```pile[3]``` à ```pile[5]```.

Remarquons que ```pile[2]``` n'est jamais utilisé, mais est nécessaire
car la pile doit toujours être alignée à un multiple de 16.

|adresse|nom dans l'explication|contenu|
|:-:|:-:|:-:|
|```sp+00```|```pile[0]```|```x29```|
|```sp+08```|```pile[1]```|```x30```|
|```sp+16```|```pile[2]```|```—```|
|```sp+24```|```pile[3]```|```w.x```|
|```sp+32```|```pile[4]```|```w.y```|
|```sp+40```|```pile[5]```|```w.z```|
|```sp+48```|```ancien sommet```|```⋮```|

# Pourquoi deux mais pas trois?

Voyons pourquoi le compilateur décide de retourner deux entiers via
```x0``` et ```x1```, mais pas trois entiers via ```x0```, ```x1``` et
```x2```. Le premier item de l'extrait ci-dessous semble suggérer
qu'on peut retourner jusqu'à huit valeurs via ```x0``` à ```x7```:

```c
6.5   Result Return

The manner in which a result is returned from a function is determined
by the type of that result:

• If the type, T, of the result of a function is such that

    void func(T arg)

  would require that arg be passed as a value in a register (or set of
  registers) according to the rules in Parameter Passing, then the
  result is returned in the same registers as would be used for such
  an argument.

• Otherwise, the caller shall reserve a block of memory of sufficient
  size and alignment to hold the result.  The address of the memory
  block shall be passed as an additional argument to the function in
  x8. The callee may modify the result memory block at any point during
  the execution of the subroutine (there is no requirement for the
  callee to preserve the value stored in x8).
```

Toutefois, le premier item est sujet aux contraintes plutôt techniques
décrites à la section 5.4 de la convention d'appel. En particulier, on
y apprend qu'***une ```struct``` d'entiers de plus de 128 bits*** doit être
retournée via ```x8``` (ce qui est notre cas):

```
B.3  If the argument type is a Composite Type that is larger than 16
bytes, then the argument is copied to memory allocated by the caller
and the argument is replaced by a pointer to the copy.
```

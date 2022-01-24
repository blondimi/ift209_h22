# Dernier F: argument sans conversion binaire

Le plus grand nombre octal de _n_ chiffres est _x = 7·8⁰ + 7·8¹ + 7·8² + ... + 7·8ⁿ⁻¹_.
Le dernier chiffre de _x₁₆_ est _x mod 16_. Ce chiffre est bien _F_ car:

```
x mod 16 = (7·8⁰ + 7·8¹ + 7·8² + ... + 7·8ⁿ⁻¹) mod 16
         = (7·8⁰ + 7·8¹ + 8²·(7·8⁰ + ... + 7·8ⁿ⁻³)) mod 16  [les deux premiers termes existent car n ≥ 2]
         = (63 + 16·(7·8⁰ + ... + 7·8ⁿ⁻³)) mod 16
         = 63 mod 16                                        [car la deuxième portion est un multiple de 16]
         = 15                                               [car 63 = 3·16 + 15]
         = F₁₆.                                             □  
```

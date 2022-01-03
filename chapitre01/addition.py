# Retourne la valeur numérique d'un chiffre
def val(chiffre):
    return int(chiffre) if chiffre.isdigit() else ord(chiffre) - 55

# Retourne le chiffre associé à une valeur numérique
def chiffre(val):
    return str(val) if val < 10 else chr(val + 55)

# Retourne la somme x et y décrits en base b
def additionner(x, y, b):
    x = x[::-1] # Renverser les chaînes pour que les indices
    y = y[::-1] #  soient dans l'ordre des notes de cours
    
    m, n = len(x), len(y)
    z, r = "", 0

    for i in range(max(m, n)):
        u = val(x[i]) if i < m else 0
        v = val(y[i]) if i < n else 0

        s = r + u + v
        z = chiffre(s % b) + z

        r = 1 if s >= b else 0

    if r == 1:
        z = "1" + z

    return z

# Exemple
if __name__ == "__main__":
    b = 16
    x = "D40C"
    y = "6FA5"
    z = additionner(x, y, b)

    print(f"{x}_{b} + {y}_{b} = {z}_{b}")

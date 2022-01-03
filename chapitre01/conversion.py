# Retourne le chiffre associé à une valeur numérique
def chiffre(val):
    return str(val) if val < 10 else chr(val + 55)

# Retourne x converti de la base 10 à la base b
def convertir(x, b):
    y = ""

    while True:
        y = chiffre(x % b) + y
        x = x // b

        if x == 0: break

    return y

# Exemples
if __name__ == "__main__":
    b = 2
    x = 22
    y = convertir(x, b)

    print(f"{x}_10 = {y}_{b}")

    b = 16
    x = 30
    y = convertir(x, b)

    print(f"{x}_10 = {y}_{b}")

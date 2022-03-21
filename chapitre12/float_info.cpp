#include <iostream>
#include <limits>

int main()
{
  std::cout << "Information sur le type float"
            << std::endl << std::endl
            << " IEEE 754? "
            << (std::numeric_limits<float>::is_iec559 ? "Oui" : "Non")
            << std::endl
            << " ε-machine? "
            << std::numeric_limits<float>::epsilon()
            << std::endl
            << " Mode d'approximation? "
            << (std::numeric_limits<float>::round_style ==
                std::round_to_nearest ?
                "Arrondi comme en classe" : "Autre")
            << std::endl;
}

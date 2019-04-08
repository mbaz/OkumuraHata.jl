OkumuraHata.jl
==============

This module provides the function `oh`, which calculates the path loss according to the Okumura-Hata model. This function takes four arguments:

* `f` is the carrier frequency in MHz, in the range `150 <= f <= 1500`

* `d` is the distance between base station and mobile in km; `1 <= d <= 10`

* `hb` is the base station antenna height in m; `30 <= hb <= 200`

* `hm` is the mobile antenna height in m; `1 <= hm <= 10`

The loss in decibels is calculated for large cities, small cities,
suburban areas and rural areas.

References:
-----------

* Hata, M, "Empirical Formula for Propagation Loss in Land Mobile Radio Services", IEEE Transactions on Vehicular Technology, August 1980, pp. 317–325.

* Wikipedia: https://en.wikipedia.org/wiki/Hata_model



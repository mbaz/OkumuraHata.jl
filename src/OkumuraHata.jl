## Copyright (c) 2018 Miguel Bazdresch
##
## This file is distributed under the 2-clause BSD License.

# Calculate the path loss using the Okumura-Hata model.
# References:
#   Hata, M, "Empirical Formula for Propagation Loss in Land Mobile Radio
#   Services", IEEE Transactions on Vehicular Technology, August 1980,
#   pp. 317–325.
#
#   Wikipedia: https://en.wikipedia.org/wiki/Hata_model

module OkumuraHata

using NumericIO

export loss_oh

struct LossOH
    large_city :: Float64
    small_city :: Float64
    suburban   :: Float64
    rural      :: Float64
end

function Base.getindex(l::LossOH, i::Symbol)
    i == :large_city && return l.large_city
    i == :small_city && return l.small_city
    i == :suburban && return l.suburban
    i == :rural && return l.rural
end

function Base.show(io::IO, l::LossOH)
    f(x) = formatted(x, :SI, ndigits=5, charset=:ASCII)

    println("Losses according to Okumura-Hata model (all in dB):")
    println("  Loss in large city:    ", f(l.large_city))
    println("  Loss in small city:    ", f(l.small_city))
    println("  Loss in suburban area: ", f(l.suburban))
    println("  Loss in rural area:    ", f(l.rural))
end

"""
loss_oh(f, d, hb, hm)

Calculate the path loss according to the Okumura-Hata model.

  f is the carrier frequency in MHz, in the range 150 <= f <= 1500
  d is the distance between base station and mobile in km; 1 <= d <= 10
  hb is the base station antenna height in m; 30 <= hb <= 200
  hm is the mobile antenna height in m; 1 <= hm <= 10

The loss in decibels is calculated for large cities, small cities,
suburban areas and rural areas.

Returns the four calculated losses in a struct of type LossOH, which can be
accessed by property name (`loss.small_city`) or by indexing
(`loss[:suburban]`).
"""
function loss_oh(f, d, hb, hm)

    (150 <= f <= 1500) || error("Invalid frequency f = $f: must be in range [150, 1500]")
    (1 <= d <= 10) || error("Invalid distance d = $d: must be in rage [1,10]")
    (30 <= hb <= 200) || error("Invalid base station antenna height hb = $hb: must be in range [30,200]")
    (1 <= hm <= 10) || error("Invalid mobile station antenna height hm = $hm: must be in range [1,10]")

    Ch_small = 0.8 + hm*(1.1log10(f)-0.7) - 1.56log10(f)
    if 150 <= f <= 200
        Ch_large = 8.29*(log10(1.54hm))^2 - 1.1
    else
        Ch_large = 3.2*(log10(11.75hm))^2 - 4.97
    end

    Lu = 69.55 + 26.16log10(f) - 13.82log10(hb) + log10(d)*(44.9-6.55log10(hb))

    Lu_large = Lu - Ch_large
    Lu_small = Lu - Ch_small
    Lu_suburban = Lu_small - 2*(log10(f/28)^2) - 5.4
    Lu_rural = Lu_small - 4.78*(log10(f)^2) + 18.33log10(f) - 40.94

    return LossOH(Lu_large, Lu_small, Lu_suburban, Lu_rural)

end

end

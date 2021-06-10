# The Roaring Landmask

Have you ever needed to know whether you are in the ocean or on land? And you
need to know it fast? And you need to know it without using too much memory or
too much disk? Then try the _Roaring Landmask_!.

The _roaring landmask_ is a Rust + Python package for quickly determining
whether a point given in latitude and longitude is on land or not. A landmask
is stored in a tree of [roaring bitmap](https://roaringbitmap.org/). Points
close to the shore might still be in the ocean, so a positive
value is then checked against the vector shapes of the coastline.

The landmask is generated from the [GSHHG shoreline
database](https://www.soest.hawaii.edu/pwessel/gshhg/) (Wessel, P., and W. H.
F. Smith, A Global Self-consistent, Hierarchical, High-resolution Shoreline
Database, J. Geophys. Res., 101, 8741-8743, 1996).

An alternative is the
[opendrift-landmask-data](https://github.com/OpenDrift/opendrift-landmask-data),
which is slightly faster, is pure Python, but requires more memory and disk
space (memory-mapped 3.7Gb).

## Performance

Microbenchmarks:

```
test tests::test_contains_in_ocean         ... bench:          24 ns/iter (+/- 0)
test tests::test_contains_on_land          ... bench:       3,795 ns/iter (+/- 214)
```

Many points, through Python:

```
------------------------------------------------ benchmark: 1 tests -----------------------------------------------
Name (time in ms)           Min       Max      Mean  StdDev    Median     IQR  Outliers     OPS  Rounds  Iterations
-------------------------------------------------------------------------------------------------------------------
test_landmask_many     147.9902  150.2231  149.2532  1.0469  149.7798  1.8760       1;0  6.7000       5           1
-------------------------------------------------------------------------------------------------------------------
```

> opendrift-landmask-data uses about `120 ms` on the same benchmark.

## Usage from Python

```python
from roaring_landmask import RoaringLandmask

l = RoaringLandmask.new()
x = np.arange(-180, 180, .5)
y = np.arange(-90, 90, .5)

xx, yy = np.meshgrid(x,y)

print ("points:", len(xx.ravel()))
on_land = l.contains_many(xx.ravel(), yy.ravel())
```

## Building & installing

1) Install [maturin](https://github.com/PyO3/maturin).

2) Build and install

```
maturin build --release
pip install target/wheels/... # choose your whl
```

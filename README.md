# raybox-zero-caravel

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This is a clone of [caravel_user_project] (at the time of writing, based on tag [mpw-8c] per the [Zero to ASIC Course]).

The [ew branch] is where it began life, and is probably still the default.

This repo wraps [raybox-zero] (namely its `ew` branch too).

**This design implements a simple hardware ray caster** and while it is hardened as its own GDS macro and placed inside the Caravel `user_project_wrapper`, it is (hopefully) going to be part of a shared chipIgnite shuttle project. Given this, it has only 9 dedicated Caravel IO pads, but also makes extensive use of Logic Analyzer pins.

**More to come!**


[caravel_user_project]: https://github.com/efabless/caravel_user_project
[mpw-8c]: https://github.com/efabless/caravel_user_project/tree/mpw-8c
[Zero to ASIC Course]: https://zerotoasiccourse.com/
[ew branch]: https://github.com/algofoogle/raybox-zero-caravel/tree/ew
[raybox-zero]: https://github.com/algofoogle/raybox-zero/tree/ew

## Old notes/guides from eFabless

Refer to [README](docs/source/index.rst#section-quickstart) for a quickstart of how to use caravel_user_project

Refer to [README](docs/source/index.rst) for this sample project documentation. 


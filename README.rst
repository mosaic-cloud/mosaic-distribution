
About
=====

This work is part of the mOSAIC project open-source outcomes released under the Apache 2.0 license (see the "Notice" section below).
    http://developers.mosaic-cloud.eu/

...


How to build
============

Dependencies
------------

* almost none for "automatic" build...

* supported distributions:

 * ``mos`` (currently broken);
 * ``debian`` / ``ubuntu`` (currently broken);
 * ``archlinux`` (the one currently used);
 * any other for which you manually install the needed packages;

* if you don't have a "supported" distribution, you need (the list is not exhaustive):

 * ``java`` version ``1.7``;
 * ``erlang`` version ``R15Bx`` (where ``x`` is ``01``, ...);
 * ``nodejs`` version ``0.8.x``;
 * ``npm`` latest version;
 * ``gcc`` / ``g++`` version ``4.x``;
 * ``bash``, ``coreutils``;
 * ``tar``, ``wget``;
 * ``git``;

Quick
-----

* inside a console, in the parent folder where you want to place the ``mosaic-distribution`` folder: ::

    git clone http://bitbucket.org/mosaic/mosaic-distribution.git ./mosaic-distribution

* inside the ``mosaic-distribution`` folder: ::

    ./scripts/prepare-all
    ./scripts/compile-all
    ./scripts/package-all
    ./scripts/deploy-all

Preparing
---------

* to clone initially, inside a console, in the parent folder where you want to place the ``mosaic-distribution`` folder: ::

    git clone http://bitbucket.org/mosaic/mosaic-distribution.git ./mosaic-distribution

* to update, inside the ``mosaic-distribution`` folder: ::

    git pull

Building
--------

* inside the ``mosaic-distribution`` folder: ::

    ./scripts/prepare-all
    ./scripts/compile-all
    ./scripts/package-all

Deploying
---------

* we assume that you'we configured a "default" private key for the host ``agent-1.builder.mosaic.ieat.ro``;

* inside the ``mosaic-distribution`` folder: ::

    ./scripts/deploy-all


Notice
======

This product includes software developed at "Institute e-Austria, Timisoara",
as part of the "mOSAIC -- Open-Source API and Platform for Multiple Clouds"
research project (an EC FP7-ICT Grant, agreement 256910).

* http://developers.mosaic-cloud.eu/
* http://www.ieat.ro/

Developers:

* Ciprian Dorin Craciun, ciprian@volution.ro / ciprian.craciun@gmail.com

Copyright: ::

   Copyright 2010-2011, Institute e-Austria, Timisoara, Romania
       http://www.ieat.ro/
   
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at:
       http://www.apache.org/licenses/LICENSE-2.0
   
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

Exceptions: ::

    This notice applies only on the current "repository" and does not transcend
    to the other nested "sub-repositories" (a.k.a. "Git submodules") referenced
    from the `./repositories` folder. Each of these "sub-repositories" may have
    its own copyright and licensing terms.


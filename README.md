About
-----

Simple class for reading microfone levels. Based on a code written
by [Stephen Celis][1]. Basic usage:

    SCListener *listener = [[SCListener alloc] init];
    [listener listen];
    NSLog(@"%f", [listener averagePower]);
    NSLog(@"%f", [listener peakPower]);
    [listener release];

Both the average and the peak mic power go from zero to one. See the sources
for details.

[1]: http://github.com/stephencelis/sc_listener

Authors
-------

© Stephen Celis (<stephen@stephencelis.com>) and Tomáš Znamenáček (<zoul@fleuron.cz>).
Released under the [MIT License][mit].

[mit]: http://en.wikipedia.org/wiki/MIT_License

Permission is hereby granted, free of charge, to any person obtaining a copy 
of this software and associated documentation files (the “Software”), to deal 
in the Software without restriction, including without limitation the rights 
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
copies of the Software, and to permit persons to whom the Software is 
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

**The Software is provided “as is”, without warranty of any kind, express or
implied, including but not limited to the warranties of merchantability,
fitness for a particular purpose and noninfringement. In no event shall the
authors or copyright holders be liable for any claim, damages or other
liability, whether in an action of contract, tort or otherwise, arising from,
out of or in connection with the software or the use or other dealings in the
Software.**
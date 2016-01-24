# KNCirclePercentView
A view to show a configurable arrow wherever you need. (Mostly useful for user guides) You don’t need to have different images for arrows for different screen sizes.

## Usage
1. Add KNCirclePercentView using storyboard/nib/code
2. Call Methods:
```Objective-C
AFCurvedArrowView *arrowView = [[AFCurvedArrowView alloc] initWithFrame:CGRectMake(100.0, 100.0, 200.0, 200.0)];
arrowView.arrowHeadHeight = 20.0;
arrowView.arrowHeadWidth = 10.0;
arrowView.arrowTail = CGPointZero;
arrowView.arrowHead = CGPointMake(1.0, 0.7);
arrowView.controlPoint1 = CGPointMake(-0.3, 1.3);
arrowView.curveType = AFCurveTypeQuadratic;
[self.view addSubview:arrowView];
```

## Screenshot
### iPhone

![](sample.gif)

##License
The MIT License (MIT)

Copyright © 2015 Anton Filimonov.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
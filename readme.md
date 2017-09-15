Drag and drop crashing with Right to left languages in iOS 11

Area:
UIKit

Summary:
During the implementation of the drag and drop in our application, we noticed that the app is crashing when we want to use the feature for right to left languages. We made a sample application to produce the bug, and it is clear that something is not fine when we want to move a cell in the collection view.

Steps to Reproduce:
Set the application language to right to left Pseudolanguage. 
Start the sample application. 
Drag the green cell to the cyan arrea. It will make a copy into the collection view.
Get the green cell again and drag it to the right side of the collection view (above the copied cell).
The `_UICollectionViewDragAndDropController _beginDragAndDropInsertingItemAtIndexPath:` will crash with Assertion failure (see the log in the attached `crashlog.txt`)

Expected Results:
No crash when copying or moving cells.

Actual Results:
Crash

Version/Build:
iOS 11, Xcode: Version 9.0 (9A235)

Configuration:
Application language is set to Right-to-Left Pseudolanguage
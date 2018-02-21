---
layout: default
title: Common audio format between Android and iOS
tags: audio playback ios android programming
---

If you need a common audio format between Android and iOS, try AAC codec with container format MP4\. The file extension used is mp4.

On Android, record using encoding `MediaRecorder.AudioEncoder.AAC` and container format `MediaRecorder.OutputFormat.MPEG_4`. That should play all right on iOS 7, or better.

On iOS, record using the following settings

```objc
NSDictionary *recordSettings = 
    [NSDictionary
    dictionaryWithObjectsAndKeys:
    [NSNumber numberWithFloat:44100.0],AVSampleRateKey,
    [NSNumber numberWithInt: 2],AVNumberOfChannelsKey,
    [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
    [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,
    [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
    nil];
```

The resulting file should play all right on Android 4.3, or better.

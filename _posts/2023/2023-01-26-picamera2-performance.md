---
layout: default
title: Picamera2 performance
tags: esp32 i2c bme680 arduino
comments: true
---
# Picamera2 performance

[Picamera2](https://github.com/raspberrypi/picamera2) is a Python library based on libcamera that replaces Picamera. This post discusses some sample code and its performance on a Raspberry Pi 4 with both 32-bit and 64-bit Raspberry Pi OS. Raspberry Pi OS already has all the dependencies required to run the sample code. All samples capture full 5MP resolution images from OV5647 based camera module V1.

Power supply can significantly influence performance, always use the original 3A power supply or better.

SD cards can also influence performance, use `fio` to benchmark and compare different cards

```bash
sudo apt install fio
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=test --bs=4k --iodepth=64 --size=32M --readwrite=randrw --rwmixread=75
```

## Capture to file sequentially

The code below sequentially captures twenty full-resolution JPEG images

```python
from picamera2 import Picamera2, Preview
import time

picam2 = Picamera2()
camera_config = picam2.create_still_configuration()
picam2.configure(camera_config)
picam2.start()
time.sleep(2)
counter = 0
start = time.time()
while 1:
    print(f"capture {counter}")
    picam2.capture_file(f"test{counter}.jpg")
    counter += 1
    if counter == 20:
        break
end = time.time()
print(end - start)
```

It takes `5.64` seconds to run on 32-bit Raspberry Pi OS and `3.85` seconds on 64-bit.

## Capture and convert sequentially

The code below is quite similar to the one above, but it makes a Python Image Library (PIL) image from the capture buffer using `make_image` helper function, and then calls `save`

```python
from picamera2 import Picamera2, Preview
import time

picam2 = Picamera2()
camera_config = picam2.create_still_configuration()
picam2.configure(camera_config)
picam2.start()
time.sleep(2)
counter = 0
start = time.time()
while 1:
    print(f"capture {counter}")
    (buffer, ), metadata = picam2.capture_buffers(["main"])
    img = picam2.helpers.make_image(buffer, camera_config["main"])
    picam2.helpers.save(img, metadata, f"test{counter}.jpg")
    counter += 1
    if counter == 20:
        break
end = time.time()
print(end - start)
```

It takes `6.36` seconds to run on 32-bit Raspberry Pi OS and `3.82` seconds on 64-bit.

## Convert asynchronously and save to file

This code changes the previous code to use a separate thread to call `make_image` helper function, and then call `save`

```python
from picamera2 import Picamera2, Preview
import time
import threading

picam2 = Picamera2()
camera_config = picam2.create_still_configuration(buffer_count=2)
picam2.configure(camera_config)
picam2.start()
time.sleep(2)
counter = 0

def write_jpg(buffer):
    img = picam2.helpers.make_image(buffer, camera_config["main"])
    picam2.helpers.save(img, metadata, f"test{counter}.jpg")

start = time.time()
while 1:
    print(f"capture {counter}")
    (buffer, ), metadata = picam2.capture_buffers(["main"])
    t = threading.Thread(target=write_jpg, args=(buffer,))
    t.start()
    counter += 1
    if counter == 20:
        break
for t in threading.enumerate():
    if t != threading.current_thread() and t.daemon is False:
        t.join()
end = time.time()
print(end - start)
```

It takes `2.18` seconds to run on 32-bit Raspberry Pi OS and `1.37` seconds on 64-bit.

## Convert asynchronously and stream to network

This code is similar to the one before but instead of writing to file, it writes data out to a TCP socket

```python
from picamera2 import Picamera2, Preview
import time
import threading
import socket

picam2 = Picamera2()
camera_config = picam2.create_still_configuration(buffer_count=2)
picam2.configure(camera_config)
picam2.start()
time.sleep(2)
counter = 0

def write_jpg(buffer):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect(("192.168.68.60", 8001))
    out = sock.makefile("wb")
    img = picam2.helpers.make_image(buffer, camera_config["main"])
    picam2.helpers.save(img, metadata, out, format='jpeg')

start = time.time()
while 1:
    print(f"capture {counter}")
    (buffer, ), metadata = picam2.capture_buffers(["main"])
    t = threading.Thread(target=write_jpg, args=(buffer,))
    t.start()
    counter += 1
    if counter == 20:
        break
for t in threading.enumerate():
    if t != threading.current_thread() and t.daemon is False:
        t.join()
end = time.time()
print(end - start)
```

It takes `2.18` seconds to run on 32-bit Raspberry Pi OS and `1.37` seconds on 64-bit, same as the previous sample.

To receive at the other end

```python
import socket
import threading
from datetime import datetime

def save_jpeg(args):
    conn = args[0]
    with open(f"{datetime.utcnow().strftime('%Y%m%d-%H%M%S_%f')[:-3]}.jpg", "wb") as f:
        while 1:
            data = conn.recv(1024)
            if data:
                f.write(data)
            else:
                break

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
sock.bind(("0.0.0.0", 8001))
sock.listen()

while 1:
    conn = sock.accept()
    t = threading.Thread(target=save_jpeg, args=(conn,))
    t.start()
```

## Capture raw image

This sample code recovers a raw image buffer and calls `save_dng` helper to save a raw image

```python
from picamera2 import Picamera2, Preview
import time

picam2 = Picamera2()
camera_config = picam2.create_still_configuration(raw={})
picam2.configure(camera_config)
picam2.start()
time.sleep(2)
counter = 0
start = time.time()
while 1:
    print(f"capture {counter}")
    (buffer, ), metadata = picam2.capture_buffers(["raw"])
    picam2.helpers.save_dng(buffer, metadata, camera_config["raw"], f"test{counter}.dng")
    counter += 1
    if counter == 20:
        break
end = time.time()
print(end - start)
```

It takes `17.82` seconds to run on 32-bit Raspberry Pi OS and `10.46` seconds on 64-bit.

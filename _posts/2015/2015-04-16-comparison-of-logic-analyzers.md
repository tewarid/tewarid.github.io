---
layout: default
title: Comparison of Logic Analyzers
tags: logic analyzer comparison
comments: true
---

|           **Model name**           | **BS05 (Micro)** | **Logic 8** | **Logic 16** |    **MSO-19**     | **SX**  |
| ---------------------------------- | :--------------: | :---------: | :----------: | :---------------: | :-----: |
| **Manufacturer**                   |     BitScope     |   Saleae    |    Saleae    | Link Instruments  |  USBee  |
| **Price**                          |     $145.00      |   $219.00   |  *Retired*   |      $249.00      | $169.00 |
| **Number of digital channels**     |        6         |      8      |      16      |         8         |    8    |
| **Number of analog channels**      |        2         |      8      |      NA      |         1         |   NA    |
| **Maximum sampling frequency**     |     40 MS/s      |   25 MS/s   |   100 MHz    |      100 MHz      | 24 MS/s |
| **Logic level**                    |    3.3 - 5 V     | 1.8 - 5.5 V |  1.8 - 5 V   |     1.2 - 5 V     | 2 - 5 V |
| **Price of analyzer software**     |       FREE       |    FREE     |     FREE     |       FREE        |  FREE   |
| **I2C decoding**                   |        Y         |      Y      |      Y       |         Y         |    Y    |
| **SPI bus decoding**               |        Y         |      Y      |      Y       |         Y         |    Y    |
| **Custom protocol decoding**       |        N         |      Y      |      Y       |         N         |    Y    |
| **Export binary**                  |        N         |      Y      |      Y       |         N         |    Y    |
| **Standalone SDK**                 | Y \[C library\]  |      N      |      Y       | Y \[C\# library\] |    N    |
| **Standalone SDK price**           |       FREE       |             |     FREE     |      $100.00      |         |
| **Continuous / streaming capture** |     N $$^2$$     |      N      |   Y $$^1$$   |     N $$^2$$      |    N    |

$$^1$$ As long as the PC can keep up

$$^2$$ Ability to trigger capture after a full buffer is
transferred to PC

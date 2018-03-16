---
layout: default
title: Integer division and timer resolution
tags: timer accuracy integer division c
comments: true
---

I have this very specific need to send a list of pre-timed messages from an embedded system. Each message has a specific time when it needs to be sent out. The time is specified in milliseconds (ms) with respect to the previous message in the list. The first message being at time zero.

The algorithm to send messages out is very simple. I send out the first message, and arm a timer with the time of the second message. As soon as the timer expires, I send out the second message, and rearm the timer to send the third message, and so on. Thus, it is pretty clear that timer resolution is very important. Since the smallest integer time interval I require is 1 ms, a timer resolution of 1 ms or less would be ideal.

The embedded system I am dealing with, has a timer resolution of 2.5 ms i.e. 1 tick of the timer is 2.5 ms long. The timer routine does not accept a time of 0, 1 tick is the smallest integer value the routine expects. To convert time in milliseconds to ticks, I need a routine that can convert milliseconds to ticks. The conversion routine, putting it simply, would receive time in milliseconds, divide it by 2.5, and round the result to an integer value. I don't have access to floating point math though, so the routine I've developed looks like this

```c
typedef unsigned int uint32_t;
const unsigned short MULTIPLY_BY = 2;
const unsigned short DIVIDE_BY = 5; // never ever set to zero

uint32_t MillisToTicks(uint32_t timeInMillis, int *remainder)
{
    uint32_t timesTwo;
    uint32_t result;

    timesTwo = timeInMillis * MULTIPLY_BY;
    result =  timesTwo / DIVIDE_BY;
    *remainder += timesTwo % DIVIDE_BY;
    if (*remainder >= DIVIDE_BY)
    {
        result += 1;
        *remainder -= DIVIDE_BY;
    }
    else if(*remainder <= -1 * DIVIDE_BY && result > 1)
    {
        result -= 1;
        *remainder += DIVIDE_BY;
    }
    else if (result == 0)
    {
        result = 1;
        *remainder -= DIVIDE_BY - result;
    }
    return result;
}
```

MillisToTicks never returns zero. Dividing by 2.5 is the same as multiplying by 2 and dividing by 5\. 2 is read from a constant called MULTIPLY_BY and 5 from another constant called DIVIDE_BY. Since the integer division will produce a remainder, MillisToTicks requires a pointer to integer where it can store the remainder of the integer division. That remainder is updated and checked during each call. If it exceeds DIVIDE_BY, the result is incremented by one, and remainder decremented by DIVIDE_BY.

If the result of integer division is zero, I force it to a value of 1, and decrement remainder by DIVIDE_BY. Next time MillisToTicks gets called, if remainder is less than or equal to -DIVIDE_BY, I decrement result by 1, and increment remainder by DIVIDE_BY. Putting it simply, there will be moments when I'll stray away from timing the messages perfectly, but given enough messages, I'll stray back on track. To test that, I have implemented the following code

```c
int remainderMillisToTicks = 0;

uint32_t times1[] = {6, 6, 6, 2, 6, 6, 2, 2, 6, 6, 7, 8, 1, 1, 2, 3, 6, 20, 30, 9, 30, 100, 3000, 1, 1, 8000, 10000, 23, 1, 1, 19, 6, 5, 26, 201, 503, 901};

uint32_t times2[] = {6, 6, 6, 2, 6, 6, 2, 2, 6, 6, 7, 8, 503, 901, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 6, 20, 30, 9, 30, 100, 3000, 1, 1, 8000, 10000, 23, 1, 1, 19, 6, 5, 26, 201, 503, 901};

uint32_t times3[] = {6, 6, 6, 2, 6, 6, 2, 2, 6, 6, 7, 8, 1, 1, 2, 3, 6, 20, 30, 9, 30, 100, 3000, 8000, 10000, 23, 19, 6, 5, 26, 201, 503, 901, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};

void test(uint32_t *times, unsigned short size)
{
    int i;
    uint32_t totalMillis = 0;
    uint32_t ticks = 0;
    double ticksToMillis = 0;
    double totalTicksToMillis = 0;

    for (i = 0; i < size; i++)
    {
        totalMillis += times[i];
        ticks = MillisToTicks(times[i], &remainderMillisToTicks);
        ticksToMillis = ((double)ticks*DIVIDE_BY) / MULTIPLY_BY;
        totalTicksToMillis += ticksToMillis;
        //printf("%d\t%f\t%d\t%d\t%f\n", times[i], ticksToMillis, remainderMillisToTicks, totalMillis, totalTicksToMillis);
    }
    printf("Ideal total time required: %d, time achieved: %f\n", totalMillis, totalTicksToMillis);
}

int main()
{
    test(times1, sizeof(times1) / sizeof(uint32_t));
    remainderMillisToTicks = 0;
    test(times2, sizeof(times2) / sizeof(uint32_t));
    remainderMillisToTicks = 0;
    test(times3, sizeof(times3) / sizeof(uint32_t));
}
```

Here's how the output of that test code looks like

```text
Ideal total time required: 22953, time achieved: 22952.500000
Ideal total time required: 24363, time achieved: 24362.500000
Ideal total time required: 22965, time achieved: 22985.000000
```

Enable the commented `printf` statement in test and you'll see a call by call log. At times, when the time value requested is too small, you'll see the messages stray away from perfect timing, and stray back to a normal cadence later. The overall time is thus unaffected or affected only slightly. The last call to test represents a failure condition that can only be avoided by using a higher resolution timer.

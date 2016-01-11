# GPIA-III

The General Purpose Interface Adapter (GPIA)
family of cores
are responsible for providing
parallel input and output service
to computing devices using the Wishbone interconnect.

Three generations have been defined;
this document describes the third generation.

**DISCLAIMER: The following material is preliminary.**

## History and Features

The following table describes the relative capabilities
of each GPIA family member.

|Core|Inputs|Outputs|Interrupts|Misc.|
|:--:|:----:|:-----:|:--------:|:----|
|GPIA|16|16|0||
|GPIA-II|64|64|0|Specified only for the Kestrel-3/E emulator.|
|GPIA-III|0-1024|0-1024|0-1024 sources routed to up to 16 interrupts|Based on [BERI Programmable Interrupt Controller concept](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-852.pdf).|

The GPIA-III offers vastly expanded I/O capabilities
to Wishbone-compatible devices.

* Up to 1024 inputs or outputs.
* Up to 1024 software-configurable data-direction bits.
* Atomic set, clear, or toggle of any output.
* Interrupt on any input or output, high or low level.
* Up to 16 interrupts on a single hardware thread.
* Two register windows provides flexibility in address space layout.

## Register Map 0

The first register map
addresses the actual I/O inputs and outputs.
The following address layout
allows a hardware thread or processor
to sample inputs, set outputs,
or set, clear, or toggle individual output bits.

|From|To |R/W|Purpose|
|:---|:--|:-:|:------|
|000 |07F|R|Sample inputs; pins configured as outputs will report their current output state.|
|000 |07F|W|Sets all output pins to the corresponding data values written.  Pins configured as inputs will not be affected.|
|080 |0FF|R|Undefined; reads as zeros.|
|080 |0FF|W|Pins with '1' written will be *set*; pins with '0' written will not change state.|
|100 |17F|R|Undefined; reads as zeros.|
|100 |17F|W|Pins with '1' written will be *cleared*; pins with '0' written will not change state.|
|180 |1FF|R|Undefined; reads as zeros.|
|180 |1FF|W|Pins with '1' written will be *toggled*; pins with '0' written will not change state.|

Each byte in this register map contains a packed bitmap
corresponding a set of I/O pins, like so:

    +00 |IO7   |IO6   |IO5   |IO4   |IO3   |IO2   |IO1   |IO0   |
    +01 |IO15  |IO14  |IO13  |IO12  |IO11  |IO10  |IO9   |IO8   |
     :
    +7F |IO1023|IO1022|IO1021|IO1020|IO1019|IO1018|IO1017|IO1016|

**NOTE**: Not all implementations of a GPIA-III may support all 1024 I/O pins.
The Kestrel-3 implementation of the GPIA-III core supports only 64 I/O pins.
Other application-specific implementations may support greater or fewer pins.
FPGA synthesis may result in pin elision if they're not used.

## Register Map 1

The second register map
addresses the core's configuration space.
Each pin has eight bytes reserved for it,
most of which remains undefined and hard-wired to zero
for reasons of future expansion.

    +0000 | Pin 0 configuration    |
    +0008 | Pin 1 configuration    |
      :
    +1FF8 | Pin 1023 configuration |

The following describes the configuration register for any given pin:

    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    |0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    |E|P|D|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0| IRQR  |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

**E**.  If 1, this interrupt pin is sampled for interrupt detection,
and the `P` pin works as described below.
If 0, this pin can never source an interrupt, and `P` is ignored.

**P**.  This pin is ignored if `E` is zero.
If 1, this pin will source an interrupt
if the corresponding input samples *low* at the next clock cycle.
If 0, this pin will source an interrupt
if the corresponding input samples *high* at the next clock cycle.
You can easily remember the impact of this pin by
remember that if **E** AND (pin XOR **P**) = 1,
an interrupt will occur.

**D**.  If 0, the corresponding pin is an *input*.
Otherwise, if 1, the pin is an *output*.
Note that outputs may still source interrupts if enabled.

**IRQR**.  If the corresponding pin raises an interrupt,
the GPIA-III needs to know which IRQ pin to assert.
The IRQR is used to provide this information.

|IRQR|IRQn|
|:--:|:--:|
|0000|IRQ0|
|0001|IRQ1|
|0010|IRQ2|
|0011|IRQ3|
|0100|IRQ4|
|0101|IRQ5|
|0110|IRQ6|
|0111|IRQ7|
|1000|IRQ8|
|1001|IRQ9|
|1010|IRQ10|
|1011|IRQ11|
|1100|IRQ12|
|1101|IRQ13|
|1110|IRQ14|
|1111|IRQ15|

**NOTE**: If the `P` and `D` bits are zero, full backward compatibility with
the BERI interrupt controller model is retained.

**NOTE**: The BERI model defines a *thread ID* field to start at bit 8, and extend for a suitable number of bits appropriate for your ASIC or FPGA application.  The GPIA-III only supports a single hardware thread.  However, you can still use the GPIA-III with multiple hardware threads by simply routing specific IRQs to specific cores.

## Notes on BERI Interrupt Controller Backward Compatibility

Upon start-up or reset,
all pins are configured as inputs,
all interrupts are disabled,
and all polarities are set to active-high.
Provided no `P` or `D` configuration bits are changed,
this should retain full backward compatibility
with the BERI interrupt controller model.

For compatibility with system software,
you should configure the GPIA-III so that
register window 1 appears immediately ahead of window 0.
This will provide a compatible register layout
as viewed by system software.


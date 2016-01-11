# GPIA-III

The General Purpose Interface Adapter (GPIA)
family of cores
are responsible for providing
parallel input and output service
to computing devices using the Wishbone interconnect.

Three generations have been defined;
this document describes the third generation.

## History

The following table describes the relative capabilities
of each GPIA family member.

|Core|Inputs|Outputs|Interrupts|Misc.|
|:--:|:----:|:-----:|:--------:|:----|
|GPIA|16|16|0||
|GPIA-II|64|64|0|Specified only for the Kestrel-3/E emulator.|
|GPIA-III|0-128|0-128|0-128|Based on BERI Programmable Interrupt Controller concept.|


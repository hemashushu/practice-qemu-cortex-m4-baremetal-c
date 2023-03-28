/* the entry point */
ENTRY(Reset_Handler)

/* memory layout of STM32F405RG */
/* https://www.st.com/en/microcontrollers-microprocessors/stm32f405rg.html */

MEMORY
{
  FLASH ( rx )      : ORIGIN = 0x08000000, LENGTH = 1024K
  RAM ( rxw )       : ORIGIN = 0x20000000, LENGTH = 128K
  CCM ( rxw )       : ORIGIN = 0x20020000, LENGTH = 64K
}

/*
 * vector table entry list and item name from
 * `STM32Cube_FW_F4_V1.27.1/Drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/gcc/startup_stm32f405xx.s`
 *
 * the keyword `PROVIDE` means:
 * set LHS = RHS only when the left symbol does not exists,
 * i.e. the RHS is the default value.
 *
 * it can also define handlers in `startup.c`, and remove all `PROVIDE(*_Handler = Default_Handler)` in linker.ld, e.g.
 *
 * ```c
 * void NMI_Handler() __attribute__((weak, alias("Default_Handler")));
 * void HardFault_Handler() __attribute__((weak, alias("Default_Handler")));
 * ```
 */

/* ------ index 0-15 ------ */
/* idx 0: _estack */
/* idx 1: Reset_Handler */
PROVIDE(NMI_Handler = Default_Handler);
PROVIDE(HardFault_Handler = Default_Handler);
PROVIDE(MemManage_Handler = Default_Handler); /* idx 4: 0 */
PROVIDE(BusFault_Handler = Default_Handler); /* idx 5: 0 */
PROVIDE(UsageFault_Handler = Default_Handler); /* idx 6: 0 */
/* idx 7: 0 */
/* idx 8: 0 */
/* idx 9: 0 */
/* idx 10: 0 */
PROVIDE(SVC_Handler = Default_Handler);
PROVIDE(DebugMon_Handler = Default_Handler);/* idx 12: 0 */
/* idx 13: 0 */
PROVIDE(PendSV_Handler = Default_Handler);
PROVIDE(SysTick_Handler = Default_Handler);

/* ------ index 16- ------ */
PROVIDE(WWDG_IRQHandler = Default_Handler); /* Window Watchdog */
PROVIDE(PVD_IRQHandler = Default_Handler);
PROVIDE(TAMP_STAMP_IRQHandler = Default_Handler);
PROVIDE(RTC_WKUP_IRQHandler = Default_Handler);
PROVIDE(FLASH_IRQHandler = Default_Handler);
PROVIDE(RCC_IRQHandler = Default_Handler);
PROVIDE(EXTI0_IRQHandler = Default_Handler);
PROVIDE(EXTI1_IRQHandler = Default_Handler);
PROVIDE(EXTI2_IRQHandler = Default_Handler);
PROVIDE(EXTI3_IRQHandler = Default_Handler);
PROVIDE(EXTI4_IRQHandler = Default_Handler);
PROVIDE(DMA1_Stream0_IRQHandler = Default_Handler);
PROVIDE(DMA1_Stream1_IRQHandler = Default_Handler);
PROVIDE(DMA1_Stream2_IRQHandler = Default_Handler);
PROVIDE(DMA1_Stream3_IRQHandler = Default_Handler);
PROVIDE(DMA1_Stream4_IRQHandler = Default_Handler);
PROVIDE(DMA1_Stream5_IRQHandler = Default_Handler);
PROVIDE(DMA1_Stream6_IRQHandler = Default_Handler);
PROVIDE(ADC_IRQHandler = Default_Handler);

PROVIDE(CAN1_TX_IRQHandler = Default_Handler);
PROVIDE(CAN1_RX0_IRQHandler = Default_Handler);
PROVIDE(CAN1_RX1_IRQHandler = Default_Handler);
PROVIDE(CAN1_SCE_IRQHandler = Default_Handler);
PROVIDE(EXTI9_5_IRQHandler = Default_Handler);
PROVIDE(TIM1_BRK_TIM9_IRQHandler = Default_Handler);
PROVIDE(TIM1_UP_TIM10_IRQHandler = Default_Handler);
PROVIDE(TIM1_TRG_COM_TIM11_IRQHandler = Default_Handler);
PROVIDE(TIM1_CC_IRQHandler = Default_Handler);
PROVIDE(TIM2_IRQHandler = Default_Handler);
PROVIDE(TIM3_IRQHandler = Default_Handler);
PROVIDE(TIM4_IRQHandler = Default_Handler);
PROVIDE(I2C1_EV_IRQHandler = Default_Handler);
PROVIDE(I2C1_ER_IRQHandler = Default_Handler);
PROVIDE(I2C2_EV_IRQHandler = Default_Handler);
PROVIDE(I2C2_ER_IRQHandler = Default_Handler);
PROVIDE(SPI1_IRQHandler = Default_Handler);
PROVIDE(SPI2_IRQHandler = Default_Handler);
PROVIDE(USART1_IRQHandler = Default_Handler);
PROVIDE(USART2_IRQHandler = Default_Handler);
PROVIDE(USART3_IRQHandler = Default_Handler);
PROVIDE(EXTI15_10_IRQHandler = Default_Handler);
PROVIDE(RTC_Alarm_IRQHandler = Default_Handler);
PROVIDE(OTG_FS_WKUP_IRQHandler = Default_Handler);
PROVIDE(TIM8_BRK_TIM12_IRQHandler = Default_Handler);
PROVIDE(TIM8_UP_TIM13_IRQHandler = Default_Handler);
PROVIDE(TIM8_TRG_COM_TIM14_IRQHandler = Default_Handler);
PROVIDE(TIM8_CC_IRQHandler = Default_Handler);
PROVIDE(DMA1_Stream7_IRQHandler = Default_Handler);
PROVIDE(FSMC_IRQHandler = Default_Handler);
PROVIDE(SDIO_IRQHandler = Default_Handler);
PROVIDE(TIM5_IRQHandler = Default_Handler);
PROVIDE(SPI3_IRQHandler = Default_Handler);
PROVIDE(UART4_IRQHandler = Default_Handler);
PROVIDE(UART5_IRQHandler = Default_Handler);
PROVIDE(TIM6_DAC_IRQHandler = Default_Handler);
PROVIDE(TIM7_IRQHandler = Default_Handler);
PROVIDE(DMA2_Stream0_IRQHandler = Default_Handler);
PROVIDE(DMA2_Stream1_IRQHandler = Default_Handler);
PROVIDE(DMA2_Stream2_IRQHandler = Default_Handler);
PROVIDE(DMA2_Stream3_IRQHandler = Default_Handler);
PROVIDE(DMA2_Stream4_IRQHandler = Default_Handler);
/* 0 */
/* 0 */
PROVIDE(CAN2_TX_IRQHandler = Default_Handler);
PROVIDE(CAN2_RX0_IRQHandler = Default_Handler);
PROVIDE(CAN2_RX1_IRQHandler = Default_Handler);
PROVIDE(CAN2_SCE_IRQHandler = Default_Handler);
PROVIDE(OTG_FS_IRQHandler = Default_Handler);
PROVIDE(DMA2_Stream5_IRQHandler = Default_Handler);
PROVIDE(DMA2_Stream6_IRQHandler = Default_Handler);
PROVIDE(DMA2_Stream7_IRQHandler = Default_Handler);
PROVIDE(USART6_IRQHandler = Default_Handler);
PROVIDE(I2C3_EV_IRQHandler = Default_Handler);
PROVIDE(I2C3_ER_IRQHandler = Default_Handler);
PROVIDE(OTG_HS_EP1_OUT_IRQHandler = Default_Handler);
PROVIDE(OTG_HS_EP1_IN_IRQHandler = Default_Handler);
PROVIDE(OTG_HS_WKUP_IRQHandler = Default_Handler);
PROVIDE(OTG_HS_IRQHandler = Default_Handler);
/* 0 */
/* 0 */
PROVIDE(HASH_RNG_IRQHandler = Default_Handler);
PROVIDE(FPU_IRQHandler = Default_Handler);

/*
 * use the `EXTERN` statement to preserve symbols that NOT directly or
 * indirectly referenced by the entry point.
 */
EXTERN(Reset_Handler);
EXTERN(Exceptions);

/* the stack point is the end address of RAM, i.e. `0x20000000 + 0x5000` */
_estack = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS
{

  /* The vector table goes at the start of flash. */
  .vector_table :
  {
    /* first entry: the initial Stack Pointer (SP) value */
    LONG(_estack);

    /* the next 15 entries are exception vectors */
    /* keyword `KEEP` means that it is kept even if no other item refers to it. */
    KEEP(*(.vector_table.exceptions));
  } >FLASH

  /* The 'text' section contains the main program code. */
  .text : ALIGN(4)
  {
    *(.text .text.*);
  } > FLASH

  /* The 'rodata' section contains read-only data,
   * constants, strings, information that won't change.
   */
  .rodata : ALIGN(4)
  {
    *(.rodata .rodata.*);
  } > FLASH

  /* The 'data' section is space set aside in RAM for
   * things like variables, which can change.
   *
   * set the Load Memory Address (LMA) of the `.data` section by
   * `AT(...)` at header line or `AT > FLASH` at footer line
   */
  .data : ALIGN(4) /* AT(ADDR(.rodata) + SIZEOF(.rodata)) */
  {
    _sdata = .;
    *(.data .data.*);
    _edata = .;
  } >RAM AT >FLASH

  /**
   * get the LMA of the section `.data`
   * - 3.1 Basic Linker Script Concepts
   *   https://sourceware.org/binutils/docs/ld/Basic-Script-Concepts.html
   * - 3.6.8.2 Output Section LMA
   *   https://sourceware.org/binutils/docs/ld/Output-Section-LMA.html
   * - LOADADDR(section)
   *   https://sourceware.org/binutils/docs/ld/Builtin-Functions.html#index-LOADADDR_0028section_0029
   */
  /* LMA of .data */
  _sidata = LOADADDR(.data);

  /* The 'bss' section is similar to the 'data' section,
   * but its space is initialized to all 0s at the
   * start of the program. */
  .bss : ALIGN(4)
  {
    _sbss = .;
    *(.bss .bss.*);
    _ebss = .;
  } >RAM

  . = ALIGN(4);
  _heap_start = .;

  /* Discarded sections */
  /DISCARD/ :
  {
    *(.ARM.exidx .ARM.exidx.* .ARM.extab.*);
  }
}
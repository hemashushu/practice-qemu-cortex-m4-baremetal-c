/**
 * Copyright (c) 2022 Hemashushu <hippospark@gmail.com>, All rights reserved.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
#include <stdint.h>
#include <stdbool.h>
// #include <assert.h>
#include <string.h>
#include <stdlib.h>

#include "stm32f405xx.h"

volatile uint32_t s_ticks;

void systick_init()
{
    // SysTick clock source is the `HCLK`, which is called `SystemCoreClock` in CMSIS.
    // NOTE:
    // `SystemCoreClock = SYSCLK / AHB Prescaler`

#ifdef QEMU
    const uint32_t HCLK = 168 * 1000 * 1000; // default QEMU HCLK is 168MHz
#else
    const uint32_t HCLK = 16 * 1000 * 1000;     // default real hardware HCLK is 16MHz
#endif

    const uint32_t ticks_per_second = HCLK;                         // SysTick count 1 per HCLK
    const uint32_t ticks_per_millisecond = ticks_per_second / 1000; // 1ms

    // assert(ticks_per_millisecond <= 0xffffff); // systick max 24bit

    SysTick->LOAD = ticks_per_millisecond - 1;
    SysTick->VAL = 0;
    SysTick->CTRL = (1 << SysTick_CTRL_ENABLE_Pos) |
                    (1 << SysTick_CTRL_TICKINT_Pos) |
                    (1 << SysTick_CTRL_CLKSOURCE_Pos);

    RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN;
}

void delay_ms(uint32_t milliseconds)
{
    uint32_t end_ticks = s_ticks + milliseconds; // maybe overflow
    while (s_ticks < end_ticks)
    {
        (void)0;
    }
}

void usart1_init(void)
{
    // from STM32F405 datasheet
    // p.55 Table 7. STM32F40xxx pin and ball definitions(1) (continued)
    // https://www.st.com/resource/en/datasheet/stm32f405rg.pdf
    //
    // PA9  - USART1_TX, AF7
    // PA10 - USART1_RX, AF7

    RCC->APB2ENR |= RCC_APB2ENR_USART1EN;

    const uint32_t GPIO_MODE_AF = 0b10;
    const uint32_t GPIO_AFR_7 = 0b0111;

    // config TX pin
    RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
    GPIOA->MODER &= ~(GPIO_MODER_MODER9_Msk);
    GPIOA->MODER |= (GPIO_MODE_AF << GPIO_MODER_MODER9_Pos);

    GPIOA->AFR[1] &= ~(GPIO_AFRH_AFSEL9_Msk);
    GPIOA->AFR[1] |= (GPIO_AFR_7 << GPIO_AFRH_AFSEL9_Pos);

    // config RX pin
    RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
    GPIOA->MODER &= ~(GPIO_MODER_MODER10_Msk);
    GPIOA->MODER |= (GPIO_MODE_AF << GPIO_MODER_MODER10_Pos);

    GPIOA->AFR[1] &= ~(GPIO_AFRH_AFSEL10_Msk);
    GPIOA->AFR[1] |= (GPIO_AFR_7 << GPIO_AFRH_AFSEL10_Pos);

    // config USART1
    // from RM0090 Reference manual
    // p.1010 30.6.4 Control register 1 (USART_CR1)
    // https://www.st.com/resource/en/reference_manual/rm0090-stm32f405415-stm32f407417-stm32f427437-and-stm32f429439-advanced-armbased-32bit-mcus-stmicroelectronics.pdf

    // disable USART1 first
    USART1->CR1 &= ~(1 << USART_CR1_UE_Pos);

    // per RM0090 Reference manual
    // 30.3.4 Fractional baud rate generation
    //
    // Only USART1 and USART6 are clocked with PCLK2.
    // Other USARTs are clocked with PCLK1. Refer to the device
    // datasheets for the maximum values for PCLK1 and PCLK2.

#ifdef QEMU
    const uint32_t APB2_CLK = 168 * 1000 * 1000; // default QEMU PCLK2 is 168MHz
#else
    const uint32_t APB2_CLK = 16 * 1000 * 1000; // default real hardware PCLK2 is 16MHz
#endif

    const uint32_t baud_rate = 115200; // 115200 BPS

    // round() the value rather than floor() it, for more
    // accurate divisor selection.
    const uint32_t baud = (APB2_CLK + baud_rate / 2) / baud_rate;

    USART1->BRR = baud;

    // let other parameters keep default value
    //
    // - Bit 12 M: Word length
    //   - 0: 1 Start bit, 8 Data bits, n Stop bit
    //   - 1: 1 Start bit, 9 Data bits, n Stop bit
    //
    // - Bit 10 PCE: Parity control enable
    //   - 0: Parity control disabled
    //   - 1: Parity control enabled

    // - Bit 3 TE: Transmitter enable
    USART1->CR1 |= (1 << USART_CR1_TE_Pos);

    // - Bit 2 RE: Receiver enable
    USART1->CR1 |= (1 << USART_CR1_RE_Pos);

    USART1->CR1 |= (1 << USART_CR1_UE_Pos);
}

void send_char(char c)
{
    USART1->DR = c;

    // Bit 7 TXE: Transmit data register empty
    //     This bit is set by hardware when the content of the TDR register has been transferred into
    //     the shift register. An interrupt is generated if the TXEIE bit =1 in the USART_CR1 register. It
    //     is cleared by a write to the USART_DR register.
    // - 0: Data is not transferred to the shift register
    // - 1: Data is transferred to the shift register)
    while ((USART1->SR & USART_SR_TXE) == 0)
    {
        (void)0;
    }
}

void send_string(const char *str)
{
    while (*str != '\0')
    {
        send_char(*str);
        str++;
    }
}

int main(void)
{
    systick_init();
    usart1_init();

    char text_prefix[] = "Ticks: ";
    char text_new_line[] = "\r\n";
    char number_buffer[24];
    char dest_buffer[48];

    while (true)
    {
        itoa(s_ticks, number_buffer, 10);
        strcpy(dest_buffer, text_prefix);
        strcat(dest_buffer, number_buffer);
        strcat(dest_buffer, text_new_line);

        send_string(dest_buffer);
        delay_ms(1000);
    }
}

void SysTick_Handler(void)
{
    s_ticks++;
}
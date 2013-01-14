with AVR;
use AVR;

with AVR.Timer1;
with AVR.MCU;
with AVR.Interrupts;
with AVR.UART;

package body Sound is
   Volume: Unsigned_16;
   Playing: Boolean;
   procedure Init is
   begin
      Timer1.Init_PWM(Timer1.No_Prescaling, Timer1.Phase_Freq_Correct_PWM_ICR, False);
      MCU.DDRB_Bits(5) := True;         --  set OC1A as output
      Volume := 80;
      MCU.OCR1A := Volume;
      Playing := False;
      UART.Put_Line("Sound initialized");
   end Init;

   procedure Update is                  --  plays alert sound
   begin
      if Playing then
         UART.Put_Line("Sound pause");
         Pause;
         Playing := False;
      else
         UART.Put_Line("Sound playing");
         PlayTone(310);
         Playing := True;
      end if;
   end Update;

   procedure PlayTone(Period: Unsigned_16) is
   begin
      Interrupts.Disable_Interrupts;
      MCU.TCCR1B_Bits(MCU.CS10_Bit) := True;
      MCU.ICR1 := Period;
      MCU.TCNT1 := 0;
      Interrupts.Enable_Interrupts;
   end PlayTone;

   procedure Pause is
   begin
      MCU.TCCR1B_Bits(MCU.CS10_Bit) := False;
   end Pause;
end Sound;

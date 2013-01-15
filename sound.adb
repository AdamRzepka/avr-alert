with AVR;
use AVR;

with AVR.Timer1;
with AVR.MCU;
with AVR.Interrupts;
with AVR.UART;

package body Sound is
   Volume: Unsigned_16 := 80;
   Playing: Boolean := False;
   Started: Boolean := False;
   procedure Init is
   begin
      Timer1.Init_PWM(Timer1.No_Prescaling, Timer1.Phase_Freq_Correct_PWM_ICR, False);
      MCU.DDRB_Bits(5) := True;         --  set OC1A as output
      MCU.OCR1A := Volume;
      UART.Put_Line("Sound initialized");
   end Init;

   procedure Update is                  --  plays alert sound
   begin
      if Started then
         if Playing then
            UART.Put_Line("Sound pause");
            Pause;
            Playing := False;
         else
            UART.Put_Line("Sound playing");
            PlayTone(310);
            Playing := True;
         end if;
      end if;
   end Update;

   procedure Start is
   begin
      Started := True;
--      Playing := False;
   end Start;

   procedure Stop is
   begin
      Pause;
      Started := False;
      Playing := False;
   end Stop;

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
      MCU.PORTB_Bits(5) := True;             -- Leave OC1A in high state
   end Pause;
end Sound;

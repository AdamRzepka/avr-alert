with Interfaces;
use Interfaces;

with AVR;
use AVR;

with AVR.MCU;
with AVR.UART;
with AVR.Interrupts;
with AVR.Timer2;
with AVR.Sleep;
with AVR.Wait;

with Temperature;


package body Timer is
   Counter: Unsigned_16 := 0;
   I: Unsigned_8 := 0;
   procedure Timer_Handler;
   pragma Machine_Attribute(Entity => Timer_Handler, Attribute_Name => "signal");
   pragma Export(C, Timer_Handler, MCU.Sig_TIMER2_COMP_String);

   procedure Timer_Handler is
      procedure Wait is
         new Wait.Generic_Busy_Wait_Milliseconds(Crystal_Hertz =>2_000_000);
   begin
--      Wait(1);
      UART.Put_Line("Wake UP!!!");
      UART.Put(Integer_16(Temperature.Read));
      UART.New_Line;
      UART.Put_Line("Go to sleep");
--      Wait(10);
   end Timer_Handler;

   procedure Init is
   begin
      Interrupts.Disable_Interrupts;
      Timer2.Init_CTC(AVR.Timer2.Scale_By_128, 255);
      Interrupts.Enable_Interrupts;
      AVR.Sleep.Set_Mode(AVR.Sleep.Idle);
   end Init;

   procedure Sleep is
      procedure Wait is
         new Wait.Generic_Busy_Wait_Milliseconds(Crystal_Hertz =>2_000_000);
   begin
      loop
--         Wait(1);
         avr.Sleep.Go_Sleeping;
--         Wait(1);

--           Counter := Counter + 1;
--           if Counter = 1024 then
--              Counter := 0;
--              I := I + 1;
--              if I = 255 then
--                 I := 0;
--              end if;
--              UART.Put(I);
--              --  UART.Put(Integer_16(Temperature.Read));
--              --  UART.New_Line;
--           end if;
--           --      Sleep;
--           Interrupts.Disable_Interrupts;
--  --         Wait(1000);
--           Interrupts.Enable_Interrupts;
      end loop;
   end Sleep;

end Timer;

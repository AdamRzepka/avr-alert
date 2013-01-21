--  with Interfaces;
--  use Interfaces;

with AVR;
use AVR;

with AVR.MCU;
with AVR.Interrupts;
with AVR.Timer2;
with AVR.Sleep;


package body Timer is
   Callback: Update_Callback_T := null;

   procedure Timer_Handler;
   pragma Machine_Attribute(Entity => Timer_Handler, Attribute_Name => "signal");
   pragma Export(C, Timer_Handler, MCU.Sig_TIMER2_COMP_String);

   procedure Timer_Handler is
   begin
      if Callback /= null then
         Callback.all;
      end if;
   end Timer_Handler;

   procedure Init is
   begin
      Interrupts.Disable_Interrupts;
      Timer2.Init_CTC(AVR.Timer2.Scale_By_128, 255);
      Interrupts.Enable_Interrupts;
      AVR.Sleep.Set_Mode(AVR.Sleep.Idle);
   end Init;

   procedure Register_Callback(Update_Callback: Update_Callback_T) is
   begin
      Callback := Update_Callback;
   end Register_Callback;


   procedure Sleep is
   begin
      loop
         AVR.Sleep.Go_Sleeping;
      end loop;
   end Sleep;

end Timer;

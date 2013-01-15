with Interfaces;
use Interfaces;
with AVR;
use AVR;

with AVR.UART;

with Temperature;
with Timer;
with Sound;

package body Application is
   procedure Update is
   begin
      UART.Put_Line("In Update.");
      UART.Put(Integer_16(Temperature.Read));
      UART.New_Line;
      if Temperature.Is_Changing_Fast then
         Sound.Start;
      end if;
      Sound.Update;
   end Update;
   
   procedure Run is
   begin
      -- inicjalizacja transmisji RS-232
      UART.Init(12);
      UART.Put_Line("Program starts");

      Temperature.Init;
      Sound.Init;
      Timer.Init;
      Timer.Register_Callback(Update'Access);
      Timer.Sleep;
   end;
end Application;

with AVR;
use AVR;

with AVR.UART;
--with AVR.Wait;

with Temperature;
with Timer;
with Sound;

procedure Avralert is
   --  procedure Wait is
   --     new Wait.Generic_Busy_Wait_Milliseconds(Crystal_Hertz =>2_000_000);

begin
   -- inicjalizacja transmisji RS-232
   UART.Init(12);
   UART.Put_Line("Program starts");

   Temperature.Init;
   Sound.Init;
   Timer.Init;
   Timer.Sleep;

   --  loop
   --     Temp := Temperature.Read;
   --     UART.Put(Integer_16(Temp));
   --     UART.New_Line;
   --     Wait(1000);
   --  end loop;
end Avralert;

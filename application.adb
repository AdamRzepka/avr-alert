with Interfaces;
use Interfaces;
with AVR;
use AVR;

with AVR.UART;

with Temperature;
with Timer;
with Sound;
with Button;

package body Application is
   procedure Update is
   begin
--      UART.Put_Line("In Update.");
      UART.Put(Integer_16(Temperature.Read));
      UART.New_Line;
      if Temperature.Is_Changing_Fast then
         Sound.Start;
      end if;
      Sound.Update;
   end Update;

   Playing: Boolean := False;

   procedure Button_Callback is
      Direction: Button.Button_Direction;
   begin
--      UART.Put_Line("In Button_Callback");
      Direction := Button.Get;
      case Direction is
         when Button.Enter =>
            UART.Put_Line("Enter");
            if Playing then
               Sound.Stop;
               Playing := False;
            else
               Sound.Start;
               Playing := True;
            end if;
         when Button.Up =>
            UART.Put_Line("Up");
         when Button.Down =>
            UART.Put_Line("Down");
         when Button.Left =>
            UART.Put_Line("Left");
         when Button.Right =>
            UART.Put_Line("Right");
         when Button.Nil =>
            UART.Put_Line("Nil");
      end case;
   end Button_Callback;

   procedure Run is
   begin
      -- inicjalizacja transmisji RS-232
      UART.Init(12);
      UART.Put_Line("Program starts");

      Temperature.Init;
      Sound.Init;
      Timer.Init;
      Timer.Register_Callback(Update'Access);
      Button.Init;
      Button.Register_Callback(Button_Callback'Access);
      Timer.Sleep;
   end Run;
end Application;

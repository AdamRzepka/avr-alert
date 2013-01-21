with Interfaces;
use Interfaces;
with AVR;
use AVR;

with AVR.UART;

with Temperature;
with Timer;
with Sound;
with Button;
with LCD_Driver;
with LCD_Functions;

package body Application is
   Playing: Boolean := False;
   procedure Update is
      Temp: Temperature.Temp_T;
   begin
      Temp := Temperature.Read;
      if not Playing then
         LCD_Driver.Scroll_Mode := LCD_Driver.None;
         LCD_Driver.Scroll_Offset := 0;
         LCD_Functions.Clear;
         LCD_Functions.Put(5, Unsigned_8(Temp));
      end if;
      UART.Put(Integer_16(Temp));
      UART.New_Line;
      if Temperature.Is_Changing_Fast then
         Sound.Start;
         LCD_Functions.Clear;
         LCD_Functions.Put("ALERT!");
         Playing := True;
      end if;
      Sound.Update;
   end Update;


   procedure Button_Callback is
      Direction: Button.Button_Direction;
   begin
--      UART.Put_Line("In Button_Callback");
      Direction := Button.Get;
      case Direction is
         when Button.Enter =>
--            UART.Put_Line("Enter");
            if Playing then
               LCD_Functions.Clear;
               LCD_Functions.Put("DEACTIVATED");
               Temperature.Clear_Amplitude;
               Sound.Stop;
               Playing := False;
            --  else
            --     Sound.Start;
            --     Playing := True;
            end if;
         when others => null;
         --  when Button.Up =>
         --     UART.Put_Line("Up");
         --  when Button.Down =>
         --     UART.Put_Line("Down");
         --  when Button.Left =>
         --     UART.Put_Line("Left");
         --  when Button.Right =>
         --     UART.Put_Line("Right");
         --  when Button.Nil =>
         --     UART.Put_Line("Nil");
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
      LCD_Driver.Init;
      LCD_Functions.Put("ENABLED");
      Timer.Sleep;
   end Run;
end Application;

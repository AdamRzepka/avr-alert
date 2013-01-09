with Interfaces;
use Interfaces;

with AVR;
use AVR;

with AVR.UART;
with AVR.ADC;
with AVR.Wait;
with AVR.MCU;

procedure Temperature is
   procedure Wait is
      new Wait.Generic_Busy_Wait_Milliseconds(Crystal_Hertz =>2_000_000);
   --  pragma Inline_Always (Wait);
   type Temp_T is range -15..60;

   function Calc_Temp(Adc_Out: ADC.Conversion_10bit) return Temp_T
   is
      T: Temp_T;
      -- stablicowana funkcja obliczania temperatury (z dokl. do 1 st C)
      Table: constant array(Temp_T) of ADC.Conversion_10bit :=
        (923,917,911,904,898,891,883,876,868,860,851,843,834,825,815,
         806,796,786,775,765,754,743,732,720,709,697,685,673,661,649,
         636,624,611,599,586,574,562,549,537,524,512,500,488,476,464,
         452,440,429,418,406,396,385,374,364,354,344,334,324,315,306,
         297,288,279,271,263,255,247,240,233,225,219,212,205,199,193,
         187);
   begin
      T := 0; -- initial value
      for I in Temp_T loop
         if Table(I) <= Adc_Out then
            T := I;
            exit;
         end if;
      end loop;
      return T;
   end Calc_Temp;

   TEMP_CHANNEL: constant ADC.ADC_Channel_T := 0;
   Result: ADC.Conversion_10bit;
   Temp: Temp_T;
begin
   -- inicjalizacja transmisji RS-232
   UART.Init(12);
   UART.Put_Line("Program starts");

   -- inicjalizacja ADC
   ADC.Init(ADC.Scale_By_8, ADC.Ext_Ref);

   loop
      -- wlaczenie napiecia dla termistora
      MCU.PORTF_Bits(MCU.PORTF3_Bit) := True;
      MCU.DDRF_Bits(MCU.DDF3_Bit) := True;
      -- odczytanie pomiaru
      Result := ADC.Convert_10bit(TEMP_CHANNEL);
      -- wylaczenie napiecia na termistorze (dla oszczedzenia energii)
      MCU.PORTF_Bits(MCU.PORTF3_Bit) := False;
      MCU.DDRF_Bits(MCU.DDF3_Bit) := False;

      Temp := Calc_Temp(Result);
      UART.Put(Integer_16(Temp));
      UART.New_Line;
      Wait(1000);
   end loop;
end Temperature;

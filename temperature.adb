with Interfaces;
use Interfaces;

with AVR;
use AVR;

with AVR.ADC;
with AVR.MCU;
with AVR.UART;

package body Temperature is

   type Temp_Record is
      record
         Value: ADC.Conversion_10bit;
         Timestamp: Unsigned_32;
      end record;

   Counter: Unsigned_32 := 0;
   Max: Temp_Record := (Value => 0, Timestamp => 0);
   Min: Temp_Record := (Value => 1023, Timestamp => 0);

   procedure Init is
   begin
      -- inicjalizacja ADC
      ADC.Init(ADC.Scale_By_8, ADC.Ext_Ref);
   end Init;

   function Read return Temp_T is
      -- pomocnicza funkcja do przeliczania temperatury na podstawie wartosci ADC
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
      Counter := Counter + 1;
      -- wlaczenie napiecia dla termistora
      MCU.PORTF_Bits(MCU.PORTF3_Bit) := True;
      MCU.DDRF_Bits(MCU.DDF3_Bit) := True;
      -- odczytanie pomiaru
      Result := ADC.Convert_10bit(TEMP_CHANNEL);
      -- wylaczenie napiecia na termistorze (dla oszczedzenia energii)
      MCU.PORTF_Bits(MCU.PORTF3_Bit) := False;
      MCU.DDRF_Bits(MCU.DDF3_Bit) := False;

      if Result >= Max.Value or Counter - Max.Timestamp >= 30 then
         Max := (Value => Result, Timestamp => Counter);
      end if;

      if Result <= Min.Value or Counter - Min.Timestamp >= 30 then
         Min := (Value => Result, Timestamp => Counter);
      end if;

      Temp := Calc_Temp(Result);
      return Temp;
   end Read;

   function Is_Changing_Fast return Boolean is
      Amplitude: Integer_16;
   begin
      Amplitude := Integer_16(Max.Value) - Integer_16(Min.Value);
      UART.Put("Amplitude: ");
      UART.Put(Amplitude);
      UART.New_Line;
      return (Amplitude >= 4);
   end Is_Changing_Fast;

end Temperature;

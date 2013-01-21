package Temperature is
   type Temp_T is range -15..60;

   procedure Init;
   function Read return Temp_T;
   function Is_Changing_Fast return Boolean;
   procedure Clear_Amplitude;
end Temperature;

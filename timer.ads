package Timer is
   type Update_Callback_T is access procedure;
   procedure Init;
   procedure Register_Callback(Update_Callback: Update_Callback_T);
   procedure Sleep;
end Timer;

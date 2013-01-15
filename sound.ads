with Interfaces;
use Interfaces;

package Sound is
   procedure Init;
   procedure Update;
   procedure Start;
   procedure Stop;
private
   procedure PlayTone(Period: Unsigned_16);
   procedure Pause;
end Sound;

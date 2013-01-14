with Interfaces;
use Interfaces;

package Sound is
   procedure Init;
   procedure Update;
private
   procedure PlayTone(Period: Unsigned_16);
   procedure Pause;
end Sound;

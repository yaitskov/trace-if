module Debug.TraceEmbrace.ByteString where

import Data.ByteString.Lazy.Internal qualified as L
import Data.ByteString.Internal (ByteString(..))
import Data.Tagged
import Data.Maybe
import Prelude

-- | Show 'ByteString' structure.
--
-- >>> showLbsAsIs ("a" <> "b")
showLbsAsIs :: L.ByteString -> [ByteString]
showLbsAsIs L.Empty = []
showLbsAsIs (L.Chunk x xs) = x : showLbsAsIs xs

-- | Wrap value which has opaque 'Show' instance.
newtype ShowTrace a = ShowTrace { unShowTrace :: a }

instance Show (ShowTrace L.ByteString) where
  show = show . showLbsAsIs . unShowTrace

instance Show (ShowTrace ByteString) where
  show (ShowTrace bs@(BS fp len)) = "BS " <> show fp <> " " <> show len <> ":" <> show bs

instance Show (ShowTrace a) => Show (ShowTrace (Maybe a)) where
  show (ShowTrace x) = show (ShowTrace <$> x)

instance Show (ShowTrace a) => Show (ShowTrace (Tagged t a)) where
  show (ShowTrace x) = show (ShowTrace <$> x)

instance {-# OVERLAPPABLE #-} Show (ShowTrace a) => Show (ShowTrace [a]) where
  show (ShowTrace x) = show (ShowTrace <$> x)

instance {-# OVERLAPPING #-} Show (ShowTrace a) => Show (ShowTrace [Tagged t a]) where
  show (ShowTrace x) = show (fmap ShowTrace <$> x)

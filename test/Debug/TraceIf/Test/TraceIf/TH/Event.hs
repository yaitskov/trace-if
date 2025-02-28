module Debug.TraceIf.Test.TraceIf.TH.Event where

import Control.Lens
import Debug.TraceIf.Config
import Debug.TraceIf.Internal.TH
import Debug.TraceIf.Test.TraceIf.Config
import Test.Tasty.HUnit ((@=?))

unit_event_mode :: IO ()
unit_event_mode =
  withPrefixEnvVar thresholdConfig "" $ do
    one @=? $(setConfig (thresholdConfig & #mode .~ TraceEvent)
              >> tr poisonedId "tm") one

unit_event_trIo :: IO ()
unit_event_trIo =   withPrefixEnvVar thresholdConfig "" $ go one
  where
    go x = (x @=?) =<< foo x
      where
        foo y = $(setConfig (thresholdConfig & #mode .~ TraceEvent)
                  >> trIo [| pure () |] "foo/y") >> pure y

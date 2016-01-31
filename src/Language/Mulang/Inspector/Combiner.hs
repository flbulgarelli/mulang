module Language.Mulang.Inspector.Combiner (
  detect,
  negative,
  alternative,
  scoped,
  transitive) where

import Language.Mulang
import Language.Mulang.Inspector
import Language.Mulang.Explorer


detect :: ScopedInspection -> Expression -> [Binding]
detect inspection expression = filter (`inspection` expression) $ declaredBindingsOf expression

alternative :: Inspection -> Inspection -> Inspection
alternative i1 i2 expression = i1 expression || i2 expression

negative :: Inspection -> Inspection
negative f = not . f

scoped :: Inspection -> ScopedInspection
scoped inspection scope expression =  any inspection (expression // scope)

transitive :: Inspection -> ScopedInspection
transitive inspection binding code = any (`scopedInspection` code) . transitiveReferencedBindingsOf binding $ code
  where scopedInspection = scoped inspection



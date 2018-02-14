Notes de la séance 5 de Compil M2
=================================

  - Présentation du changement d'AST de Kontix (continuation locales anonymes):
    type `continuation_and_env` avec ses constructeurs`CurCont` et `PushCont`.
    Désolé pour le changement tardif (et le probable conflit lors du merge git),
    mais ça devrait être plus simple ainsi.
    
  - Exemple de nouvelle syntaxe concrète: [examples/fact.kx](../examples/fact.kx)
    
  - Exemple plus complexe, avec un `Def` dans un autre `Def`:
    [examples/defdef.fx](../examples/defdef.fx) et [examples/defdef.kx](../examples/defdef.kx).

  - Plus généralement, voici comment compiler un `Def(x,e1,e2)`
    avec une `continuation_and_env` actuelle `ke` et lorsque `e1`
    n'est pas "simple" (i.e. contient au moins un appel de fonction) :
     - On compile `e1` avec la continuation `PushCont(kontN,ke,ids)`
       ou `kontN` est un nouveau `function_identifier` et `ids` sont
       les variables qui seront utiles pour `e2`.
     - On génère aussi une nouvelle fonction continuation :
       `def kontN (x,[K,E,ids...]) = ...` où `x` est la variable
       du `Def` de départ, et `ids` les variables utiles comme avant,
       et enfin le corps de cette fonction est la compilation de `e2`
       avec la continuation `CurCont`.
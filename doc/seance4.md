Notes de la séance 4 de Compil M2
=================================

  - Visite guidée de Kontix et en particulier de son AST.
    Pour sa syntaxe concrète, voir les fichiers
    exemples [examples/fact.kx](../examples/fact.kx) et [examples/ack.kx](../examples/ack.kx).

  - Remarques complémentaires :
     - On évitera les fonctions Fopix à 0 arguments (sinon le parser
       de Kontix ne distinguera pas bien un `TContCall` d'un `TFunCall`)
     - Dans un `PushEnv`, je pensais que le `actual_env` interne ne pouvait
       pas être un autre `PushEnv`, mais en fait si! (détails en séance 5).

  - Pourquoi passer par Anfix pour produire du Kontix ?
    Cela limite les points délicats lors du passage à Kontix,
    en concentrant la difficulté sur le traitement du `Def`
      
  - Remarque convernant FopixToJavix:
    On doit pouvoir traiter `IfThenElse(e,...,...)` même si
    `e` n'est pas directement un `BinOp`.
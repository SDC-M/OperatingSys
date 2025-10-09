#import "@preview/ilm:1.4.1": *
#import "@preview/diagraph:0.3.3": *
#import "@preview/codly:1.2.0": *
#import "@preview/lilaq:0.5.0" as lq
#import "@preview/cetz:0.4.2"
#cetz.canvas({
  import cetz.draw: *
})
#show: codly-init

#import "@preview/codly-languages:0.1.8": *
#codly(languages: codly-languages)


#set text(
  font: "Cascadia Mono",
  lang: "FR",
)


#show: ilm.with(
  title: [Introduction aux systèmes d'exploitation],
  author: "",
  abstract: [#emph[Ceci est un support non officiel, qui a pour but de regrouper l'ensemble des notions vues en cours d'introduction aux systèmes d'exploitation dispensé en deuxième année de licence informatique à l'UFR sciences et techniques du Madrillet par le professeur *ZIADI DJELLOUL* Il est non exhaustif et collaboratif. 
  Ce document est à jour pour l'année universitaire *2025-2026*. Pour toute suggestion, ouvrez une issue sur le dépôt GitHub. Merci aux contributeurs : #underline[#link("https://github.com/SDC-M/Introduction-aux-syst-mes-d-exploitation.git")] ]
  Le support se décompose en deux parties. Premièrement des rappels de cours avec des exemples commentés ainsi que des définitions puis une partie avec des exercices corrigés.],
  date: datetime(year: 2025, month: 10, day: 9),
  date-format: "9 Octobre 2025",
  chapter-pagebreak: false,
  figure-index: (enabled: false),
  table-index: (enabled: true),
  listing-index: (enabled: false),
)

#set page(
  paper: "a4",
  margin: (x: 2cm, y: 2cm),
)

#set block(spacing: 1.1em)

#set table(
  stroke: black,
  fill: (x, y) =>
    if  y == 0 { gray },
  inset: (right: 0.5em),
)

#set par(
  justify: true,
  leading: 1.25em,
  spacing: 2.2em 
)

#set heading(numbering: "1.")

#pagebreak()
= *Chapitre 1: Introduction et gestion des processus*
== Introduction
#linebreak()
Un système d'exploitation est un #text(red)[*logiciel intermediaire*] remplissant deux fonctions principales: 

#list(indent: 2em)[Assurer la #text(red)[*gestion efficace*] des périphériques matériels (le clavier, l’écran, le disque, la mémoire, le processeur, ...)][Offrir aux programmes une #text(red)[*interface abstraite*] et simplifiée pour interagir avec le matériel, sans en connaître les détails techniques.]

Le système d'exploitation optimise et sécurise l'utilisation des ressources en répartissant le temps *CPU* entre les différents processus on parle d'ordonnencement. 

Alloue libère la mémoire utilisée pour chaque processus.

Gère et sécurise les lectures / écritures ainsi que l'organisation des fichiers sur le disque (arborescence de fichier).
#linebreak()
#linebreak()

=== Types de systèmes d'exploitation
#linebreak()

#list(indent: 2em)[*Mainframes* : traitement de très gros volumes de données (ex. IBM z/OS).][*Serveurs* : gestion des services réseaux (ex. Linux, Windows Server).][*Multiprocesseurs* : exploitation de plusieurs CPU en parallèle.][*Personnels* : ordinateurs individuels, interface conviviale (ex.Windows, macOS).][*Temps réel* : respect de délais stricts, applications critiques (ex.VxWorks).][*Embarqués* : systèmes pour appareils spécifiques (ex. Android, FreeRTOS).][*Cartes à puce* : ultra-légers et sécurisés (ex. Java Card).]

== Les normes
#linebreak()
Les normes sont un moyen d'assurer la portabilité ainsi que la durabilité d'un code, pour cela nous disposons de différents niveaux de certifications afin de mesurer la qualité du code produit. 

#linebreak()

=== POSIX
#linebreak()
Créée en 1983 par Institute of Electrical and Electronics Engineers - IEEE https://posix.opengroup.org/.

Standard définissant une #text(red)[*interface commune pour les systèmes d’exploitation*] de type UNIX.

Garantit la portabilité des applications entre différents systèmes detype UNIX.

Pour définir le respect des normes POSIX avec GCC il suffit de définir *\_POSIX_SOURCE* pour demander le respect général de POSIX ou bien *\_POSIX_C_SOURCE* pour activer des fonctionalités spécifiques selon la version : "Année + Mois + L". 

#linebreak()

=== SUS
#linebreak()
#text(red)[*La Single UNIX Specification (SUS)*] est une norme définie et gérée par The Open Group.

Fin des années 1990 : POSIX devient un sous-ensemble de la SUS. Tous les systèmes UNIX certifiés respectent POSIX.

Pour définir le respect de la norme SUS avec GCC il suffit de définir *\_XOPEN_SOURCE* pour demander le respect général de SUS. Le chiffre "X" correspondant à l aversion majeure de SUS souhaitée. Vous retrouverez l'ensemble des informations dans le manuel avec la commande : ```bash man 7 standards```

#linebreak()

== Les appels systèmes
== Fonctionnement
#linebreak()
Un appel système est une interface entre un programme utilisateur et le noyau du système
d’exploitation. Il donne accès à des ressources protégées (fichiers, réseau, mémoire, ...) Il s'exécute en mode noyau pour réaliser des tâches privilligiées. 
Les appels système provoquent donc un passage du mode utilisateur au mode noyau.

#linebreak()
==== Mode Noyau vs Mode Utilisateur
#linebreak()
*Le mode utilisateur* :
- Espace où s'exécutent les applications.
- Accès limité aux ressources matérielles.
- Protection contre les erreurs utilisateur.

#linebreak()
*Le mode noyau* :
- Espace privilligié pour le système d'exploitation.
- Accès direct au matériel.
- Gère les appels système et les interruptions.
#linebreak()

=== Les interruptions
#linebreak()

Gestion des erreurs
- En cas d’erreur : la fonction retourne -1.
- Le code d’erreur est stocké dans la variable globale errno.
- Utiliser perror() ou strerror(errno) pour afficher un message compréhensible

#linebreak()
== Gestion des erreurs
#linebreak()
#align(center)[
  #table(
    columns: (auto, auto, auto, auto),
    inset: 10pt,
    table.header(
      [*Fonction*], [*POSIX*], [*Thread-safe*], [*Recommandation*],
      [perror()], [Oui], [Oui], [exemples simples],
      [strerror()], [Oui], [Non], [À éviter en multithread],
      [strerror_r()], [Oui], [Oui], [Préfèrée en multithread]
    ),
    stroke: 1pt
  )
]
#linebreak()
Les recommandations sont donc :
- Programmes simples : perror() ou stererror()
- Programmes modernes / multithread : strerrors_r() (POSIX)
#linebreak()

=== appels sytèmes vs bibliothèque standard
#linebreak()
#align(center)[
  #table(
    columns: (auto, auto, auto),
    inset: 10pt,
    table.header(
      [], [*Appels Système*], [*Bibliothèque Standart*],
      [*Niveau*], [Bas niveau], [Haut niveau],
      [*Portabilité*], [Dépend du système], [Portable],
      [*Complexité*], [Plus complèxe], [Plus simple],
      [*Exemple*], [write], [printf]
    ),
    stroke: 1pt
  )
]
#linebreak()
== Les processus
#linebreak()
L'un des premiers choix de conception que nous devons faire lors de la conception d'une application multitâches sera : *processus* ou *threads*. Chacune des approches possède son lot d'avantages et d'inconvéniants.

Les processus s'exécutent dans des espaces mémoires distincts. Ceci est très important : *chaque processus dispose d'une zone de mémoire totalement indépendante et protégée des autres processus.*

#linebreak()
=== Création
#linebreak()
Le seul moyen que nous possèdons pour créer des processus est de passer par l'appel système ```C fork()``` qui va dupliquer le processus appelant. Au retour de cet appel système, deux processus identiques continueront d'exécuter le code à la suite de ```c fork()```. La différence essentielle entre ces deux processus est un numéro d'identification. On distingue le processus père du processus fils par leur *PID*. (processus identicatifier). Que l'on pourrait changer au cours du programme si nécéssaire avec l'appel système ```C setuid()```.

De plus, l'orsqu'un processus est créé il dispose d'une copie des données de son père, mais également de l'environnement de celui-ci notamment la *table des descripteurs de fichiers*. De plus chaque processus appartient à un ou plusieurs groupes *GID*.

#linebreak()
=== Cycle de vie

#align(center)[
  #adjacency(
  (
    (none, none, "Allocation", "Exit", none),
    ("Admis", none, none, none, none),
    ("Requisition", none, none, none, "Attente d'événement             "),
    (none, none, none, none, none),
    ("Fin d'événement", none, none, none, none)
  ),
  vertex-labels: (
     "Prêt", "Nouveau", "Actif", "Terminé", "Bloqué"
  )
  )
  #underline[#emph[Automate représentant le cycle de vie d'un processus]]
]
#linebreak()

=== Terminaison
#linebreak()
Il existe différents types de terminaisons d'un processus:

- Arrêt normal (volontaire) Le programme s’exécute jusqu’à la fin prévue. Exemple : retour de main() avec *return 0*;

- Arrêt suite à une erreur (volontaire) Le programme détecte une erreur et décide de se terminer. Exemple : appel à *exit(EXIT_FAILURE)*;

- Arrêt pour erreur fatale (involontaire) Le système arrête le processus à cause d’une faute grave. Exemple :*segmentation fault*.

- Arrêt forcé par un autre processus (involontaire) Un signal externe met fin au processus. Exemple : *kill -9 PID*.
#linebreak()

=== Sessions de processus
#linebreak()
Il existe finalement un dernier regroupement de processus, *les sessions*, qui réunissent divers groupes de processus. Ce sont principalement les appplications s'exécutant en *arrière plan* qui utilisent les sessions. De manière générale une session est attachée à un terminal de contrôle, celui qui a servi à la connexion de l'utilisateur. Au sein d'une session, un groupe de processus est en avant-plan. Il reçoit directement les données aisies sur le clavier du terminal, et peut afficher ses informations de sortie sur l'écran de celui-ci. Les autres groupes de processus de la session s'exécutent en arrière plan.

La création d'une session s'effectue par l'appel système ```C setsid()```. 

#linebreak()

=== Recouvrement des processus
#linebreak()
Le recouvrement d'un processus dégine le remplacement de son image mémoire par un nouveau programme. Il est réalisé via la famille d'appels système *exec*. Le recouvrement implique donc que nous conservons la même entrée dans la table des processus. Les appels système sont:

#linebreak()

- execl: `int execl(const char *pathname, const char *arg, ... /*, (char *) NULL */);`
- execle: `int execle(const char *pathname, const char *arg, ... /*, (char *) NULL, char *const envp[] */);`
- execlp: `int execlp(const char *file, const char *arg, ... /*, (char *) NULL */);`
- execv: `int execv(const char *pathname, char *const argv[]);`
- execv: `int execvp(const char *file, char *const argv[]);`
- execvpe: `int execvpe(const char *file, char *const argv[], char *const envp[]);`
#linebreak()
Ces fonctions sont des variantes de l’appel système execve, offrant
différentes façons de passer les arguments et l’environnement.

Les noms des fonctions exec sont construits avec une combinaison de suffixes, chacun ayant une signification précise:

#linebreak()
- *l (List)* : Les arguments de la ligne de commande sont passés sous forme d’une liste de paramètres individuels à la fonction.

- *v (Vector)* : Les arguments sont transmis via un tableau de chaînes de caractères.

- *p (Path)* : La fonction recherche l’exécutable dans les répertoires de la variable d’environnement PATH.

- *e (Environment)* : Le dernier paramètre est un tableau de variables d’environnement à transmettre.
#linebreak()

== Ordonnancement
#linebreak()
L'ordonnancement des pricessus un principe fondamental de la matière, en effet,  à un instant donnée, plusieurs processus peuvent être en concurrence pour l'utilisation du processeur. Il faut donc choisir quel processus sera executé et à quel moment, cette décision est prise par *l'ordonnenceur* qui lui même suit une *politique d'ordonnancement*.

=== Ordonnancement préemptif vs non préemptif
#linebreak()

#underline[*Ordonnancement non préemptif*:]
- Une fois choisi, le processus garde le processeur jusqu’à ce qu’il se termine, ou se bloque (par exemple en attente d’une E/S).
- L’ordonnanceur n’intervient pas avant ce moment.
#linebreak()
#underline[*Ordonnancement préemptif*:]
- Le processus ne garde le processeur que pour un temps limité (quantum de temps)
- À l’expiration de ce délai, l’ordonnanceur peut choisir un autre processus, même si le premier n’a pas fini.
- Permet une meilleure réactivité et un partage équitable du CPU.

=== Mesures de performance
#linebreak()

Pour mesurer la performance des différentes politiques on utilise différents indicateurs:


#linebreak()

- Temps de réponse: Le temps écoulé entre la soumission d’un processus (son arrivée dans la file d’attente) et le moment où il commence à s’exécuter pour la première fois. *Temps de réponse = Temps de première exécution - Temps d’arrivée*

- Temps de rotation: Le temps total écoulé entre la soumission d’un processus et son achèvement complet. *Temps de rotation = Temps de fin - Temps d’arrivée*

- Temps d’attente: La somme de toutes les périodes pendant lesquelles un processus est prêt à s’exécuter et attend dans la file d’attente (Prêt). *Temps d’attente = Temps de rotation - Temps d’exécution CPU total.*

#linebreak()

=== Les différentes politiques
==== Premier Arrivé, Premier Servi (FCFS)
#linebreak()
Ordonnancement non préemptif où les processus sont exécutés dans l’ordre d’arrivée.

#underline[*Mécanisme*:]
- Une seule file d'attente pour les processus crées.
- Le suivant est exécuté si un processus se bloque.
- Un processus débloqué est replacé en fin de file.

#linebreak()

==== Job le Plus Court en Premier (SJF)
#linebreak()
Ordonnancement non préemptif nécessitant les durées d’exécution à l’avance.

#underline[*Mécanisme*:]
- Liste des processus triée par durée.
- L'ordonnanceur choisit le processus le plus court.
- Optimal pour le délai de rotation si tous arrivent en même temps.

#linebreak()

==== Tourniquet (Round Robin)
#linebreak()

Algorithme préemptif avec un quantum de temps par processus.

#underline[*Mécanisme*:]
- Chaque processus reçoit un intervalle (quantum) d’exécution.
- Interruption à la fin du quantum, passage au suivant.
- File d’attente pour les processus prêts.

#linebreak()
Attention au choix du quantum, s'il est trop court dans ce cas on aura un coût élevé pour le changement de contexte, dans le cas contraire s'il est trop long nous aurons un temps de réponse lent pour les interactions.

=== Exemple complet
#linebreak()

Pour illustrer ces différentes politiques d'ordonnancement nous allons prendre un exemple et appliquer chacune des politiques, nous comparerons alors celles-ci avec les différents indicateurs que nous avons énumérés précedemment.

*Premier Arrivé, Premier Servi (FCFS):*
#align(center)[
  #table(
    columns: (auto, auto, auto, auto, auto, auto),
    inset: 9pt,
    table.header(
      [*Processus*], [*arrivé*], [*demandé*], [*réponse*], [*rotation*],[*attente*],
      [*A*], [*#text(fill: red, "0")*], [*#text(fill: blue, "3")*], [*3 - 0 = 3*], [*3 - 0 = 3*], [*3 - 3 = 0*], 
      [*B*], [*#text(fill: red, "2")*], [*#text(fill: blue, "6")*], [*9 - 2 = 7*], [*9 - 2 = 7*], [*7 - 6 = 1*],
      [*C*], [*#text(fill: red, "4")*], [*#text(fill: blue, "4")*], [*13 - 4 = 9*], [*13 - 4 = 9*], [*9 - 4 = 5*],
      [*D*], [*#text(fill: red, "6")*], [*#text(fill: blue, "5")*], [*18 - 6 = 12*], [*18 - 6 = 12*], [*12 - 5 = 7*],
      [*E*], [*#text(fill: red, "8")*], [*#text(fill: blue, "2")*], [*20 - 8 = 12*], [*20 - 8 = 12*], [*12 - 2 = 10*],
      [*#text(fill: purple, "Moyenne")*], [], [], [*#text(fill: purple, "4,6")*], [#text(fill: purple, "8,6")], [*#text(fill: purple, "4,6")*],
    ),
    stroke: 1pt
  )
]

#linebreak()
#let axis-args = (
  ticks: 1, 
  format-subticks: lq.format-ticks-linear
)
#align(center)[
  #lq.diagram(
    title: [Diagramme de Gantt de la méthode : FCFS],
    width: 15cm,
    height: 8cm,
    ylim: (0, 6),
    xlim: (0, 20),
    yaxis: (ticks: range(1, 6).zip(([A], [B], [C], [D], [E]))),
    lq.plot((0, 1, 2, 3), (1, 1, 1, 1), color: red),
    lq.plot((2, 3), (2, 2), color: gray),
    lq.plot((3, 4, 5, 6, 7, 8, 9), (2, 2, 2, 2, 2, 2, 2), color: red),
    lq.plot((4, 5, 6, 7, 8, 9), (3, 3, 3, 3, 3, 3), color: gray),
    lq.plot((9, 10, 11, 12, 13), (3, 3, 3, 3, 3), color: red),
    lq.plot((6, 7, 8, 9, 10, 11, 12, 13), (4, 4, 4, 4, 4, 4, 4, 4), color: gray),
    lq.plot((13, 14, 15, 16, 17, 18), (4, 4, 4, 4, 4, 4), color: red),
    lq.plot((8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18), (5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5), color: gray),
    lq.plot((18, 19, 20), (5, 5, 5), color: red)

  )
]
#pagebreak()

*Job le Plus Court en Premier (SJF):*
#align(center)[
  #table(
    columns: (auto, auto, auto, auto, auto, auto),
    inset: 9pt,
    table.header(
      [*Processus*], [*arrivé*], [*demandé*], [*réponse*], [*rotation*],[*attente*],
      [*A*], [*#text(fill: red, "0")*], [*#text(fill: blue, "3")*], [*0 - 0 = 0*], [*3 - 0 = 3*], [*3 - 3 = 0*], 
      [*B*], [*#text(fill: red, "2")*], [*#text(fill: blue, "6")*], [*3 - 2 = 1*], [*9 - 2 = 7*], [*7 - 6 = 1*],
      [*C*], [*#text(fill: red, "4")*], [*#text(fill: blue, "4")*], [*11 - 4 = 7*], [*15 - 4 = 11*], [*15 - 4 = 11*],
      [*D*], [*#text(fill: red, "6")*], [*#text(fill: blue, "5")*], [*15 - 6 = 9*], [*20 - 6 = 14*], [*14 - 5 = 9*],
      [*E*], [*#text(fill: red, "8")*], [*#text(fill: blue, "2")*], [*11 - 8 = 3*], [*11 - 8 = 3*], [*3 - 2 = 1*],
      [*#text(fill: purple, "Moyenne")*], [], [], [*#text(fill: purple, "4")*], [#text(fill: purple, "7,6")], [*#text(fill: purple, "4,4")*],
    ),
    stroke: 1pt
  )
]

#linebreak()
#let axis-args = (
  ticks: 1, 
  format-subticks: lq.format-ticks-linear
)
#align(center)[
  #lq.diagram(
    title: [Diagramme de Gantt de la méthode SJF],
    width: 15cm,
    height: 8cm,
    ylim: (0, 6),
    xlim: (0, 20),
    yaxis: (ticks: range(1, 6).zip(([A], [B], [C], [D], [E]))),
    lq.plot((0, 1, 2, 3), (1, 1, 1, 1), color: red),
    lq.plot((2, 3), (2, 2), color: gray),
    lq.plot((3, 4, 5, 6, 7, 8, 9), (2, 2, 2, 2, 2, 2, 2), color: red),
    lq.plot((4, 5, 6, 7, 8, 9, 10, 11), (3, 3, 3, 3, 3, 3, 3, 3), color: gray),
    lq.plot((6, 7, 8, 9, 10, 11, 12, 13, 14, 15), (4, 4, 4, 4, 4, 4, 4, 4, 4, 4), color: gray),
    lq.plot((8, 9), (5, 5), color: gray),
    lq.plot((9, 10, 11), (5, 5, 5), color: red),
    lq.plot((11, 12, 13, 14, 15), (3, 3, 3, 3, 3), color: red),
    lq.plot((15, 16, 17, 18, 19, 20), (4, 4, 4, 4, 4, 4), color: red)
  )
]
Liste du plus court à l'instant x = ?:

0 : A

3 : B

9 : E -> C -> D

11 : C -> D

15 : D

#pagebreak()

*Tourniquet Round Robin (RR) : Choix du quantum = #text(fill: red, "2")*
#align(center)[
  #table(
    columns: (auto, auto, auto, auto, auto, auto),
    inset: 9pt,
    table.header(
      [*Processus*], [*arrivé*], [*demandé*], [*réponse*], [*rotation*],[*attente*],
      [*A*], [*#text(fill: red, "0")*], [*#text(fill: blue, "3")*], [*0 - 0 = 0*], [*2 - 0 = 2*], [*2 - 2 = 0*], 
      [*B*], [*#text(fill: red, "2")*], [*#text(fill: blue, "6")*], [*2 - 2 = 0*], [*19 - 2 = 17*], [*17 - 6 = 11*],
      [*C*], [*#text(fill: red, "4")*], [*#text(fill: blue, "4")*], [*4 - 4 = 0*], [*15 - 4 = 11*], [*11 - 4 = 7*],
      [*D*], [*#text(fill: red, "6")*], [*#text(fill: blue, "5")*], [*6 - 6 = 0*], [*20 - 6 = 14*], [*14 - 5 = 9*],
      [*E*], [*#text(fill: red, "8")*], [*#text(fill: blue, "2")*], [*8 - 8 = 0*], [*10 - 8 = 2*], [*2 - 2 = 0*],
      [*#text(fill: purple, "Moyenne")*], [], [], [*#text(fill: purple, "0")*], [#text(fill: purple, "9.2")], [*#text(fill: purple, "5,4")*],
    ),
    stroke: 1pt
  )
]

#linebreak()
#let axis-args = (
  ticks: 1, 
  format-subticks: lq.format-ticks-linear
)
#align(center)[
  #lq.diagram(
    title: [Diagramme de Gantt de la méthode RR],
    width: 15cm,
    height: 8cm,
    ylim: (0, 6),
    xlim: (0, 20),
    yaxis: (ticks: range(1, 6).zip(([A], [B], [C], [D], [E]))),
    lq.plot((0, 1, 2),  (1, 1, 1), color: red),
    lq.plot((2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12),  (1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1), color: gray),
    lq.plot((2, 3, 4),  (2, 2, 2), color: red),
    lq.plot((4, 5, 6, 7, 8, 9, 10),  (2, 2, 2, 2, 2, 2, 2), color: gray),
    lq.plot((4, 5, 6),  (3, 3, 3), color: red),
    lq.plot((6, 7, 8, 9, 10, 11, 12, 13),  (3, 3, 3, 3, 3, 3, 3, 3), color: gray),
    lq.plot((6, 7, 8),  (4, 4, 4), color: red),
    lq.plot((8, 9, 10),  (5, 5, 5), color: red),
    lq.plot((10, 11, 12),  (2, 2, 2), color: red),
    lq.plot((12, 13),  (1, 1), color: red),
    lq.plot((8, 9, 10, 11, 12, 13, 14, 15),  (4, 4, 4, 4, 4, 4, 4, 4), color: gray),
    lq.plot((12, 13, 14, 15, 16, 17),  (2, 2, 2, 2, 2, 2), color: gray),
    lq.plot((13, 14, 15),  (3, 3, 3), color: red),
    lq.plot((15, 16, 17),  (4, 4, 4), color: red),
    lq.plot((17, 18, 19),  (2, 2, 2), color: red),
    lq.plot((17, 18, 19),  (4, 4, 4), color: gray),
    lq.plot((19, 20),  (4, 4), color: red),
  )
]
État de la file d'attente pour les processus prêts:

#align(center)[
  #table(
    columns: (auto, auto, auto, auto),
    inset: 8pt,
    table.header(
      [*T*], [*État de la file*], [*T*], [*État de la file*],
      [0], [A], [12], [A -> C -> D -> B], 
      [2], [B -> A], [13], [C -> D -> B], 
      [4], [C -> A -> B], [15], [D -> B], 
      [6], [D -> B -> A -> C], [17], [B -> D],
      [8], [E -> B -> A -> C -> D], [19], [D], 
      [10], [B -> A -> C -> D], [19], [#sym.emptyset]
    ),
    stroke: 1pt
  )
]

=== Time slicing
#linebreak()
Le time slicing est une technique d’ordonnancement où le temps CPU est divisé en petits intervalles égaux appelés *quanta* ou *tranches de temps*.

• Chaque processus s’exécute pendant un quantum de temps.

• À la fin du quantum, le processus est préempté.

• Le CPU est attribué au processus suivant dans la file d’attente.

• Crée l’illusion d’un parallélisme sur les systèmes mono-core.

Attention tout de même dans le cas ou nous dervions changer de contexte trop souvent cela créerait un *Overhead*. Dans le cas contraire un mauvais temps de réponse est donc une impression de latence. 

Dans le cas d'un exemple concret un calcul demandant beauocup de ressources CPU bloquerait toute interface graphique, alors qu'avec le time slicing nous pourrions continuer à l'utiliser.

Sous linux nous pouvons voir cette valeur avec la commande:
```bash
# en général 100ms
sudo cat /proc/sys/kernel/sched_rr_timeslice_ms
```

#linebreak()

=== Sous linux
#linebreak()

Sous linux il est possible de définir la politique d'ordonnancement grâce à ces différents appels système:
```c
• sched_setscheduler() - Définir la politique d’ordonnancement
• sched_getscheduler() - Obtenir la politique actuelle
• sched_setparam() - Définir les paramètres d’ordonnancement
• sched_getparam() - Obtenir les paramètres actuels
• sched_get_priority_max() - Priorité maximale pour une politique
• sched_get_priority_min() - Priorité minimale pour une politique
• sched_rr_get_interval() - Obtenir le quantum RR
• sched_setaffinity() - Définir l’affinité CPU
• sched_getaffinity() - Obtenir l’affinité CPU
```
== Les threads POSIX
#linebreak()
Un *thread* (ou « fil d’exézcution ») parfois appelés « *processus légers* », est l’unité fondamentale que le système d’exploitation planifie sur
un processeur. Il correspond à une séquence d’instructions qui s’exécute de manière indépendante en partageant l’espace d’adressage d’un processus.

Un même processus peut contenir un ou plusieurs threads, concurrents (sur un cœur) ou parallèle (sur plusieurs cœurs).

Chaque thread possède ses composants privés indispensables à son exécution:
- sa *propre pile d’exécution* (pour les variables locales et les appels de fonctions)
- son *contexte d’exécution* (état des registres du processeur et valeur du compteur ordinal)

#linebreak()
*#sym.plus.triangle #text(fill: red, "Attention: Tous les threads partagent la même mémoire globale!")*

#image("img/I-noeud.svg")
#align(right)[
  #underline[#emph[Schéma provenant du Cours de M.DJELLOUL]]
]
#linebreak()

=== Threads vs Processus
#linebreak()

#align(center)[
  #table(
    columns: (auto, auto),
    inset: 8pt,
    table.header(
      [*Processus*], [*Threads*],
      [Espace mémoire séparé], [Espace mémoire partagé],
      [Fichiers ouverts séparé], [Fichiers ouverts partagés],
      [Contexte d'exécution complet], [Contexte d'exécution minimal], 
      [Communication inter-processus], [Communication directe],
    ),
    stroke: 1pt
  )
]

#align(center)[
  #table(
    columns: (auto, auto),
    inset: 8pt,
    table.header(
      [*Avantages Processus*], [*Avantages Threads*],
      [Isolation & Stabilité], [Réponse améliorée],
      [Gestion fine des ressources], [Économie de ressources],
    ),
    stroke: 1pt
  )
]

=== Types de threads
#linebreak()

Il existe deux modèles principaux de gestion des threads:
1. Threads implantés dans l'espace utilisateur: *User-level Threads (ULTs)*

Threads gérés entièrement par une bibliothèque au niveau de l’application (espace utilisateur). Le noyau OS n’a pas connaissance de leur existence.

Ils ont pour avantage d'être très performant, car pas d'appel système, de plus ils sont portables car implémenter par une bibliothèque donc indépendante du noyau OS.

Cependant ils manquent de parallélisme réel, en effet un ULT bloquant bloque tous les threads du processus, de plus le scheduleur OS ne voir qu'un seul processus, ne peut pas répartir les threads sur plusieurs coeurs.

2.Threads implantés dans le noyau *Kernel-level Threads (KLTs)*

Threads gérés directement par le système d’exploitation. Le noyau planifie leur exécution.

Le noyau peut planifier différents threads sur différents cœurs CPU. Un thread bloqué (e.g., sur une E/S) n’affecte pas les autres. ccès direct aux services et ressources du noyau. De plus ils bénéficient des politiques de scheduling du noyau.

Cependant la création, commutation et destructions sont plus lentes (appels système). L'API dépend souvent de l'OS et chaque thread nécéssite des structures de données dans le noyeau.

#linebreak()

=== Création
#linebreak()

```c
nt pthread_create ( pthread_t * thread,
  const pthread_attr_t * attr,
  void *(* start_routine ) ( void *),
  void * arg );
```

• thread : Pointeur pour stocker l’identifiant du nouveau thread

• attr : Attributs du thread (NULL pour défaut)

• start_routine : Fonction exécutée par le thread

• arg : Argument passé à la fonction

• Retourne : 0 en cas de succès, code d’erreur sinon

On peut récupérer son identifiant avec:

```c
pthread_t pthread_self ( void );
```

Et comparer deux identifiants avec:
```c
int pthread_equal ( pthread_t thread1 , pthread_t thread2 );
```
#linebreak()
*#sym.plus.triangle #text(fill: red, "Attention: pthread_t est un type opaque et diffère en fonction des implémentations.")*

#linebreak()

=== Terminaison
#linebreak()

La fonction du thread se termine par un return, cependant pour une terminaison explicite nous devons faire un appel à la procédure:
```c
// depuis un autre processus
void pthread_exit ((void *) retval);

// attendre les threads secondaire dans le main
void pthread_exit (nullptr);
```

Cependant pour attendre explicitement nous pouvons faire appel à:
```c
pthread_join(th, nullptr);
```
#linebreak()

=== Attributs et états
#linebreak()
On caractérise les threads en deux catégories:


- #text(fill: red, "Joignable (par défaut)") : Doit être joint avec pthread_join:
  - Ressources conservées après terminaison
  - Nécessite un pthread_join() pour libérer les ressources
  
- #text(fill: red, "Détaché") : Ressources libérées automatiquement
  - Impossible de joindre le thread
  - Libération automatique à la terminaison

#linebreak()
*#sym.plus.triangle #text(fill: red, "L’appel à pthread_join() est bloquant jusqu’à ce que le thread attendu se termine. Le thread appelant est suspendu en attendant la terminaison du thread cible.")*


#pagebreak()
De plus la gestion des attributs nécéssite un petit peu de logistique. Voici un exemple complet qui sera plus démonstratif:
```c
# include <stdio.h>
# include <stdlib.h>
# include <pthread.h>
# include <unistd.h>

void *run (void * arg) {
  printf(" Thread démarré (détachable)\n");
  sleep(2);
  printf("Thread terminé\n");
  return nullptr;
}

int main (){
  pthread_t thread;
  pthread_attr_t attr;
  // Initialisation des attributs
  if(pthread_attr_init (&attr) != 0) {
    perror ("pthread_attr_init");
    exit(EXIT_FAILURE);
  }
  // Configuration du thread comme détachable
  if(pthread_attr_setdetachstate(&attr , PTHREAD_CREATE_DETACHED ) != 0) {
    perror("pthread_attr_setdetachstate");
    exit(EXIT_FAILURE);
  }
  // Configuration de la taille de la pile de 2 MB
  size_t stack_size = 2 * 1024 * 1024;
  if(pthread_attr_setstacksize(&attr, stack_size) != 0) {
    perror("pthread_attr_setstacksize") ;
    exit(EXIT_FAILURE) ;
  }
  // Création du thread avec attributs personnalisés
  if (pthread_create (&thread, &attr, run, nullptr) != 0) {
    perror("pthread_create");
    exit(EXIT_FAILURE);
  }
  // Destruction des attributs
  if (pthread_attr_destroy (&attr) != 0) {
    perror ("pthread_attr_destroy");
    exit(EXIT_FAILURE);
  }
  printf ("Thread Principal Terminé\n");
  pthread_exit(nullptr);
}
```

#linebreak()

== Problèmes de mémoire
#linebreak()

Il faut néanmoins faire attention aux variables auutomatiques qui seraient initialisées par un thread car ils sont allouées dans la pile du thread en question, il suffit qu'un pointeur soit renvoyé sur cette valeur puisque le thread se termine (libération des ressoucres de sa stack), nous nous retrouverions avec un référence invalide. Ce qui représente une faille de sécurité majeure mais également un comportement indéfini lors de la lecture de la mémoire à partir de ce pointeur. La bonne solution est donc d'allouer dynamiquement dans le tas avec un malloc, ce qui nous confère une gestion sécurisée de la mémoire pointée par celui-ci.

#linebreak()

== Bonnes pratiques
#linebreak()
=== Recommandations pour une application C portable
#linebreak()

-  *Respecter les Standards* :
  - Utiliser la norme C99 ou C11.
  -  Se conformer à l’API POSIX (```C #define _POSIX_C_SOURCE 200809L```).
- *Gérer les dépendances* :
  - Privilégier les bibliothèques standards.
  - Utiliser des outils de construction comme GNU Autotools ou CMake (outils standard de l’écosystème open-source).
- *Adhérer à la philosophie UNIX* :
  - Chaque programme fait une seule tâche.
  - Gérer les fichiers et les entrées/sorties via les descripteurs de fichiers.
  - Respecter la hiérarchie du système de fichiers.
- *Gérer les architectures* :
  - Utiliser des types de données de taille fixe (<stdint.h>).
  - Gérer l’ordre des octets (endianness) pour les données binaires (htons() et ntohl()) pour garantir la compatibilité.
- *Utiliser des constantes symboliques*: améliore la portabilité et évite les nombres dits "magique".

#linebreak()
#pagebreak()
= *Chapitre 2: Système de gestion de fichiers (SGF)*
#linebreak()

*#text(fill: red, "Concept fondamental : Sur Linux tout est fichier !")*

Un *système de fichiers* est la structure logique qui organise et gère le stockage des données sur un support physique (disque dur, SSD, clé USB). C’est le coeur du système qui gère le stockage, l’accès et la modification des fichiers.

#linebreak()

- *#text(fill: red, "Gestion de l’espace disque")* : Alloue et libère des blocs de mémoire de manière efficace pour optimiser le stockage.

- *#text(fill: red, "Organisation hiérarchique")* : Crée une structure en arborescenceavec des dossiers (répertoires) et des fichiers, facilitant la navigation.

- *#text(fill: red, "Gestion des métadonnées")* : Conserve les informations cruciales surchaque fichier (nom, taille, dates de création/modification, etc.).

- *#text(fill: red, "Contrôle d’accès")* : Gère les permissions pour déterminer qui peut lire, écrire ou exécuter un fichier.

#linebreak()
== Systèmes de gestion de fichiers
=== SGF vs SF
#linebreak()

#align(center)[
  #table(
    columns: (auto, auto),
    inset: 10pt,
    table.header(
      [*Système de Fichiers*], [*Système de Gestion de Fichiers*],
      [C'est la structure *logique*], [C'est la partie *logicielle* composante du noyeau],
      [Définit comment les fichiers sont organisés (arborescence)], [Gère toutes les opérations:  créer, lire, sipprimer..],
      [Exemple: le format ext4 de votre disque dur], [Assure la cohérence des données et les permissions],
    ),
    stroke: 1pt
  )
]

Le SGF utilise les règles du SF pour manipuler concrètement les données sur le support de stockage. Le SGF est l’implémentation du SF.

#linebreak()

== Structure interne d'un SF Ext
#linebreak()

#image("/img/SFext.svg")
#align(right)[
  #underline[#emph[Schéma de la structure interne d'un SF Ext]]
]

Le Système de Gestion de Fichiers (SGF) navigue dans cette structure. Pour lire un fichier, il utilise la table des i-noeuds pour trouver les blocs de données correspondants sur le disque.

Voici le détail d'un groupe de blocs:

- *#text(fill: red, "Superbloc")* : Informations générales sur l’ensemble du système de fichiers (taille, nombre d’inodes, etc.).

- *#text(fill: red, "Descripteurs de groupes de blocs")* : Contiennent des pointeurs vers les structures clés (bitmaps et tables d’inodes) de chaque groupe.

- *#text(fill: red, "Bitmap de blocs")* : Une carte des blocs de données, indiquant s’ils sont libres ou occupés.

- *#text(fill: red, "Bitmap d’inodes")* : Une carte des i-noeuds, indiquant s’ils sont libresou occupés.

- *#text(fill: red, "Table des i-noeuds")* : Le coeur du système. Chaque entrée (i-node)contient les métadonnées d’un fichier (emplacement, permissions, etc.).

- *#text(fill: red, "Blocs de données")* : Contiennent le contenu réel des fichiers.

#linebreak()

== Structure d'un i-noeud
#linebreak()

Un i-noeud (ou inode "index node") est une structure de données qui décrit un fichier. C’est l’identité d’un fichier, indépendante de son nom.

#image("/img/I-noeud.svg")
#align(right)[
  #underline[#emph[Schéma de la structure interne d'un i-noeud]]
]

Nous pouvons nous demander que contient vraiment un répertoire?
- Des noms de fichiers (lisible par l'utilisateur)
- Des numéros d'inode (référence du système)
#linebreak()

=== Opérations sur l’i-noeud
#linebreak()

Nous disposons de différents appels systèmes pour manipuler les i-noeuds:

```c
int stat(const char *path, struct stat *buf);
int fstat(int fd, struct stat *buf);
int lstat(const char *path, struct stat *buf);
```
#linebreak()

#text(fill: red, "Attention tout de même : lstat() retourne les informations du lien symbolique lui même, et non pas celles du fichier cible")

De plus nous disponsons d'une structure de données `struct stat` voici une énumération des métadonnées principales ainsi que leur appelation.

```c
dev_t st_dev; // Périphérique contenant le fichier
ino_t st_ino; // Numéro d’inode
mode_t st_mode; // Type et permissions du fichier
nlink_t st_nlink; // Nombre de liens physiques
uid_t st_uid; // UID du propriétaire
gid_t st_gid; // GID du propriétaire
off_t st_size; // Taille en octets
time_t st_atime; // Date dernier accès
time_t st_mtime; // Date dernière modification
time_t st_ctime; // Date dernier changement d’état
```

#linebreak()

=== Permissions sur les fichiers
#linebreak()

Les permissions de base:
- *#text(fill: red, "Propriétaire")* : S_IRUSR (r), S_IWUSR (w), S_IXUSR (x)
- *#text(fill: red, "Groupe")* : S_IRGRP (r), S_IWGRP (w), S_IXGRP (x)
- *#text(fill: red, "Autres")* : S_IROTH (r), S_IWOTH (w), S_IXOTH (x)

Nous disposons également d'appels systèmes afin de modifier ces permissions:
```c
int chmod(const char *path, mode_t mode);
int fchmod(int fd, mode_t mode);
```
#linebreak()
Il est également possible de modifier le propriétaire du fichier grâce aux appels systèmes suivants:
```c
int chown(const char *path, uid_t owner, gid_t group);
int fchown(int fd, uid_t owner, gid_t group);
int lchown(const char *path, uid_t owner, gid_t
group);
```
*#text(fill: red, "Seul root peut modifier le propriétaire et lchown() agit sur le lien symbolique lui-même.")*

#linebreak()

== Opérations sur les fichiers
#linebreak()
Nous disposons d'une multitude d'appels systèmes afin d'effectuer des opérations sur les fichiers, en voici une courte présentation, n'hésitez pas compléter avec la documentation officielle.

#linebreak()
Pour gérer l'ouverture d'un fichier:
```c
int open(const char *pathname, int flags, mode_tmode);
int creat(const char *pathname, mode_t mode);
```

Pour gérer la lecture / l'écriture dans un fichier:
```c
ssize_t read(int fd, void *buf, size_t count);
ssize_t write(int fd, const void *buf, size_t count);
off_t lseek(int fd, off_t offset, int whence);
```

Pour gérer les descripteurs:
```c
int dup(int oldfd);
int dup2(int oldfd, int newfd);
int close(int fd);
```

Pour gérer la taille d'un fichier:
```c
int truncate(const char *path, off_t length);
int ftruncate(int fd, off_t length);
```

#linebreak()

== Tables système de manipulation de fichiers
#linebreak()

#image("/img/table_systeme.svg")
#align(right)[
  #underline[#emph[Schéma de la structure  d'une table système]]
]

Les descripteurs de fichiers sont des entiers identifiant des fichiers / ressources ouvertes, la plage typique sous Linux est de 0 à 1024. Chaque processus possède sa propre table des descripteurs comme montrer ci-dessus.

Remarque: Les descripteurs peuvent égalemment representer des :
- Tubes (pipes)
- Sockets réseau
- Périphériques

#linebreak()

== Opération sur les fichiers
#linebreak()

L'ouverture de fichiers:
```c
# include <fcntl.h>
# include <sys/stat.h>

int open (const char *pathname, int flags);
int open (const char *pathname, int flags, mode_t mode);
```
#linebreak()
Les modes d'ouverture :

#align(center)[
  #table(
    columns: (auto, auto, auto),
    inset: 10pt,
    table.header(
      [*Mode de base*], [*Attributs de création*], [*Attributs d'état*],
      [O_RDONLY], [O_CREAT], [O_APPEND],
      [O_WRONLY], [O_EXCL], [O_SYNC],
      [O_RDWR], [O_TRUNc], []
    ),
    stroke: 1pt
  )
]

En ce qui concerne le mode d'ouverture il est à noté que nous avons un filtrage par *umask*. L'opération réalisée est donc le suivant:
#text(fill: red, "Permissions = mode & \~umask").

#linebreak()
=== L'effet de l'appel système open():
#linebreak()

#underline[Sur la table des descripteurs:]
- Ajoute une ntrée avec le plus petit descripteur disponible
- Pointe vers une entrée de la table des fichiers ouverts 

#underline[Sur la table des fichiers ouverts:]
- Crée toujours une nouvelle entrée même si le fichier est déjà ouvert
- Chaque open() crée une entrée indépendante
- Stocke position = 0 ou taille fichier (si O_APPEND), flags, pointeur vers inode

#underline[Sur la table des i-noeuds:]
- Charge l'inoeud en mémoire s'il n'est pas déjà présent
- Incrémente le compteur de référence ) chaque open()
- Met à jour st_atime sur accès.

#linebreak()
#text(fill: red, "Toujours verifier la valeur de retour du close").

#linebreak()
=== L'effet de l'appel système close():
#linebreak()

#underline[Sur la table des descripteurs:]
- Libère l'entrée du descripteur de fichier
- Le descripteur devient disponible pour la réutilisation

#underline[Sur la table des fichiers ouverts:]
- Décrémente le compteur de références.
- Supprime l'entrée si le compteur devient 0.
- Libère les buffers d'E/S associés (cache du système de fichiers, buffer réseau).

#underline[Sur la table des i-noeuds:]
- Décremente le compteur de références.
- Finalise l'écriture des données ou métadonnées modifiées sur le disque si nécéssaire.
- Peut libérer l'i-noeud en mémoire s'il n'est plus référencé.

#linebreak()
Nous disposons egalement de read(), write() & lseek(). Vous pouvez vous référencer au cours de M.Hancart d'Algo1 qui fournit une spécification complète sur le sujet.

Il est à notifier que la synchronisation des écritures est très intéréssantes pour les données critiques:

```c
# include < unistd .h >
void sync ( void ) ; // Synchronise tous les buffers du syst è me
int fsync ( int fd ) ; // Synchronise un fichier sp é cifique
int fdatasync ( int fd ) ; // Synchronise les donn é es ( pas m é tadonn é es )
```

#linebreak()

=== Duplication de descripetur de fichier dup & dup2
#linebreak()

```c
# include < unistd .h >
int dup ( int oldfd ) ;
int dup2 ( int oldfd , int newfd ) ;
```

Ces appels permettent à deux descripteurs de pointer vers le même fichier ouvert, partageant ainsi la même position courante.

- *dup2* est plus sûr que la combinaison close() + dup(), notamment dans un environnement multi-thread.
- En effet, entre close(STDOUT_FILENO) et dup(), un autre thread peut ouvrir un descripteur qui réutilisera STDOUT, entraînant un comportement inattendu.
- *dup2* évite ce risque en réalisant l’opération de manière atomique

#linebreak()

== Opérations sur les répertoires
#linebreak()

- Les fichiers sont organisés en répertoires (dossiers)
- Structure en arborescence avec imbrication
- Le répertoire racine est la base de l’arborescence
- Sous UNIX : symbolisé par /

#linebreak()

== Implémentation et manipulation
#linebreak()

Nous disposons de deux fonctions pour changer de répertoire:
```c
#include <stdio.h>
#include <unistd.h>

int main() {
  char cvd[1024];
  getcvd(cvd, sizeof(cvd));
  printf("Avant: %s\n", cvd);
  if (chdir("/tmp") == -1) {
    perror("chdir");
    return EXIT_FAILURE;
  }
  getcvd(cvd, sizeof(cvd));
  printf("Apres: %s\n", cvd);
  return EXIT_SUCCESS;
} 
```

et donc getcwd() pour récupérer le répertoire courant.

#linebreak()

== Manipulation des répertoires
#linebreak()

Fonctions principales:
- #text(fill: red, "Aopendir()") : ouvre un flux répertoire
- #text(fill: red, "Areaddir()") : lit une entrée
- #text(fill: red, "Aclosedir()") : ferme le flux

#linebreak()

Nous avons également accès à la structure de données `dirent` définit comme suit:
```c
struct dirent {
  ino_t d_ino ; // numéro i-noeud
  char d_name []; // nom du fichier
};
```
#linebreak()
Fonctions avancées:
- #text(fill: red, "rewinddir()") : retour au début
- #text(fill: red, "telldir") : position courante
- #text(fill: red, "scandir()") : lecture avec filtrage

#linebreak()

== Création et suppression
#linebreak()

Pour la création nous passons par la fonction :
```c
int mkdir(const char *pathname, mode_t mode);
```

Pour renomer / déplacer des fichiers:
```c
int rename(const char *oldpath, const char *newpath);
```

#linebreak()

== Récapitulatif des appels système
#linebreak()

#align(center)[
  #table(
    columns: (auto, auto, auto, auto),
    inset: 10pt,
    table.header(
      [*Appel*], [*Type*], [*Description*], [*Retour*],
      [open], [Fichier], [Ouvrir/créer un fichier], [Descripteur],
      [close], [Fichier], [Fermer un descripteur], [0 / -1],
      [read], [Fichier], [Lire des données], [Octets lus],
      [write], [Fichier], [Écrire des données], [Octets écrits],
      [opendir], [Répertoire], [Ouvrir un répertoire], [DIR\*],
      [readdir], [Répertoire], [Lire une entrée], [dirent\*],
      [closedir], [Répertoire], [Fermer le répertoire], [0 / -1],
      [mkdir], [Répertoire], [Créer un répertoire], [0 / -1],
      [rmdir], [Répertoire], [Supprimer répertoire vide], [0 / -1],
      [unlink], [Les deux], [Supprimer un lien], [0 / -1],
      [link], [Lien], [Créer lien physique], [0 / -1],
      [symlink], [Lien], [Créer lien symbolique], [0 / -1],
      [readlink], [Lien], [Lire cible lien symbolique], [Octets lus]
    ),
    stroke: 1pt
  )
]

#linebreak()

#align(center)[
  #rect(stroke: red, inset: (x: 25pt, y: 25pt), "Points clés à retenir
  Fichiers : manipulation du contenu (read/write)
  Répertoires : parcours et organisation (opendir/readdir)
  Liens : multiples noms pour un fichier (link/symlink)
  Gestion : création/suppression (mkdir/rmdir/unlink)")
]
  
#pagebreak()

= *Chapitre 3: Les tubes*
#linebreak()

Un tube est *un canal de communication unidirectionnel* qui relie un processus écrivain (qui envoie des données) à un *processus lecteur* (qui les reçoit). Les données circulent selon une logique *FIFO* (First In, First Out) et sont *stockées temporairement dans un tampon mémoire* géré par le noyau.

#linebreak()

#image("/img/tubesdef.svg")
#align(right)[
  #underline[#emph[Schéma de la structure d'un tube]]
]

#linebreak()

== Types de tubes sous Linux
#linebreak()

#image("/img/tubes.svg")
#align(right)[
  #underline[#emph[Schéma de la structure interne d'un tube anonyme & nommé]]
]

#linebreak()

=== Tubes nommés vs tubes anonymes
#linebreak()

#align(center)[
#table(
  columns: (auto, auto, auto, auto, auto),
  inset: 10pt,
  table.header(
    [*Type*], [*Création*], [*Portée*], [*Persistance*], [*Visibilité*],
    [Tubes Anonymes], [pipe()], [Processus parent enfant uniquement], [Durée de vie des processus], [Invisible dans le système de fichiers],
    [Tubes Nommés (FIFOs)], [mkfifo() ou mknod()], [Tous les processus du système], [Durée du système de fichiers], [Fichier spécial (type'p')]
  ),
  stroke: 1pt
  )
]

*#text(fill: red, "Les données dans le tube sont volatiles et stockées uniquement dans les buers noyau.")*

Exemple shell:
```sh
Tube anonyme
ps aux | wc -l
# Tube nomm é
mkfifo tube
echo " test " > tube &
cat < tube
```

#linebreak()

== Création et ouverture tube anonyme
#linebreak()

Nous utilisons l'appel système `pipe()`:
```c
#include <unistd.h>

int tube[2]
int pipe(int tube[2])
```
Description : Créer un tube et retourne deux descripteurs de fichiers :
- tube[0] : Extrémité de lecture.

- tube[1] : Extrémité d'écriture.
 Retourne 0 en cas de succès, -1 en cas d'erreur.

#underline[Effet sur les tables système]:

#image("/img/pipe_effect.svg")
#align(right)[
  #underline[#emph[Schéma de l'effet du pipe() sur les tables système]]
]
#linebreak()

#pagebreak()
Séquence d'exécution de pipe():

#linebreak()
1. Allocation inode virtuel dans la table des inodes en mémoire
2. Création structure pipe_inode_info en mémoire
3. Lien inode vers structure pipe
4. Création deux entrées(resp. Read et Write) dans la table des chiers
5. Lien chier vers inode virtuel
6. Allocation de deux descripteurs dans le processus
7. Lien descripteurs vers entrée chiers respectives
8. Initialisation compteurs (readers=1, writers=1)

#linebreak()

=== Contenu de l'i-noeud virtuel d'un tube
#linebreak()

#align(center)[
#table(
  columns: (auto, auto),
  inset: 10pt,
  table.header(
    [*Champ*], [*Valeur pour un tube*],
    [i_mode], [S_IFIFO (fichier FIFO)],
    [i_pipe], [Pointeur vers pipe_inode_info],
    [i_size], [Taille des données dans le tampon],
    [i_count], [Compteur de références],
    [i_op], [Opérations pipes (pipe_iops)],
    [i_fop], [Opérations fichiers (pipefifo_fops)]
  ),
  stroke: 1pt
)
]

#linebreak()

=== Structure pipe_inode_info
#linebreak()

#align(center)[
#table(
  columns: (auto, auto),
  inset: 10pt,
  table.header(
    [*Champ*], [*Description*],
    [bufs], [Tableau de buffers circulaires],
    [head], [Position de lecture],
    [tail], [Position d'écriture],
    [*readers*], [Nombre de lecteurs actifs],
    [*writers*], [Nombre d'écrivains actifs],
    [wait], [File d'attente pour blocage],
    [lock], [Verrou pour synchronisation],
    [r_counter], [Compteur de lectures],
    [w_counter], [Compteur d'écritures]
  ),
  stroke: 1pt
)
]


#linebreak()

== Création et ouverture tube nommé
#linebreak()

Nous utilisons les appels système `mkfifo() & open()`.
```c
#include <unistd.h>
int mkfifo(const char *pathname, mode_t mode);
int open(const char *pathname, int flags);
```
#linebreak()
Description :

- Crée un tube nommé pathname dans le système de chiers avec les permissions mode. 
- Retourne 0 en cas de succès, -1 en cas d'erreur.

L'appel open pour un tube nommé en mode non-bloquant (O_NONBLOCK) diffère selon le mode lecture ou écriture:

Lecture (open("montube", O_RDONLY | O_NONBLOCK)): 
- Ouvre immédiatement, retourne un descripteur même sans écrivain.

- Raison : Un lecteur peut attendre des données ou gérer leur absence (read retourne EAGAIN ou 0 pour EOF). Permet l'asynchronisme.

#linebreak()
Écriture (open("montube", O_WRONLY | O_NONBLOCK)) :

- Ouvre immédiatement, mais échoue avec ENXIO si aucun lecteur.
- Raison : Écrire sans lecteur est inutile (mènerait à EPIPE). ENXIO signale tôt l'absence de communication possible.

#linebreak()

=== Définition des rôles
#linebreak()

- Écrivain : Tout processus disposant d'un descripteur ouvert en écriture sur le tube

- Lecteur : Tout processus disposant d'un descripteur ouvert en lecture sur le tube
#linebreak()

#align(center)[
  #rect(stroke: red, inset: (x: 25pt, y: 25pt),
  "
  Conséquences Importantes:
  Multiple écrivains possibles sur un même tube
  Multiple lecteurs possibles sur un même tube
  Un processus peut être lecteur et écrivain
  Les rôles sont dénis par les descripteurs ouverts  
  "
  )
]

#linebreak()

== Lecture sur un tube
#linebreak()

Pour lire nous utilisons l'appel système `read()`

```c
ssize_t read (int fd, void *buf, size_t count);
```
#linebreak()
Description :

Lit jusqu'à count octets depuis le descripteur fd (tube[0]) dans le buffer buf.
Retourne le nombre d'octets lus (peut être < count), 0 pour EOF, ou -1 en cas d'erreur

*#text(fill: red, "Attention le comportement diffère selon le mode!")*

#linebreak()

=== Mode bloquant (Par défaut)
#linebreak()

Description :
- Si des données sont disponibles : Lit les données immédiatement.
- Si aucune donnée n'est disponible :
- Bloque jusqu'à ce que des données arrivent (via write()).
- Ou jusqu'à ce que tous les écrivains ferment leurs descripteurs d'écriture (EOF, read retourne 0).
- Utile pour la synchronisation de processus.

#linebreak()

=== Mode non-bloquant
#linebreak()

Activation du mode non-bloquant:
```c
fcntl(tube[0], F_SETFL, O_NONBLOCK); // tube anonyme
open("montube", O_RDONLY | O_NONBLOCK); // tube nommé
```
#linebreak()

Description :

- Si des données sont disponibles : Lit les données.
- Si aucune donnée : Retourne immédiatement -1 avec errno = EAGAIN ou EWOULDBLOCK.
- Ne bloque pas : Idéal pour des lectures asynchrones.

#linebreak()

== Écriture dans un tube
#linebreak()

Condition d'écriture atomique :
- Lorsque la taille des données ≤ PIPE_BUF (généralement 4096 octets)
- L'écriture est atomique : pas d'entrelacement avec d'autres écrivains

Vérication de PIPE_BUF :
```c
#include <unistd.h>
printf("PIPE_BUF = %ld\n", fpathconf(fd, _PC_PIPE_BUF));
```

Exemple d'écriture atomique :
```c
char message [256];
snprintf(message, sizeof(message), "Mon pid : %d", getpid());
// Écriture atomique si sizeof (message) <= PIPE_BUF
write(fd, message, strlen (message) + 1) ;
```
#linebreak()
*#text(fill: red,"Attention : Pour les données > PIPE_BUF, les écritures peuvent être intercalées entre plusieurs processus.")*

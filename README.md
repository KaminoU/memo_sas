# 📝Notes

Mémo/Sauvegarde perso de codes SAS que je me trimballe/consolide au fil du temps, de projet en projet - i.e. avec les erreurs de jeunesse pas nécessairement corrigées. 

Certains codes sont utilisables tels quels (`00_LIB_Macros_Communes.sas` par exemple), d'autres sont contextualisés (OS, environnement...), à adapter donc selon besoins (l'idée est de faciliter mes copier/coller  - aller, on a tous fait ça... 😜).

Pour certains codes très spécifiques, je doute carrément en avoir besoin un jour dans les années à venir... Mais bon, j'aime bien garder une trace de ce que je fais pour réaliser ensuite à quel point j'étais idiot et me satisfaire de ma petite évolution, tant que faire se peut... (c'est la partie la plus fendard 🤣 - faut bien rigoler...)

Mémo à moi même dans le futur... ALT+F4, CTRL+W, :q, n'importe quoi mais fuis! 🤣

## ⚠ Attention

Tous les fichiers sont au format UTF-8, à convertir donc dans le bon encodage (normalement WESTERN WINDOW 1252 en SAS 9.4 pour les gauloises et gaulois)

## ℹ️ Descriptions

| Prg SAS                            | ...                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ---------------------------------- |:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `_000_FICHIER_PARAMETRAGE.csv`     | Fichier de paramétrage CSV, les variables (portées globale) sont dynamiquement créées en parsant ce fichier.                                                                                                                                                                                                                                                                                                                                                                                             |
| `cleanFileB4Import.sas`            | Permet de nettoyer un fichier plat avant son import. Par défaut les caractères orphelins \x0A ou \x0D sont substitués par l'espace. Dans le contexte CLADAG, l'expression régulière `\xA0\|\x0A\|\x0D\|\x09\|\s{2,}` est appliquée (espace insécable, LF, CR, tabulations ou espaces consécutifs).                                                                                                                                                                                                       |
| `diskDiagnosis.sas`                | Permet de scanner un serveur pour avoir son taux d'occupation avec calcul des empreintes digitales des fichiers et sortir ainsi les fichiers en doublon                                                                                                                                                                                                                                                                                                                                                  |
| `kstAutoexec.sas`                  | Autoexec avec chargement de l'ensemble des paramétrages définis dans le fichier [_000_FICHIER_PARAMETRAGE.csv](./_000_FICHIER_PARAMETRAGE.csv) avec montage dynamique de l'environnement et contrôles.                                                                                                                                                                                                                                                                                                   |
| `workCleaner.sas`                  | Permet de purger selon une date d'antériorité et par direction métier. **Contexte très particulier** sur le projet (serveur SAS sans administration, fallait avancer...)                                                                                                                                                                                                                                                                                                                                 |
| 📁 **Librairie_SAS**               |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `00_LIB_Macros_Communes.sas`       | Liste des macros enrichies avec le temps. La plus part des macros se comportent comme des fonctions, i.e. `%let myNbVal = %getNbVal(&maListe.);` où il y a une assignation de la valeur retournée par la macro définie SAS. Il y a un peu de tout, de l'analyseur de logs avec envoi de mail `%logParser(...)` à l'obfuscation de données (macro `%file2Cipher(...)` - je devrais l'appeler obfuscator ou quelque chose comme ça, mais bon... Je n'ai jamais été très inventif pour trouver les noms 😜) |
| 📁 **Librairie_SAS/libEnv**        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `00_LIB_Macros_Environnements.sas` | Comme son nom l'indique, permet de gérer les différents environnements virtuels où sont lancés les programmes SAS avec montage dynamique et différents mapping librairies selon configuration. Les programmes SAS des sont détectés à la volée pour être ensuite appelés. Contexte projet très particulier, suffisament pour que je sauvegarde mes travaux tellement cela a été frapadingue de ouf 😂                                                                                                    |
| 📁 **Librairie_SAS/libEnv**        |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `00_LIB_Macros_Gestion_Projet.sas` | Toujours même contexte difficile, ce programme est la partie backend, technique pour sécuriser, dans une table technique les différentes empreintes digitales des programmes SAS par environnement sont consignées. L'objectif étant de pouvoir pister les programmes actifs et stables avec rollback si besoin.                                                                                                                                                                                         |

## 📖Catalogue Macros

1. chargement des macros stoquées

```sas
%let sasLibRoot = \\Chemin abolu\Reseau\ou\non;

%MACRO
    _init() /
    des="Initialisation..."
;
    %MACRO setSTLib();
        %if (%sysfunc(libref(stMacL))) ne 0 %then %do;
            libname stMacL "&sasLibRoot.\Librairie_SAS"; /* catalogue des macros communes*/
        %end;
        %if (%sysfunc(libref(stmEnv))) ne 0 %then %do;
            libname stmEnv "&sasLibRoot.\Librairie_SAS\libEnv"; /* catalogue des macros liées à l'environnement */
        %end;
        %if (%sysfunc(libref(stmGes))) ne 0 %then %do;
            libname stmGes "&sasLibRoot.\Librairie_SAS\libGestionProjet"; /* catalogue des macros liées à la gestion des projets */
        %end;
        %if (%sysfunc(libref(stmALL))) ne 0 %then %do;
            libname stmALL (stMacL stmEnv stmGes);
        %end;
    %MEND setSTLib;
    %setSTLib();
    options noquotelenmax mstored sasmstore=stmALL fmtsearch=(formats);
%MEND _init;
%_init();
```

2. lister le contenu des macros stockées

```sas
proc catalog catalog=stmALL.sasmacr;
    contents;
run; quit;

* ou ;

proc sql;
    select *
    from dictionary.catalogs
    where objtype = 'MACRO' and libname = 'stmALL'
    ;
quit;
```

/**                        db                         
                        db    db                      
                                                      
               .d888b.    'Yb    .d888b.              
               8'   `Yb    88    8'   `Yb             
               Yb.   88    88    Yb.   88             
                   .dP    .8P        .dP              
                 .dP'              .dP'               
               .dP'              .dP'                 
                                                      
                                                      
            _______.     ___           _______.       
           /       |    /   \         /       |       
          |   (----`   /  ^  \       |   (----`       
           \   \      /  /_\  \       \   \           
       .----)   |    /  _____  \  .----)   |          
       |_______/    /__/     \__\ |_______/           
                                                      
                                                      
                                         **[ K4mi ]**/
%let sasLibRoot = \\Chemin abolu\Reseau\ou\non;

options noquotelenmax mstored sasmstore=stMacL;
libname stMacL "&sasLibRoot.\Librairie_SAS";

%MACRO
	help(thisMacro) / store
	des="Liste des macros disponibles avec l'aide d'utilisation - %help();"
;
options linesize=max;
%put ;

	%if %upcase(&thisMacro.) eq DEBUGVAR %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%debugVar());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet d%str(%')afficher les valeurs de la liste de variables en argument (sans le &);
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%debugVar(&varList2Debug.));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > varList2Debug : liste des macro variables sans le &, séparés par un espace;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > dans la log, affichera en rouge --[DEBUG]-- nom variable : valeur --[/DEBUG]--;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%debugVar(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---débug visuel des 3 macros variables---*;
		%put NOTE:--[HELP]--       > %nrstr(%let perso1 = Minnie;);
		%put NOTE:--[HELP]--       > %nrstr(%let perso2 = Daisy;);
		%put NOTE:--[HELP]--       > %nrstr(%let perso3 = Mickey;);
		%put NOTE:--[HELP]--       > %nrstr(%debugVar(perso1 perso2 perso3););
		%put NOTE:--[HELP]--       > *---et si la liste est vraiment longue...---*;
		%put NOTE:--[HELP]--       > %nrstr(%let maListe = perso1 perso2 perso3;);
		%put NOTE:--[HELP]--       > %nrstr(%debugVar(&maListe.););
	%end;
	%else %if %upcase(&thisMacro.) eq DEBUGSTR %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%debugStr());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet d%str(%')afficher une phrase (+variables éventuellement) avec le tag --[DEBUG]--;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%debugStr(&str2Display.));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > str2Display : le message ŕ afficher;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > dans la log, affichera en rouge --[DEBUG]-- %nrstr(&str2Display.) --[/DEBUG]--;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%debugStr(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---débug visuel d%str(%')un message---*;
		%put NOTE:--[HELP]--       > %nrstr(%let perso1 = Minnie;);
		%put NOTE:--[HELP]--       > %nrstr(%debugStr)(Ma santé mentale m%str(%')a conduit ici car je ne sais pas ce que contient %nrstr(&perso1.))%nrstr(;);
	%end;
 	%else %if %upcase(&thisMacro.) eq PUT2LOG %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%put2Log());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet d%str(%')avoir un affichage peronnalisé dans la log pour une capture plus aisée par la suite si nécessaire;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%put2Log(&str2Display.<, typeLog<, tag>>));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > str2Display : le message ŕ afficher;
		%put NOTE:--[HELP]--       > typeLog (facultatif) : le type de log ŕ afficher, avec comme valeurs possibles;
		%put NOTE:--[HELP]--       >                        ERROR (par défaut);
		%put NOTE:--[HELP]--       >                        WARNING;
		%put NOTE:--[HELP]--       >                        NOTE;
		%put NOTE:--[HELP]--       > tag (facultatif) : le tag qui sera utilisé pour une capture aisée, par défaut, a comme valeur APP;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > dans la log, affichera en coloré, selon situation --[TAG]-- %nrstr(&str2Display.) --[/TAG]--;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%put2Log(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---débug visuel---*;
		%put NOTE:--[HELP]--       > %nrstr(%let perso1 = Minnie;);
		%put NOTE:--[HELP]--       > %nrstr(%put2Log)(Ma santé mentale m%str(%')a conduit ici car je ne sais pas ce que contient %nrstr(&perso1.))%nrstr(;);
	%end;
	%else %if %upcase(&thisMacro.) eq GETNBVAL %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%getNbVal());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet de récupérer les nombres d%str(%')éléments dans une macro variable liste;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%getNbVal(&listDeVar.));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > listDeVar : macro variable contenant la liste des éléments séparés par un espace;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > le nombre d%str(%')éléments listés;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%getNbVal(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---lit une liste et renvoie le nombre d%str(%')éléments avec le code suivant---*;
		%put NOTE:--[HELP]--       > %nrstr(%let maListe = Minnie Daisy Mickey Donald Dingo Clarabelle;);
		%put NOTE:--[HELP]--       > %nrstr(%let myNbVal = %getNbVal(&maListe.););
		%put NOTE:--[HELP]--       > %nrstr(%put WARNING:--[APP]-- ma variable maListe contient &myNbVal. éléments;);
	%end;
	%else %if %upcase(&thisMacro.) eq GETVALUEFROMLIST %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%getValueFromList());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet de récupérer un élément dans dans une macro variable liste;
		%put NOTE:--[HELP]--       Ou de reconstruire la liste entičre avec un délimiteur autre que le caractčre [ESPACE];
		%put NOTE:--[HELP]--       comme le caractčre [,] utile dans un select dynamique par exemple;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%getValueFromList(&listDeVar.<, delim<, position<, verbose>>>));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > listDeVar : macro variable contenant la liste des éléments séparés par un espace;
		%put NOTE:--[HELP]--       > delim (facultatif) : par défaut, la liste renvoyée sera séparée par de le caractčre [ESPACE];
		%put NOTE:--[HELP]--       >                      si delim=',' alors la liste renvoyée sera séparée par le caractčre [,];
		%put NOTE:--[HELP]--       > position (facultatif) : par défaut, toute la liste sera renvoyée;
		%put NOTE:--[HELP]--       >                         si position=3 alors seul le 3čme élément sera renvoyé;
		%put NOTE:--[HELP]--       > verbose (facultatif) : par défaut la macro se lance en mode muet;
		%put NOTE:--[HELP]--       >                        si verbose=ON alors la macro précise dans la log les éléments lus avec l%str(%')itération associé;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > une liste d%str(%')éléments ou un élément simple;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%getValueFromList(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(*---lit et renvoie ce qui est lu---*);
		%put NOTE:--[HELP]--       > %nrstr(%let maListe = Minnie Daisy Mickey Donald Dingo Clarabelle;);
		%put NOTE:--[HELP]--       > %nrstr(%let maNlleListe = %getValueFromList(&maListe.););
		%put NOTE:--[HELP]--       > %nrstr(%put WARNING:--[APP]-- ma liste nommée maNlleListe contient &maNlleListe;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(*---lit et renvoie ce qui est lu en racontant sa vie dans la log---*);
		%put NOTE:--[HELP]--       > %nrstr(%let maListe = Minnie Daisy Mickey Donald Dingo Clarabelle;);
		%put NOTE:--[HELP]--       > %nrstr(%let maNlleListe = %getValueFromList(&maListe., verbose=on););
		%put NOTE:--[HELP]--       > %nrstr(%put WARNING:--[APP]-- ma liste nommée maNlleListe contient &maNlleListe;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(*---lit et renvoie une liste séparée par ', '---*);
		%put NOTE:--[HELP]--       > %nrstr(%let maListe = Minnie Daisy Mickey Donald Dingo Clarabelle;);
		%put NOTE:--[HELP]--       > %nrstr(%let maNlleListe = %getValueFromList(&maListe., delim=', '););
		%put NOTE:--[HELP]--       > %nrstr(%put WARNING:--[APP]-- ma liste nommée maNlleListe contient &maNlleListe;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(*---lit et renvoie le troisičme élément de la liste---*);
		%put NOTE:--[HELP]--       > %nrstr(%let maListe = Minnie Daisy Mickey Donald Dingo Clarabelle;);
		%put NOTE:--[HELP]--       > %nrstr(%let ma3emVal = %getValueFromList(&maListe., delim='-', verbose=on, position=3););
		%put NOTE:--[HELP]--       > %nrstr(%put WARNING:--[APP]-- la 3čme valeur de ma liste est &ma3emVal.;);
	%end;
	%else %if %upcase(&thisMacro.) eq ISFILE %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%isFile());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet de vérifier l%str(%')existence d%str(%')un répertoire ou d%str(%')un fichier;
		%put NOTE:--[HELP]--       Dans le cas d%str(%')un répertoire, il est possible de demander la création automatique de ce dernier si non existant;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%isFile(&file.<, mkdir<, verbose>>));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > file : le chemin absolu (du fichier ou répertoire);
		%put NOTE:--[HELP]--       > mkdir (facultatif) : par défaut, il n%str(%')y a pas de création de répertoire;
		%put NOTE:--[HELP]--       >                      si le chemin est un répertoire inexistant et mkdir=YES alors le répertoire sera créé;
		%put NOTE:--[HELP]--       >                      si le chemin est un répertoire existant et mkdir=YES alors le répertoire ne sera pas créé;
		%put NOTE:--[HELP]--       > verbose (facultatif) : par défaut la macro se lance en mode muet;
		%put NOTE:--[HELP]--       >                        si verbose=ON alors la macro précise dans la log les variables passées en argument et les différentes étapes;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > 1 si le fichier/répertoire existe;
		%put NOTE:--[HELP]--       > 0 ou une chaine de caractčre si le fichier/répertoire n%str(%')existe pas ;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%isFile(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---vérifie si le repertoire Windows 'C:\toto\tata\kim\titiW' existe---*;
		%put NOTE:--[HELP]--       > %nrstr(%let myFile = 'C:\toto\tata\kim\titiW';);
		%put NOTE:--[HELP]--       > %nrstr(%let isFile = %isFile(&myFile., verbose=ON););
		%put NOTE:--[HELP]--       > %nrstr(%put WARNING:--[APP]-- valeur de isFile = &isFile.;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---vérifie si le repertoire Unix 'M47624/toto/kim/ma/titiU' existe---*;
		%put NOTE:--[HELP]--       > %nrstr(%let myFile = 'M47624/toto/kim/ma/titiU';);
		%put NOTE:--[HELP]--       > %nrstr(%let isFile = %isFile(&myFile., verbose=ON););
		%put NOTE:--[HELP]--       > %nrstr(%put WARNING:--[APP]-- valeur de isFile = &isFile.;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---vérifie si le repertoire Windows 'F:\SASDATA\KST\createMe' existe & le créer si non existant---*;
		%put NOTE:--[HELP]--       > %nrstr(%let myFile = 'F:\SASDATA\KST\createMe';);
		%put NOTE:--[HELP]--       > %nrstr(%let isFile = %isFile(&myFile., mkdir=YES, verbose=ON););
		%put NOTE:--[HELP]--       > %nrstr(%put WARNING:--[APP]-- valeur de isFile = &isFile.;);
	%end;
	%else %if %upcase(&thisMacro.) eq ISTABLE %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%isTable());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet de vérifier l%str(%')existence d%str(%')une table SAS;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%isTable(&tableName.));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > tableName : le nom de la <librairie.>table SAS;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > 1 si existe;
		%put NOTE:--[HELP]--       > 0 sinon;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%isTable(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(%let isTab = %isTable(myLogSynthesis););
		%put NOTE:--[HELP]--       > %nrstr(%put NOTE:--[APP]-- existence table : &isTab.;);
	%end;
	%else %if %upcase(&thisMacro.) eq GETTIMESTAMP %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%getTimeStamp());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet de récupérer un time stamp au format AAAAMMJJ, <H>HMMSS ou AAAAMMJJ_<H>HMMSS (defaut : JJMMMAAAA_<H>HMMSS);
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%getTimeStamp(<type, <verbose>>));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > type (facultatif) : le type et format souhaité :;
		%put NOTE:--[HELP]--       >                     DTS (par défaut) => affiche le date time au format JJMMMAAAA, par exemple 28NOV2013;
		%put NOTE:--[HELP]--       >                     DT => affiche le date time au format AAAAMMJJ_<H>HMMSS, par exemple 20131128_81017;
		%put NOTE:--[HELP]--       >                     D => affiche la date au format AAAAMMJJ, par exemple 20131128;
		%put NOTE:--[HELP]--       >                     DS => affiche la date au format JJMMMAAAA, par exemple 28NOV2013;
		%put NOTE:--[HELP]--       >                     T => affiche le time au format <H>HMMSS, par exemple 81017;
		%put NOTE:--[HELP]--       > verbose (facultatif) : par défaut la macro se lance en mode muet;
		%put NOTE:--[HELP]--       >                        si verbose=ON alors la macro précise dans la log les variables passées en argument et les différentes étapes;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > le time stamp au moment de l%str(%')exécution;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%getTimeStamp(?);) pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(%let myTS = %getTimeStamp(verbose=ON););
		%put NOTE:--[HELP]--       > %nrstr(%put NOTE:--[APP]-- mon time stamp est &myTS.;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(%let myTS = %getTimeStamp(DTS););
		%put NOTE:--[HELP]--       > %nrstr(%put NOTE:--[APP]-- mon time stamp est &myTS.;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(%let myTS = %getTimeStamp(DT););
		%put NOTE:--[HELP]--       > %nrstr(%put NOTE:--[APP]-- mon time stamp est &myTS.;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(%let myTS = %getTimeStamp(D, verbose=ON););
		%put NOTE:--[HELP]--       > %nrstr(%put NOTE:--[APP]-- mon time stamp est &myTS.;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(%let myTS = %getTimeStamp(DS););
		%put NOTE:--[HELP]--       > %nrstr(%put NOTE:--[APP]-- mon time stamp est &myTS.;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(%let myTS = %getTimeStamp(T););
		%put NOTE:--[HELP]--       > %nrstr(%put NOTE:--[APP]-- mon time stamp est &myTS.;);
	%end;
	%else %if %upcase(&thisMacro.) eq RUNTIME %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%runTime());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet de chronométrer le temps d%str(%')exécution d%str(%')un traitement;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%runTime());
		%put NOTE:--[HELP]--         => premičre exécution %nrstr(%runTime();) marque le démarrage du chrono;
		%put NOTE:--[HELP]--         => deuxičme exécution %nrstr(%runTime();) marque son arręt et calcule la différence;
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > NA;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > NA;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%runTime(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(%runTime();) *INITIALISATION CHRONO;
		%put NOTE:--[HELP]--       > %nrstr(  data test1(drop=time_slept););
		%put NOTE:--[HELP]--       > %nrstr(    time_slept=sleep(131, 1););
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(    do key=1 to 3000000;);
		%put NOTE:--[HELP]--       > %nrstr(      length data $64.;);
		%put NOTE:--[HELP]--       > %nrstr(      data = put(key, words64.););
		%put NOTE:--[HELP]--       > %nrstr(      output test1;);
		%put NOTE:--[HELP]--       > %nrstr(    end;);
		%put NOTE:--[HELP]--       > %nrstr(  run;);
		%put NOTE:--[HELP]--       > %nrstr(%runTime();) *CALCUL TEMPS EXECUTION;
	%end;
	%else %if %upcase(&thisMacro.) eq SENDMAIL %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%sendMail());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet d%str(%')envoyer un email;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%sendMail(&to.<, cc=<, bc=<, subject=<, mail=<, attach=<, from=<, replyto=>>>>>>>));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > to : destinataire(s);
		%put NOTE:--[HELP]--       >      les mails doivent ętre sous cette forme email.personne1@nomdomaine.tld;
		%put NOTE:--[HELP]--       >      si plusieurs mails, les saisir ŕ la suite séparé par un espace (email.p1@domaine.tld email.p2@domaine.tld);
		%put NOTE:--[HELP]--       > cc (facultatif) : carbon copy;
		%put NOTE:--[HELP]--       >                   => męme rčgles que pour le champ destinataire;
		%put NOTE:--[HELP]--       > bc (facultatif) : blind copy;
		%put NOTE:--[HELP]--       >                   => męme rčgles que pour le champ destinataire;
		%put NOTE:--[HELP]--       > subject (facultatif) : objet mail;
		%put ERROR:--[HELP]--      >                        => doit ętre imbriqué dans une paire de double quote %str(%");
		%put NOTE:--[HELP]--       >                        par exemple subject=%str(%")Ceci est un objet d%str(%')email%str(%");
		%put NOTE:--[HELP]--       > mail (facultatif) : corps du mail;
		%put ERROR:--[HELP]--      >                     => doit ętre imbriqué dans une macro variable et sans double quote %str(%"), ni quote/apostrophe %str(%');
		%put ERROR:--[HELP]--      >                     => NE DOIT PAS contenir des caractčres interprétables par SAS comme les opérateurs arithmétiques par exemple;
		%put NOTE:--[HELP]--       >                     => le caractčre de soulignement _ (underscore) permet d%str(%')aller ŕ la ligne;
		%put NOTE:--[HELP]--       >                     => les caractčres #_ permet un double saut de ligne;
		%put NOTE:--[HELP]--       > attach (facultatif) : pičces jointes;
		%put NOTE:--[HELP]--       >                       => doit ętre imbriqué(s) dans une macro variable;
		%put NOTE:--[HELP]--       >                       => doit ętre un chemin absolu avec nom fichier;
		%put ERROR:--[HELP]--      >                       => doit transiter par la procédure %nrstr(%sendFile)()%nrstr(;);
		%put ERROR:--[HELP]--      > from (facultatif) : source du mail;
		%put ERROR:--[HELP]--      >                     => selon les configurations du serveur ou client SAS, ce champs doit ętre renseigné;
		%put ERROR:--[HELP]--      >                     => ŕ demander ŕ l%str(%')administrateur réseau/systčme;
		%put NOTE:--[HELP]--       > replyto (facultatif) : email ŕ utiliser en cas de réponse des destinataires;
		%put NOTE:--[HELP]--       >                        => un seul email sans double quote %str(%");
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > NA;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%sendMail(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---exemple mail simple, la source de l%str(%')envoi est SAS.PRD@XYZ-Hunter.com, sans quoi le mail ne part pas---*;
		%put NOTE:--[HELP]--       > %nrstr(%sendMail)(;
		%put NOTE:--[HELP]--       >   from = SAS.PRD@XYZ-Hunter.com,;
		%put NOTE:--[HELP]--       >   to = michel.truong@ext.XYZ-Hunter.com,;
		%put NOTE:--[HELP]--       > )%nrstr(;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---exemple mail simple avec sujet---*;
		%put NOTE:--[HELP]--       > %nrstr(%sendMail)(;
		%put NOTE:--[HELP]--       >   from = SAS.PRD@XYZ-Hunter.com,;
		%put NOTE:--[HELP]--       >   to = michel.truong@ext.XYZ-Hunter.com,;
		%put NOTE:--[HELP]--       >   subject = %str(%")Je teste...%str(%");
		%put NOTE:--[HELP]--       > )%nrstr(;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---exemple mail complet avec PJ, multi destinataires et corps mail avec utilisation _---*;
		%put NOTE:--[HELP]--       > %nrstr(%let) attach =;
		%put NOTE:--[HELP]--       >   %nrstr(%sendFile)(F:\SASDATA\KST\testDDE.xlsm);
		%put NOTE:--[HELP]--       >   %nrstr(%sendFile)(F:\SASDATA\KST\testr.txt);
		%put NOTE:--[HELP]--       >   %nrstr(%sendFile)(F:\SASDATA\KST\testm.zip);
		%put NOTE:--[HELP]--       > %nrstr(;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(%let) myEmail =;
		%put NOTE:--[HELP]--       >   Yo!#_;
		%put NOTE:--[HELP]--       >   Ceci est un petit test de la morkitu o(^ ^ o)(o ^ ^)o_;
		%put NOTE:--[HELP]--       >   Avec retour ŕ la ligne et tout et tout!!!_;
		%put NOTE:--[HELP]--       >   @++#_;
		%put NOTE:--[HELP]--       >   Michel;
		%put NOTE:--[HELP]--       > %nrstr(;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(%sendMail)(;
		%put NOTE:--[HELP]--       >   from = SAS.PRD@XYZ-Hunter.com,;
		%put NOTE:--[HELP]--       >   to = michel.truong@ext.XYZ-Hunter.com mickey@disney.com,;
		%put NOTE:--[HELP]--       >   cc = mtruong@iok.fr,;
		%put NOTE:--[HELP]--       >   bc = minnie@disney.com,;
		%put NOTE:--[HELP]--       >   attach = %nrstr(&attach.),;
		%put NOTE:--[HELP]--       >   subject = %str(%")Je teste... hé hé%str(%"),;
		%put NOTE:--[HELP]--       >   mail = %nrstr(&myEmail.);
		%put NOTE:--[HELP]--       > )%nrstr(;);
	%end;
	%else %if %upcase(&thisMacro.) eq ISMAIL %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%isMail());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet de vérifier le bon formatage d%str(%')un email;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%isMail(&email.));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > email : macro variable contenant le mail ŕ vérifier;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > 1 si mail valide;
		%put NOTE:--[HELP]--       > 0 sinon;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%isMail(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---vérification d%str(%')un mail simple lors d%str(%')un data step par exemple---*;
		%put NOTE:--[HELP]--       > %nrstr(%let isValidEmail = %isMail(michel.truong@ext.XYZ-Hunter.com););
		%put NOTE:--[HELP]--       > %nrstr(%put NOTE:--[APP]-- le code retour de isValidEmail est &isValidEmail.;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---vérification d%str(%')un champ mail dans une table complčte---*;
		%put NOTE:--[HELP]--       > data t_email%nrstr(;);
		%put NOTE:--[HELP]--       >   length first email phone $32%nrstr(;);
		%put NOTE:--[HELP]--       >   input first email phone $32.%nrstr(;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       >   datalines%nrstr(;);
		%put NOTE:--[HELP]--       >     Kim1 Kim@mail.com 0689912549%nrstr(;);
		%put NOTE:--[HELP]--       >     Kim2 K123_yo@gmail.fr.com +33698912549%nrstr(;);
		%put NOTE:--[HELP]--       >     Kim3 @gml.eu.com +33 6 79 91 25 49%nrstr(;);
		%put NOTE:--[HELP]--       >     Kim4 @gml.com +33-6-79-91-25-49%nrstr(;);
		%put NOTE:--[HELP]--       >     Kim5 K@m (555)-555-5555%nrstr(;);
		%put NOTE:--[HELP]--       >     Kim6 K@@@@@gmail.com 555-555-5555%nrstr(;);
		%put NOTE:--[HELP]--       >   %nrstr(;);
		%put NOTE:--[HELP]--       > run%nrstr(;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > proc sql%nrstr(;);
		%put NOTE:--[HELP]--       >   create table t_checkMail as;
		%put NOTE:--[HELP]--       >     select email, resolve(%str(%')%nrstr(%isMail)(%str(%')||email||%str(%'))%str(%')) as validMail;
		%put NOTE:--[HELP]--       >     from t_email;
		%put NOTE:--[HELP]--       >   %nrstr(;);
		%put NOTE:--[HELP]--       > quit%nrstr(;);
	%end;
	%else %if %upcase(&thisMacro.) eq ISPHONE %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%isPhone());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet de vérifier le bon formatage d%str(%')un téléphone;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%isPhone(&phoneNumber.));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > phoneNumber : numéro de téléphone sans %str(%") ou %str(%');
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > 1 si téléphone valide;
		%put NOTE:--[HELP]--       > 0 sinon;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%isPhone(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---vérification d%str(%')un téléphone simple lors d%str(%')un data step par exemple---*;
		%put NOTE:--[HELP]--       > %nrstr(%let isValidPhone = %isPhone(+33 6 98 79 12 47););
		%put NOTE:--[HELP]--       > %nrstr(%put NOTE:--[APP]-- le code retour de isValidPhone est &isValidPhone.;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---vérification d%str(%')un champ téléphone dans une table complčte---*;
		%put NOTE:--[HELP]--       > data t_phone%nrstr(;);
		%put NOTE:--[HELP]--       >   length first email phone $32%nrstr(;);
		%put NOTE:--[HELP]--       >   input first email phone $32.%nrstr(;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       >   datalines%nrstr(;);
		%put NOTE:--[HELP]--       >     Kim1 Kim@mail.com 0689912549%nrstr(;);
		%put NOTE:--[HELP]--       >     Kim2 K123_yo@gmail.fr.com +33698912549%nrstr(;);
		%put NOTE:--[HELP]--       >     Kim3 @gml.eu.com +33 6 79 91 25 49%nrstr(;);
		%put NOTE:--[HELP]--       >     Kim4 @gml.com +33-6-79-91-25-49%nrstr(;);
		%put NOTE:--[HELP]--       >     Kim5 K@m (555)-555-5555%nrstr(;);
		%put NOTE:--[HELP]--       >     Kim6 K@@@@@gmail.com 555-555-5555%nrstr(;);
		%put NOTE:--[HELP]--       >   %nrstr(;);
		%put NOTE:--[HELP]--       > run%nrstr(;);
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > proc sql%nrstr(;);
		%put NOTE:--[HELP]--       >   create table t_checkPhone as;
		%put NOTE:--[HELP]--       >     select phone, resolve(%str(%')%nrstr(%isPhone)(%str(%')||phone||%str(%'))%str(%')) as validPhone;
		%put NOTE:--[HELP]--       >     from t_phone;
		%put NOTE:--[HELP]--       >   %nrstr(;);
		%put NOTE:--[HELP]--       > quit%nrstr(;);
	%end;
	%else %if %upcase(&thisMacro.) eq FILE2CIPHER %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%file2Cipher());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet d%str(%')obfusquer un fichier plat afin de rendre la lecture difficile;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%file2Cipher(&fileName.<, cipher=ON>));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > fileName : macro variable avec le chemin absolu du fichier plat ŕ obfusquer ou ŕ rendre clair;
		%put NOTE:--[HELP]--       > cipher (facultatif) : obfusquer ON/OFF;
		%put NOTE:--[HELP]--       >                       => ON (par défaut) pour obfusquer;
		%put NOTE:--[HELP]--       >                       => OFF pour rendre clair le fichier;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > produit un fichier obfusqué ŕ la racine du fichier ŕ obfusquer;
		%put NOTE:--[HELP]--       > ou;
		%put NOTE:--[HELP]--       > produit un fichier clair ŕ partir du fichier obfusqué passé en argument;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%file2Cipher(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---pour obfusquer un fichier---*;
		%put NOTE:--[HELP]--       > %nrstr(%file2Cipher('C:\Data\myFile2Obfuscate.txt'););
		%put NOTE:--[HELP]--       > *---<AVANT %nrstr(%file2Cipher(...))>---*;
		%put NOTE:--[HELP]--       > mon fichier plat ŕ rendre illisible... o(^^ o) YEAH! (o ^^)o;
		%put NOTE:--[HELP]--       > *---<APRES %nrstr(%file2Cipher(...))>---*;
		%put NOTE:--[HELP]--       > bW9uIGZpY2hpZXIgcGxhdCDgIHJlbmRyZSBpbGxpc2libGUuLi4gbyheXiBvKSBZRUFIISAobyBe;
		%put NOTE:--[HELP]--       > XilvDQo=;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---pour rendre clair le fichier obfusqué---*;
		%put NOTE:--[HELP]--       > %nrstr(%file2Cipher('C:\Data\myFile2Obfuscate.txt.OBF', cipher=OFF););
	%end;
	%else %if %upcase(&thisMacro.) eq LOGPARSER %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%logParser());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet d%str(%')analyser un fichier log SAS et envoyer un mail automatisé de synthčse;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%logParser(&myLog.<, emailLog=NO<, from=<, to=<, cc=<, step=<, signature=>>>>>>));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > myLog : nom du fichier log avec son chemin absolu;
		%put NOTE:--[HELP]--       >         => dans le programme SAS, il est possible de marquer selon un besoin fonctionnel, męme si syntaxiquement il n%str(%')y a pas d%str(%')erreurs;
		%put NOTE:--[HELP]--       >         => %nrstr(%put NOTE:--[APP]-- ma note;);
		%put NOTE:--[HELP]--       >         => %nrstr(%put WARNING:--[APP]-- mon warning;);
		%put NOTE:--[HELP]--       >         => %nrstr(%put ERROR:--[APP]-- mon erreur;);
		%put NOTE:--[HELP]--       > emailLog (facultatif) : NO/YES (si activé, alors c.f. %nrstr(%help(sendMail)) pour plus de détail si besoin);
		%put NOTE:--[HELP]--       >                         => NO (par défaut) aucun mail envoyé;
		%put NOTE:--[HELP]--       >                         => YES pour activer le suivi mail : un mail automatique généré sera envoyé;
		%put ERROR:--[HELP]--      > from (facultatif) : source du mail;
		%put ERROR:--[HELP]--      >                     => selon les configurations du serveur ou client SAS, ce champs doit ętre renseigné;
		%put ERROR:--[HELP]--      >                     => ŕ demander ŕ l%str(%')administrateur réseau/systčme;
		%put NOTE:--[HELP]--       > to : destinataire(s);
		%put NOTE:--[HELP]--       >      les mails doivent ętre sous cette forme email.personne1@nomdomaine.tld;
		%put NOTE:--[HELP]--       >      si plusieurs mails, les saisir ŕ la suite séparé par un espace (email.p1@domaine.tld email.p2@domaine.tld);
		%put NOTE:--[HELP]--       > cc (facultatif) : carbon copy;
		%put NOTE:--[HELP]--       >                   => męme rčgles que pour le champ destinataire;
		%put NOTE:--[HELP]--       > step (facultatif) : le nom et/ou étape du programme SAS ŕ partir duquel la log est analysée;
		%put NOTE:--[HELP]--       >                     => sans double quote %str(%"), ni quote/apostrophe %str(%') et sans caractčres interprétables par SAS;
		%put NOTE:--[HELP]--       > signature (facultatif) : la signature du mail automatique généré;
		%put NOTE:--[HELP]--       >                          => sans double quote %str(%"), ni quote/apostrophe %str(%') et sans caractčres interprétables par SAS;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > 2 tables pouvant servir aux analyses complémentaires :;
		%put NOTE:--[HELP]--       >   myLogData;
		%put NOTE:--[HELP]--       >   myLogSynthesis;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%logParser(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(%logParser)(%str(%')F:\SASDATA\KST\test.log%str(%'),;
		%put NOTE:--[HELP]--       >   emailLog = YES,;
		%put NOTE:--[HELP]--       >   from = SAS.PRD@XYZ-Hunter.com,;
		%put NOTE:--[HELP]--       >   to = michel.truong@ext.XYZ-Hunter.com;
		%put NOTE:--[HELP]--       >        mtruong@iok.fr;
		%put NOTE:--[HELP]--       >   ,;
		%put NOTE:--[HELP]--       >   step = calcul truc muche,;
		%put NOTE:--[HELP]--       >   signature = Equipe DEV;
		%put NOTE:--[HELP]--       > )%nrstr(;);
	%end;
	%else %if %upcase(&thisMacro.) eq SETDYNVAR %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%setDynVar());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet de créer des macro variables globales ŕ partir d%str(%')un fichier de paramétrage CSV;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%setDynVar(&dynVarFile.<, backUP=YES<, displayVar=NO<, cleanVarBefore=YES>>>));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > dynVarFile : le fichier CSV contenant les macro variables ŕ créer dynamiquement (chemin absolu sans espace);
		%put WARNING:--[HELP]--    >              => le fichier CSV doit avoir %nrstr(;) comme séparateur;
		%put WARNING:--[HELP]--    >              => le fichier CSV doit avoir 3 colonnes :;
		%put WARNING:--[HELP]--    >                 => 1. nom de la variable SAS (avec les rčgles de nomenclature propre ŕ SAS);
		%put WARNING:--[HELP]--    >                 => 2. valeur de la variable SAS (peut ętre une valeur simple ou une formule, tant que SAS peut l%str(%')interpréter);
		%put WARNING:--[HELP]--    >                 => 3. un commentaire (optionnel);
		%put NOTE:--[HELP]--       > backUP (optionnel) : YES/NO;
		%put NOTE:--[HELP]--       >                      => YES par défaut, le fichier CSV consommé sera sauvegardé ŕ la racine;
		%put NOTE:--[HELP]--       >                      => NO une sauvegarde n%str(%')est pas souhaitée;
		%put NOTE:--[HELP]--       > displayVar (optionnel) : YES/NO;
		%put NOTE:--[HELP]--       >                          => NO par défaut;
		%put NOTE:--[HELP]--       >                          => YES pour afficher dans la log les noms des variables créées ainsi que leurs valorisations;
		%put NOTE:--[HELP]--       > cleanVarBefore (optionnel) : YES/NO;
		%put NOTE:--[HELP]--       >                              => YES par défaut, vider toutes les macro variables gloables;
		%put NOTE:--[HELP]--       >                              => NO pour conserver;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > initialise les différentes macro variables telles que décrites dans le fichier CSV passé en argument;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%setDynVar(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---le fichier myVar.csv est ainsi défini---*;
		%put NOTE:--[HELP]--       > maVariableSAS_1%nrstr(;)Hello%nrstr(;)Commentaire inutile...;
		%put NOTE:--[HELP]--       > maVariableSAS_2%nrstr(;)%nrstr(%%)eval(1+2)%nrstr(;)la variable donnera 3;
		%put NOTE:--[HELP]--       > *---/le fichier myVar.csv est ainsi défini---*;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(%setDynVar('F:\SASDATA\KST\myVar.csv'););
		%put NOTE:--[HELP]--       > %nrstr(%put NOTE:--[APP]-- ma premičre variable est maVariableSAS_1 et contient &maVariableSAS_1.;);
		%put NOTE:--[HELP]--       > %nrstr(%put NOTE:--[APP]-- ma deuxičme variable est maVariableSAS_2 et contient &maVariableSAS_2.;);
		%put NOTE:--[HELP]--       > etc...;
	%end;
	%else %if %upcase(&thisMacro.) eq UPDATEDYNVAR %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%updateDynVar());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet de mettre ŕ jour le fichier de paramétrage CSV en argument avec les données de la table SAS de paramétrage;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%updateDynVar(&dynVarFile.<, backUP=YES>));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > dynVarFile : le fichier CSV contenant les macro variables ŕ mettre ŕ jour dynamiquement (chemin absolu sans espace);
		%put NOTE:--[HELP]--       > backUP (optionnel) : YES/NO;
		%put NOTE:--[HELP]--       >                      => YES par défaut, le fichier CSV consommé sera sauvegardé ŕ la racine;
		%put NOTE:--[HELP]--       >                      => NO une sauvegarde n%str(%')est pas souhaitée;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > fichier CSV des paramétrages mis ŕ jour;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%updateDynVar(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---/mise ŕ jour du fichier myVar.csv avec backup par défaut---*;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > %nrstr(%updateDynVar('F:\SASDATA\KST\myVar.csv'););
	%end;
	%else %if %upcase(&thisMacro.) eq HISTORYJOBLOG %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%historyJobLog());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet de gérer les historiques des traitements (qui a lancé, quel traitement, quand, durée, status etc...);
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%historyJobLog(&histoTable.<, nomDev=<, stepName=<, jobPeriod=M<, jobStatus=OK<, comments=<, runTimeAutoOff=ON>>>>>>));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > histoTable : le nom de la table des log ŕ historiser (avec ou sans librairie);
		%put NOTE:--[HELP]--       > nomDev (optionnel) : le nom de celui qui a lancé le traitement;
		%put NOTE:--[HELP]--       > stepName (optionnel) : le nom du traitement SAS;
		%put NOTE:--[HELP]--       > jobPeriod (optionnel) : la périodicité du traitement;
		%put NOTE:--[HELP]--       >                         => D : Journalier;
		%put NOTE:--[HELP]--       >                         => W : Hebdo;
		%put NOTE:--[HELP]--       >                         => M : Mensuel (par défaut);
		%put NOTE:--[HELP]--       >                         => T : Trimestriel;
		%put NOTE:--[HELP]--       >                         => S : Semestriel;
		%put NOTE:--[HELP]--       >                         => A : Annuel;
		%put NOTE:--[HELP]--       > jobStatus (optionnel) : état du traitement;
		%put NOTE:--[HELP]--       >                         => OK (par défaut);
		%put NOTE:--[HELP]--       >                         => KO;
		%put NOTE:--[HELP]--       >                         => WARNING;
		%put NOTE:--[HELP]--       > comments (optionnel) : commentaires;
		%put NOTE:--[HELP]--       > runTimeAutoOff (optionnel) : option permettant d%str(%')arręter par défaut le chronométrage du traitement;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > complčte la table historique des logs en argument;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%historyJobLog(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---exemple de suivi de traitement---*;
		%put NOTE:--[HELP]--       > libname maLib %str(%')F:\SASDATA\KST\data\%str(%')%nrstr(;);
		%put NOTE:--[HELP]--       > %nrstr(%historyJobLog)(maLib.maLog_que_je_veux_garder)%nrstr(;) *--initialisation et démarrage chrono...--*;
		%put NOTE:--[HELP]--       > *--traitement SAS avec gestion erreurs etc...--*;
		%put NOTE:--[HELP]--       > *--puis suivi historique jobs dans la table de log nouvellement initialisée ou existante...--*;
		%put NOTE:--[HELP]--       > %nrstr(%historyJobLog)(maLib.maLog_que_je_veux_garder,;
		%put NOTE:--[HELP]--       >   nomDev = %str(%")Michel TRUONG%str(%"),;
		%put NOTE:--[HELP]--       >   stepName = %str(%")X Mas%str(%"),;
		%put NOTE:--[HELP]--       >   jobPeriod = A,;
		%put NOTE:--[HELP]--       >   comments = %str(%")C%str(%')est l%str(%')histoire du pčre Noel qui a perdu ses boules... =ţ%str(%"),;
		%put NOTE:--[HELP]--       > )%nrstr(;);
	%end;
	%else %if %upcase(&thisMacro.) eq CHECKDIFF %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%checkDiff());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet de comparer les mouvements entre 2 tables (changement de produits ou garanties dans une table de référence sur 2 périodes différentes par exemple);
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%checkDiff(&tableRef., table2Compare=, keys2Compare=<, keepAllCols=NO>));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > tableRef : le nom de la table de référence;
		%put NOTE:--[HELP]--       > table2Compare : le nom de la table ŕ comparer (doit ętre identique, au niveau structure, que la %nrstr(&tableRef.) sinon la macro va rejeter le traitement);
		%put NOTE:--[HELP]--       > keys2Compare : la liste des clés dans les tables ŕ comparer;
		%put NOTE:--[HELP]--       > keepAllCols (optionnel) : récupčre ou non la liste des colonnes;
		%put NOTE:--[HELP]--       >                         => NO : on ne garde donc que les clés comme champs dans la table de sortie (par défaut);
		%put NOTE:--[HELP]--       >                         => YES : si on souhaite garder les colonnes;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > une table [checkDiff] dans la work et dans la LOG, des alertes si différences constatées;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%checkDiff(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---exemple---*;
		%put NOTE:--[HELP]--       > data FORMATS_CDR_SAMPLE%nrstr(;);
		%put NOTE:--[HELP]--       >   set FORMATS.FORMATS_CDR(obs=89);
		%put NOTE:--[HELP]--       > run;
		%put NOTE:--[HELP]--       > %nrstr(%checkDiff)(tableRef = FORMATS.FORMATS_CDR,;
		%put NOTE:--[HELP]--       >   table2Compare = FORMATS_CDR_SAMPLE,,;
		%put NOTE:--[HELP]--       >   keys2Compare = CPOSTB CODE_DEPT CODE_DEPT_BIS DEPARTEMENT,;
		%put NOTE:--[HELP]--       >   keepAllCols = YES;
		%put NOTE:--[HELP]--       > )%nrstr(;);
	%end;
	%else %if %upcase(&thisMacro.) eq IMPORTFLATFILE %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%importFlatFile());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet d%str(%')importer des fichiers plats en donnant un fichier de paramétrage;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%importFlatFile(&importParam.));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > importParam : chemin absolu vers le fichier de description d%str(%')import (peu importe l%str(%')extension, par défaut, *.sasdesc);
		%put ERROR:--[HELP]--      >               => lire le fichier de description type DESCRIPTION_IMPORT_EXEMPLE.sasdesc pour plus de détails;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > la table importée telle que décrite dans le fichier d%str(%')import;
		%put NOTE:--[HELP]--       > le script d%str(%')import est généré ŕ la racine ou dans le répertoire décrit dans le fichier d%str(%')import;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%importFlatFile(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---exemple---*;
		%put NOTE:--[HELP]--       > %nrstr(%importFlatFile)(%str(%')F:\SASDATA\KST\Test import\FORMATS_COMMUNES_TAB.sasdesc%str(%'))%nrstr(;);
	%end;
	%else %if %upcase(&thisMacro.) eq IMPORTFROMFOLDER %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%importFromFolder());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet d%str(%')importer tous les fichiers de descriptions de la macro %nrstr(%importFlatFile) depuis un dossier;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%importFromFolder(&folder2Import.<, extension=sasdesc<, dirContents2import=DIR_CONTENTS_2_IMPORT<, genSAS=importFromFolder.sas<, autoLoad=YES>>>>));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > importFromFolder : chemin absolu vers le répertoire contenant les fichiers de description d%str(%')import (peu importe l%str(%')extension, par défaut, *.sasdesc);
		%put NOTE:--[HELP]--       > extension (optionnel) : l%str(%')extension des fichiers de description;
		%put NOTE:--[HELP]--       >                         => sasdesc (par défaut);
		%put NOTE:--[HELP]--       > dirContents2import (optionnel) : nom de la table technique SAS contenant les entrées du répertoire devant ętre importées;
		%put NOTE:--[HELP]--       >                         => DIR_CONTENTS_2_IMPORT (par défaut);
		%put NOTE:--[HELP]--       > genSAS (optionnel) : nom du programme SAS final lisant tous les imports ŕ réaliser;
		%put NOTE:--[HELP]--       >                         => importFromFolder.sas (par défaut);
		%put NOTE:--[HELP]--       > autoLoad (optionnel) : marqueur auto exécution du programme %nrstr(&genSAS.) SAS généré ;
		%put NOTE:--[HELP]--       >                         => YES (par défaut);
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > la ou les table(s) importée(s) telle(s) que décrite(s) dans le(s) fichier(s) d%str(%')import présent(s) dans le répertoire %nrstr(&folder2Import.);
		%put NOTE:--[HELP]--       > le script d%str(%')import est généré ŕ la racine du répertoire d%str(%')import;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%importFromFolder(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---exemple---*;
		%put NOTE:--[HELP]--       > %nrstr(%importFromFolder)(;
		%put NOTE:--[HELP]--       >   folder2Import = %str(%')F:\SASDATA\KST\Test import%str(%'),;
		%put NOTE:--[HELP]--       >   autoLoad = NO;
		%put NOTE:--[HELP]--       > )%nrstr(;);
	%end;
	%else %if %upcase(&thisMacro.) eq GENDICTIONARY %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%genDictionary());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet de générer un fichier dictionnaire de données Excel;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%genDictionary(&folder2Excel.));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > folder2Excel : chemin absolu vers le répertoire oů sera généré le dictionnaire Excel;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > le fichier Excel nommé DICTIONNAIRE_SAS.xlsx dans le répertoire %nrstr(&folder2Import.);
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%genDictionary(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---exemple---*;
		%put NOTE:--[HELP]--       > %nrstr(%genDictionary)(%str(%')F:\SASDATA\KST%str(%'))%nrstr(;);
	%end;
	%else %if %upcase(&thisMacro.) eq SETDIGITALSIGNATURE %then %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%setDigitalSignature());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet de construire la signature électronique d%str(%')un fichier plat (programme SAS, log etc...);
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%setDigitalSignature(&myFile.));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > myFile : chemin absolu vers le fichier dont la signature digitale doit ętre générée;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > une table contenant les signatures générées, si on veut récupérer dans des macro variables, utiliser ensuite la macro %nrstr(%getDigitalSignature(););
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%setDigitalSignature(?);) *pour afficher l%str(%')aide;
		%put NOTE:--[HELP]--       > %nrstr();
		%put NOTE:--[HELP]--       > *---débug visuel des 3 macros variables---*;
		%put NOTE:--[HELP]--       > %nrstr(%setDigitalSignature('F:\SASDATA\KST\00_LIB_Macros_Communes_ORIGINAL.sas'););
		%put NOTE:--[HELP]--       > %nrstr(%let signature = %getDigitalSignature(););
		%put NOTE:--[HELP]--       > %nrstr(%debugVar(signature););
	%end;
	%else %do;
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%help());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet de lister les macros disponibles et/ou de préciser le fonctionnement d%str(%')une macro spécifique;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%help(<nomMacro>));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > nomMacro (facultatif) : nom de la macro pour une aide précise;
		%put NOTE:--[HELP]--    • RETOUR(S) :;
		%put NOTE:--[HELP]--       > NA;
		%put WARNING:--[HELP]-- • EXEMPLE(S) :;
		%put NOTE:--[HELP]--       > %nrstr(%help();) *pour afficher la liste complčte des macros disponibles;
		%put NOTE:--[HELP]--       > %nrstr(%help(getNbVal);) *pour afficher l%str(%')aide de la macro %nrstr(%getNbVal());
		%put ;
		%put WARNING:--[HELP]-- [LISTE DES MACROS DISPONIBLES] :;
		%put NOTE:--[HELP]--    • %nrstr(%debugVar());
		%put NOTE:--[HELP]--    • %nrstr(%debugStr());
		%put NOTE:--[HELP]--    • %nrstr(%put2Log());
		%put NOTE:--[HELP]--    • %nrstr(%getNbVal());
		%put NOTE:--[HELP]--    • %nrstr(%getValueFromList());
		%put NOTE:--[HELP]--    • %nrstr(%isFile());
		%put NOTE:--[HELP]--    • %nrstr(%isTable());
		%put NOTE:--[HELP]--    • %nrstr(%getTimeStamp());
		%put NOTE:--[HELP]--    • %nrstr(%runTime());
		%put NOTE:--[HELP]--    • %nrstr(%sendMail());
		%put NOTE:--[HELP]--    • %nrstr(%isMail());
		%put NOTE:--[HELP]--    • %nrstr(%isPhone());
		%put NOTE:--[HELP]--    • %nrstr(%file2Cipher());
		%put NOTE:--[HELP]--    • %nrstr(%logParser());
		%put NOTE:--[HELP]--    • %nrstr(%setDynVar());
		%put NOTE:--[HELP]--    • %nrstr(%updateDynVar());
		%put NOTE:--[HELP]--    • %nrstr(%historyJobLog());
		%put NOTE:--[HELP]--    • %nrstr(%checkDiff());
		%put NOTE:--[HELP]--    • %nrstr(%importFlatFile());
		%put NOTE:--[HELP]--    • %nrstr(%importFromFolder());
		%put NOTE:--[HELP]--    • %nrstr(%genDictionary());
		%put NOTE:--[HELP]--    • %nrstr(%setDigitalSignature());
	%end;
%put ;
%MEND help;
/**
Exemple :
	%help();
	%help(debugVar);
	%help(debugStr);
	%help(put2Log);
	%help(getNbVal);
	%help(getValueFromList);
	%help(isFile);
	%help(isTable);
	%help(getTimeStamp);
	%help(runTime);
	%help(sendMail);
	%help(isMail);
	%help(isPhone);
	%help(file2Cipher);
	%help(logParser);
	%help(setDynVar);
	%help(updateDynVar);
	%help(historyJobLog);
	%help(checkDiff);
	%help(importFlatFile);
	%help(importFromFolder);
	%help(genDictionary);
	%help(setDigitalSignature);
 **/

%MACRO
	debugVar(varList2Debug) / store
	des="Permet d'afficher les valeurs de la liste de variables en argument (sans le &)"
;
	%if &varList2Debug. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &varList2Debug. eq %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';

		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			options linesize=max;
			%let thisNbVal = %getNbVal(&varList2Debug.);

			%do i=1 %to &thisNbVal.;
				%let thisVar = %scan(&varList2Debug., &i.);
				
				%put ERROR:--[DEBUG]-- &&thisVar. : &&&thisVar. --[/DEBUG]--;
			%end;
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(debugVar);
		%end;

	%MACRO_END: /** FIN **/
%MEND debugVar;
/**
Exemple :
	%debugVar(?);
	%debugVar();

	%let v1 = titi;
	%let v2 = toto;
	%debugVar(v1 v2);

	%let lv = v1 v2;
	%debugVar(&lv);
 **/

%MACRO
	debugStr(str2Display) / store
	des="Permet d'afficher une phrase (+variables éventuellement) avec le tag --[DEBUG]--"
;
	%if &str2Display. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &str2Display. eq %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';

		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			options linesize=max;
			%put ERROR:--[DEBUG]-- &str2Display. --[/DEBUG]--;
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(debugStr);
		%end;

	%MACRO_END: /** FIN **/
%MEND debugStr;
/**
Exemple :
	%let val = %getTimeStamp();
	%debugStr(what%str(%')s the value of this ? &val.);
 **/

%MACRO
	put2Log(str2Display, typeLog=ERROR, tag=APP) / store
	des="Permet d'avoir un affichage peronnalisé dans la log pour une capture plus aisée par la suite si nécessaire"
;
	%if &str2Display. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &str2Display. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';

		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			options linesize=max;

			%let thisTypeLog = ERROR;
			%if %upcase(&typeLog.) eq WARNING %then %do;
				%let thisTypeLog = WARNING;
			%end;
			%else %if %upcase(&typeLog.) eq NOTE %then %do;
				%let thisTypeLog = NOTE;
			%end; 

			%let thisTag = APP;
			%if %upcase(&tag.) ne APP %then %do;
				%let thisTag = &tag.;
			%end;

			%put &thisTypeLog.:--[&thisTag.]--&str2Display.--[/&thisTag.]--;
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(put2Log);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%put2Log()) sans argument ou avec un argument vide, veuillez consulter l%str(%')aide ci-dessous;

			%help(put2Log);
		%end;

	%MACRO_END: /** FIN **/
%MEND put2Log;
/**
Exemple :
	%let val = %getTimeStamp();
	%put2Log(what%str(%')s the value of this ? &val.);
	%put2Log(
		str2Display = "what%str(%')s the value of this ? The value is &val., but I do not get it...",
		typeLog = NOTE,
		tag = My New TAG
	);

	%put2Log(" Vous avez apppelé la macro %nrstr(%test()) sans argument ou avec un argument vide, veuillez consulter l'aide ci-dessous ");
 **/

%MACRO
	getNbVal(varList) / store
	des="Permet de récupérer le nombre d'éléments dans une macro variable liste"
;
	%if &varList. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &varList. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%let nbVal = 1;

			%do %while(%scan(%str(&varList.), &nbVal., ' ') NE);
				%let nbVal = %eval(&nbVal. + 1);
			%end;
			%let nbVal = %eval(&nbVal. - 1);

			/*%sysfunc(putn(&nbVal., best32.));*/
			%sysfunc(compress(&nbVal.))
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(getNbVal);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%getNbVal()) sans argument ou avec un argument vide, veuillez consulter l%str(%')aide ci-dessous;

			%help(getNbVal);
		%end;

	%MACRO_END: /** FIN **/
		/*data _null_; stop; run;*/
%MEND getNbVal;
/*
Exemple :
	%getNbVal(?);
	%getNbVal();

	%let maListe = ;
	%getNbVal(&maListe.);
	%put WARNING:--[APP]-- &myNbVal.;
	
	%let maListe = Minnie Daisy Mickey Donald Dingo.Clarabelle;
	%let myNbVal = %getNbVal(&maListe.);
	%put WARNING:--[APP]-- ma variable %nrstr(&maListe.) contient &myNbVal. éléments;

	%let test = %eval(&myNbVal. + 4);
	%put WARNING:--[APP]-- &test.;
*/

%MACRO
	getValueFromList(varList, delim='', position=all, verbose=off) / store
	des="Permet de récupérer une valeur spécifique d'une macro variable liste"
;
	%if &varList. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if %index(&delim., %) > 0 %then %do;
		%let errHandler = 'PROHIBITED';
		%goto ERR_HANDLER;
	%end;
	%else %if &varList. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%let totVar = %getNbVal(&varList.);
			%let myNList = ;

			%do i=1 %to &totVar.;
				%let tVar = %scan(&varList., &i.);

				%if %upcase(&verbose.) eq ON %then %do;
					%put NOTE:--[APP]-- variable courante : &tVar. (position : &i.).;
				%end;

				%if &delim. ne '' %then %do;
					%let myNList = &myNList.&tVar.%str(&delim.);
				%end;
				%else %do;
					%let myNList = &myNList. &tVar.;
				%end;

				%if %upcase(&position.) ne ALL and &position. = &i. %then %do;
					%qsysfunc(dequote(&tVar.));
					%goto MACRO_END;
				%end;
			%end;

			%if &delim. ne '' %then %do;
				%let myNList = %qsysfunc(compress(&myNList., "'"));
				/*%qsysfunc(substr(&myNList., 1, %length(&myNList.)-1))*/
				%qsysfunc(substr(&myNList., 1, %length(&myNList.)-%length(%qsysfunc(compress(&delim., "'")))))
			%end;
			%else %do;
				%qsysfunc(dequote(&myNList.))
			%end;
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(getValueFromList);
		%end;
		%else %if &errHandler. = 'PROHIBITED' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%getValueFromList(&listDeVar., delim='%' <,...>)) avec le délimiteur &delim. qui est non autorisé!;
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%getValueFromList()) sans argument ou avec un argument vide, veuillez consulter l%str(%')aide ci-dessous;

			%help(getValueFromList);
		%end;

	%MACRO_END: /** FIN **/
%MEND getValueFromList;
/*
Exemple :
	%getValueFromList(?);
	%getValueFromList();

	%let maListe = Minnie Daisy Mickey Donald Dingo Clarabelle;
	%let maNlleListe = %getValueFromList(&maListe.);
	%put WARNING:--[APP]-- ma liste nommée %nrstr(&maNlleListe.) contient &maNlleListe;

	%let maNlleListe = %getValueFromList(&maListe., verbose=on);
	%put WARNING:--[APP]-- ma liste nommée %nrstr(&maNlleListe.) contient &maNlleListe;

	%let maNlleListe = %getValueFromList(&maListe., delim='-', verbose=on);
	%put WARNING:--[APP]-- ma liste nommée %nrstr(&maNlleListe.) contient &maNlleListe;

	%let maNlleListe = %getValueFromList(&maListe., delim=', ');
	%put WARNING:--[APP]-- ma liste nommée %nrstr(&maNlleListe.) contient &maNlleListe;

	%let maNlleListe = %getValueFromList(&maListe., delim=' - ');
	%put WARNING:--[APP]-- ma liste nommée %nrstr(&maNlleListe.) contient &maNlleListe;

	%let maNlleListe = %getValueFromList(&maListe., delim='%');
	%put WARNING:--[APP]-- ma liste nommée %nrstr(&maNlleListe.) contient &maNlleListe;

	%let ma3emVal = %getValueFromList(&maListe., delim='-', verbose=on, position=3);
	%put WARNING:--[APP]-- la 3čme valeur de ma liste est &ma3emVal.;

	%let ma3emVal = %getValueFromList(&maListe., position=3);
	%put WARNING:--[APP]-- la 3čme valeur de ma liste est &ma3emVal.;
*/

%MACRO
	isUnixPath(file) / store
	des="Permet de savoir si un chemin est de type Unix ou Windows"	
;
	/* détection chemin Unix ou Windows */
	%let isUnixPath = 0;

	%if %index(&file., /) > 0 %then %do;
		%let isUnixPath = 1;
	%end;

	%sysfunc(compress(&isUnixPath.))
%MEND isUnixPath;
/**
Exemple :
	%let myFile = C:\toto\titi;
	data _null_;
		*%let isWin = put(%isUnixPath(&myFile.), fmtIsUnix.);
		call symput('isWin', put(%isUnixPath(&myFile.), fmtIsUnix.));
	run;
	%put NOTE:--[APP]-- le chemin fourni "&myFile." est un chemin de type &isWin.;

	%let myFile = M47624/toto/titi;
	data _null_;
		*%let isWin = put(%isUnixPath(&myFile.), fmtIsUnix.);
		call symput('isWin', put(%isUnixPath(&myFile.), fmtIsUnix.));
	run;
	%put NOTE:--[APP]-- le chemin fourni "&myFile." est un chemin de type &isWin.;
 **/

%MACRO
	mkDir(myPath, myFolder) / store
	des="Permet de créer un répertoire"	
;
	%let myFolder = %qsysfunc(dequote(&myFolder.));
	%let myPath = %qsysfunc(dequote(&myPath.));

	X CD "&myPath.";
	X mkdir "&myFolder.";

	%let dummy = %qsysfunc(dequote(""));
%MEND mkDir;
/**
Exemple :
	%mkDir('F:\SASDATA\KST', 'makeMe1');
 **/

%MACRO
	isFile(file, mkdir=NO, verbose=off) / store
	des="Permet de connaître l'existence d'un fichier au sens UNIX (fichier régulier ou dossier/répertoire)"
;
	%if %quote(&file.) eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if %quote(&file.) eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%let myFile = %qsysfunc(dequote(&file.));
			%let isUnix = %isUnixPath(&myFile.);

			%let slashC = \;
			%if &isUnix. eq 1 %then %do;
				%let slashC = /;
			%end;

			%let lastWord = %qsysfunc(scan("&myFile.", -1, "&slashC."));
			%let path = %qsysfunc(substr(&myFile., 1, %sysfunc(find(&myFile., &lastWord.))-2));

			%if %upcase(&verbose.) eq ON %then %do;
				%let OSName = Windows;
				%if &isUnix. eq 1 %then %do;
					%let OSName = Unix;
				%end;

				%put NOTE:--[APP]-- le chemin complet fourni en argument, "&myFile." est un chemin &OSName.;
				%put NOTE:--[APP]-- le dernier mot est &lastWord.;
				%put NOTE:--[APP]-- le chemin absolu est &path.;
				%put;
			%end;

			%if %sysfunc(fileexist("&myFile.")) %then %do;
				%let isThisFile = 1;

				%if %upcase(&verbose.) eq ON %then %do;
					%put NOTE:--[APP]-- "&myFile." existe;

					%if %upcase(&mkdir.) eq YES %then %do;
						%put NOTE:--[APP]-- la création du répertoire nommé &lastWord. ne sera pas prise en compte;
					%end;

					%put;
				%end;
			%end;
			%else %do;
				%let isThisFile = 0;

				%if %upcase(&verbose.) eq ON %then %do;
					%put NOTE:--[APP]-- "&myFile." n%str(%')existe pas;
				%end;

				%if %upcase(&mkdir.) eq YES %then %do;
					%mkDir("&path.", "&lastWord.");

					%if %upcase(&verbose.) eq ON %then %do;
						%put NOTE:--[APP]-- la création du répertoire a été demandée;
						%put NOTE:--[APP]-- le répertoire nommé &lastWord. a bien été créé ŕ l%str(%')adresse suivante "&path.";
					%end;

					%put;
				%end;
			%end;
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(isFile);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%isFile()) sans argument ou avec un argument vide, veuillez consulter l%str(%')aide ci-dessous;

			%help(isFile);
		%end;

	%MACRO_END: /** FIN **/
		%if &errHandler. = 'OK' and %upcase(&mkdir.) ne YES %then %do;
			%sysfunc(compress(&isThisFile.))
		%end;
%MEND isFile;
/**
Exemple :
	%isFile(?);
	%isFile();

	%let myFile = 'C:\toto\tata\kim\titiW';
	%let isFile = %isFile(&myFile., verbose=ON);

	%let myFile = 'C:\toto\tata\kim\titiW';
	%let isFile = %isFile(&myFile.);

	%let myFile = 'F:\SASDATA\KST\';
	%let isFile = %isFile(&myFile., verbose=ON);

	%let myFile = 'F:\SASDATA\KST\makeMe1';
	%let isFile = %isFile(&myFile., verbose=ON);

	%let myFile = 'F:\SASDATA\KST\makeMe1';
	%let isFile = %isFile(&myFile., mkdir=YES, verbose=ON);
	%put NOTE:--[APP]-- &isFile.;

	%let myFile = 'M47624/toto/kim/ma/titiU';
	%let isFile = %isFile(&myFile., verbose=ON);
 **/

%MACRO
	isTable(tableName) / store
	des="Permet de vérifier l'existence d'une table SAS"
;
	%if &tableName. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &tableName. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%if %sysfunc(exist(&tableName.)) %then %do;
				%sysfunc(compress(1))
				%goto MACRO_END;
			%end;

			%sysfunc(compress(0))
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(isTable);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%isTable()) sans argument ou avec un argument vide, veuillez consulter l%str(%')aide ci-dessous;

			%help(isTable);
		%end;

	%MACRO_END: /** FIN **/
%MEND isTable;
/**
Exemple :
	%isTable(?);
	%isTable();

	%let isTab = %isTable(myLogSynthesis);
	%put NOTE:--[APP]-- existence table : &isTab.;
	%let isTab = %isTable(work.myLogSynthesiss);
	%put NOTE:--[APP]-- existence table : &isTab.;
	%macro isTabTest();
		%if &isTab. eq 1 %then %put NOTE:--[APP]-- La table existe;
		%else %put NOTE:--[APP]-- La table n%str(%')existe pas;
	%mend;
	%isTabTest;
 **/

%MACRO
	getTimeStamp(type, verbose=off) / store
	des="Permet de récupérer un time stamp au format AAAAMMJJ, <H>HMMSS ou AAAAMMJJ_<H>HMMSS (defaut : JJMMMAAAA_<H>HMMSS)"
;
	%if &type. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &type. eq %then %do;
		%let errHandler = 'OK';
		%let type = DTS;

		%if %upcase(&verbose.) eq ON %then %do;
			%put NOTE:--[APP]-- l%str(%')appel de la macro %nrstr(%getTimeStamp()) est faite sans argument, le type sera DTS par défaut;
		%end;
		%goto ERR_HANDLER;
	%end;
	%else %if %upcase(&type.) ne D and %upcase(&type.) ne DS and %upcase(&type.) ne T and %upcase(&type.) ne DT and %upcase(&type.) ne DTS %then %do;
		%let errHandler = 'ARGSERR';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';
		%if %upcase(&verbose.) eq ON %then %do;
			%let thisType = %upcase(&type.);
			%put NOTE:--[APP]-- le type choisi est : &thisType.;
		%end;
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%let toDay = %sysfunc(today());
			%let now = %sysfunc(time());
			%let thisDateTime = %sysfunc(datetime());

			%let now1 = %sysfunc(putn(&now., time.));
			%let nowS = %sysfunc(compress(&now1., :)); /*OK*/

			%let dayS = %sysfunc(putn(&toDay., date10.)); /*OK*/

			%let day1 = %sysfunc(putn(&toDay., yymmdd10.));
			%let day1S = %sysfunc(compress(&day1., '-')); /*OK*/

			%if %upcase(&type.) eq DTS %then %do;
				%let timeStamp = &dayS._&nowS.;
			%end;
			%else %if %upcase(&type.) eq DT %then %do;
				%let timeStamp = &day1S._&nowS.;
			%end;
			%else %if %upcase(&type.) eq DS %then %do;
				%let timeStamp = &dayS.;
			%end;
			%else %if %upcase(&type.) eq D %then %do;
				%let timeStamp = &day1S.;
			%end;
			%else %if %upcase(&type.) eq T %then %do;
				%let timeStamp = &nowS.;
			%end;

			%sysfunc(compress(&timeStamp.))
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(getTimeStamp);
		%end;
		%else %if &errHandler. = 'ARGSERR' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%getTimeStamp()) avec un type non connu;

			%help(getTimeStamp);
		%end;

	%MACRO_END: /** FIN **/
%MEND getTimeStamp;
/**
Exemple :
	%getTimeStamp(?);
	%let myTS = %getTimeStamp();
	%let myFileName = Fichier_&myTS.;
	%put NOTE:--[APP]-- mon time stamp est &myTS. - &myFileName.;

	%let myTS = %getTimeStamp(DTS);
	%let myFileName = Fichier_&myTS.;
	%put NOTE:--[APP]-- mon time stamp est &myTS. - &myFileName.;

	%let myTS = %getTimeStamp(D, verbose=ON);
	%let myFileName = Fichier_&myTS.;
	%put NOTE:--[APP]-- mon time stamp est &myTS. - &myFileName.;

	%let myTS = %getTimeStamp(DS);
	%let myFileName = Fichier_&myTS.;
	%put NOTE:--[APP]-- mon time stamp est &myTS. - &myFileName.;

	%let myTS = %getTimeStamp(T);
	%let myFileName = Fichier_&myTS.;
	%put NOTE:--[APP]-- mon time stamp est &myTS. - &myFileName.;

	%let myTS = %getTimeStamp(DT);
	%let myFileName = Fichier_&myTS.;
	%put NOTE:--[APP]-- mon time stamp est &myTS. - &myFileName.;

	%let myTS = %getTimeStamp(Z);
	%let myFileName = Fichier_&myTS.;
	%put NOTE:--[APP]-- mon time stamp est &myTS. - &myFileName.;
 **/

%MACRO
	runTime(myVar) / store
	des="Permet de chronométrer le temps d'exécution d'un traitement"
;
%global TOP runBegin;

	%if &myVar. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'HELP' %then %do;
			%help(runTime);
		%end;
		%else %do;
			%if %symexist(TOP) and &TOP. eq  %then %do;
				%let TOP = START;

				%let runBegin = %sysfunc(Datetime());
				%let runEnd =;

				%put;
				%put NOTE:--[APP]-- début chronomčtre : %sysfunc(sum(&runBegin.), datetime16.) -----;
				%put;
			%end;
			%else %if %symexist(TOP) and &TOP. eq START %then %do;
				%let TOP = ;

				%let runEnd = %sysfunc(datetime());
				%let runDiff = %sysfunc(sum(&&runEnd., -&&runBegin.));

				%put;
				%put NOTE:--[APP]-- fin chronomčtre : %sysfunc(sum(&runEnd.), datetime16.) -----;
				%put NOTE:--[APP]-- temps passé (HH:MM:SS) = %sysfunc(sum(&runDiff.), time8.) -----;
				%put;

				data _null_;
					%SYMDEL TOP runBegin;
				run;
			%end;
		%end;

	%MACRO_END: /** FIN **/
%MEND runTime;
/**
Exemple :
	%runTime(?);

	%runTime();
		data test1;
			time_slept=sleep(131, 1);

			do key=1 to 3000000;
				length data $64.;
				data = put(key, words64.);
				output test1;
			end;
		run;
	%runTime();
 **/

%MACRO
	sendFile(myFullFile) / store
	des="Permet d'attacher des fichiers en précisant leur type de contenu"
;
	%if &myFullFile. ne %then %do;
		%let thisFile = %qsysfunc(dequote(&myFullFile.));

		%let isUnix = %isUnixPath(&thisFile.);
		%let slashC = \;
		%if &isUnix. eq 1 %then %do;
			%let slashC = /;
		%end;

		%let myFileTMP = %sysfunc(prxchange(s|(^.*)\&slashC..+$|\1|, -1, %nrbquote(&thisFile.)));
		%let myFile = %sysfunc(substr(%nrbquote(&thisFile), %length(&myFileTMP.)+2));

		%if %index(&myFile., .) > 0 %then %do;
			%let myExtTMP = %sysfunc(prxchange(s|(^.*)\..+$|\1|, -1, %nrbquote(&myFile.)));
			%let myExt = %sysfunc(substr(%nrbquote(&myFile), %length(&myExtTMP.)+2));
		%end;
		%else %do;
			%let myExt = NOEXT;
			%put WARNING:--[APP]-- &thisFile. est sans extension et sera envoyé tel quel (erreurs potentiels...);
		%end;

		%if &myExt. eq NOEXT %then %do;
			%let contentType = %sysfunc(substr("&thisFile." CT="APPLICATION/OCTET-STREAM" EXT="", 1));
		%end;
		%else %if %upcase(&myExt.) eq CSV
				  or %upcase(&myExt.) eq XLS
				  or %upcase(&myExt.) eq XLSX
				  or %upcase(&myExt.) eq XLSM
		%then %do;
			%let contentType = %sysfunc(substr("&thisFile." CT="APPLICATION/MSEXCEL" EXT="&myExt.", 1));
		%end;
		%else %if %upcase(&myExt.) eq DOC
				  or %upcase(&myExt.) eq DOCX
				  or %upcase(&myExt.) eq DOCM
		%then %do;
			%let contentType = %sysfunc(substr("&thisFile." CT="APPLICATION/DOCX" EXT="&myExt.", 1));
		%end;
		%else %if %upcase(&myExt.) eq LOG
				  or %upcase(&myExt.) eq TXT
		%then %do;
			%let contentType = %sysfunc(substr("&thisFile." CT="TEXT/PLAIN" EXT="&myExt.", 1));
		%end;
		%else %if %upcase(&myExt.) eq SAS7BDAT
				  or %upcase(&myExt.) eq SAS
		%then %do;
			%let contentType = %sysfunc(substr("&thisFile." CT="APPLICATION/SAS" EXT="&myExt.", 1));
		%end;
		%else %if %upcase(&myExt.) eq ZIP
				  or %upcase(&myExt.) eq 7Z
		%then %do;
			%let contentType = %sysfunc(substr("&thisFile." CT="APPLICATION/ZIP" EXT="&myExt.", 1));
		%end;
		%else %if %upcase(&myExt.) eq PDF %then %do;
			%let contentType = %sysfunc(substr("&thisFile." CT="APPLICATION/PDF" EXT="&myExt.", 1));
		%end;
		%else %do;
			%let contentType = %sysfunc(substr("&thisFile." CT="APPLICATION/OCTET-STREAM" EXT="", 1));
		%end;

		%if %sysfunc(fileexist(&thisFile.)) %then %do;
			%sysfunc(substr(&contentType., 1))
		%end;
		%else %do;
			%put ERROR:--[APP]-- &thisFile. n%str(%')existe pas, veuillez préciser/vérifier le chemin en paramčtre;
		%end;
	%end;
%MEND sendFile;
/**
Exemple :
	%sendFile();
	%let emailCT = %sendFile(F:\SASDATA\KST);
	%put NOTE:--[APP]-- &emailCT.;

	%let emailCT = %sendFile("F:\SASDATA\KST\Kim.tr.zip.xlsx.sas7bdat.docx.docm");
	%put NOTE:--[APP]-- &emailCT.;

	%let emailCT = %sendFile(F:\SASDATA\KST\testDDE.xlsm);
	%put NOTE:--[APP]-- &emailCT.;
**/

%MACRO
	email2List(myEmailList) / store
	des="Permet de normaliser la liste des destinaires pour l'envoi des mails"	
;
	%if &myEmailList. ne %then %do;
		%let totVar = %getNbVal(&myEmailList.);
		%let myNList = ;

		%do i=1 %to &totVar.;
			%let tVar = %scan(&myEmailList., &i., ' ');

			%let myNList = &myNList. "&tVar.",;
		%end;

		%sysfunc(substr(%nrbquote(&myNList.), 1))
	%end;
%MEND email2List;
/**
Exemple :
	%let myList = %email2List(michel@truong.ber kim@truong.com);
	%put NOTE:--[APP]-- &myList.;
 **/

%MACRO
	formatEmail(myEmail) / store
	des="Permet de normaliser le corps du mail avec des sauts de lignes \n"	
;
	%if &myEmail. ne %then %do;
		%let i = 1;
		%let myNList = ;

		%do %while(%scan(&myEmail., &i., '_') ne );
			%let tVar = %scan(&myEmail., &i., '_');
			%let lastChar = %sysfunc(substr(&tVar., %eval(%sysfunc(length(&tVar.))), 1));

			%if &lastChar. eq # %then %do;
				%let tVarTMP = %sysfunc(substr(&tVar., 1, %eval(%sysfunc(length(&tVar.))-1)));

				%let myNList = &myNList. %sysfunc(dequote(%nrbquote("PUT '&tVarTMP.';"))) %sysfunc(dequote(%nrbquote("PUT ;")));
			%end;
			%else %do;
				%let myNList = &myNList. %sysfunc(dequote(%nrbquote("PUT '&tVar.';")));
			%end;

			%let i = %eval(&i. + 1);
		%end;

		%sysfunc(substr(%nrbquote(&myNList.), 1))
	%end;
%MEND formatEmail;
/**
Exemple :
	%let myString =
	Salut_
	Tu vas bien?#_
	Je suis un peu fatigué...
	;
	%let myMail = %formatEmail(&myString.);
	%put &myMail.;

	%let myString =
	Bonjour#_
	Veuillez trouver ci dessous la synthčse du fichier LOG_
	   o SYNTHESE LOG SAS_
	     o TOTAL ERREURS  [1]_
	     o TOTAL WARNINGS [2]_
	     o TOTAL NOTES    [3]_
	   o NOTES A SURVEILLER [4]_
	   o SYNTHESE LOG DEVELOPPEUR_
	     o TOTAL ERREURS  [5]_
	     o TOTAL WARNINGS [6]_
	     o TOTAL NOTES    [7]_
	Pour plus de détail consultez les fichiers en PJ
	;
	%formatEmail(&myString.);
 **/

%MACRO
	sendMail(to, cc=, bc=, subject=, mail=, attach=, from=, replyto=) / store
	des="Permet d'envoyer un email"
;
	%if &to. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &to. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%if &to. ne %then %do;
				%let toF = %email2List(&to.);
			%end;
			%if &cc. ne %then %do;
				%let ccF = %email2List(&cc.);
			%end;
			%if &bc. ne %then %do;
				%let bcF = %email2List(&bc.);
			%end;

			%if &from. ne %then %do;
				%let fromF = "&from.";
			%end;
			%if &replyto. ne %then %do;
				%let replytoF = "&replyto.";
			%end;
			%if &attach. ne %then %do;
				%let attachF = %str(&attach.);
			%end;

			%if &mail. ne %then %do;
				%let mailF = %formatEmail(&mail.);
			%end;

			FILENAME OUTBOX EMAIL
							%if &from. ne %then %do;
								FROM = (&fromF.)
							%end;
							%if &to. ne %then %do;
								TO = (&toF.)
							%end;
							%if &cc. ne %then %do;
								CC = (&ccF.)
							%end;
							%if &bc. ne %then %do;
								BCC = (&bcF.)
							%end;
							%if &replyto. ne %then %do;
								REPLYTO = (&replytoF.)
							%end;

							%if &subject. ne %then %do;
								SUBJECT = (&subject.)
							%end;
							%else %do;
								SUBJECT = ("")
							%end;

							%if &attach. ne %then %do;
 								ATTACH = (&attachF.)
							%end;
			;

			DATA _NULL_;
				FILE OUTBOX;

				%if &mail. ne %then %do;
					&mailF.;
				%end;
				%else %do;
					PUT;
				%end;
			RUN;

			FILENAME OUTBOX CLEAR;
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(sendMail);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%sendMail()) sans destinataire;

			%help(sendMail);
		%end;

	%MACRO_END: /** FIN **/
%MEND sendMail;
/**
Exemple :
	%sendMail(?);
	%sendMail();

	%sendMail(
		from = SAS.PRD@XYZ-Hunter.com,
		to = michel.truong@ext.XYZ-Hunter.com,
		subject = "Je teste..."
		);

	%let attach =
			%sendFile(F:\SASDATA\KST\testDDE.xlsm)
			%sendFile(F:\SASDATA\KST\testr.txt)
			%sendFile(F:\SASDATA\KST\testm.zip)
		;
	%let myEmail =
		Yo!#_
		Comment que ça va bien?_
		Je t envoie un petit test#_
		Michel
	;
	%sendMail(
		from = SAS.PRD@XYZ-Hunter.com,
		to = michel.truong@ext.XYZ-Hunter.com
			 mtruong@iok.fr,

		attach = &attach.,
		
		subject = "Je teste, hé hé o(^ ^ o)(o ^ ^)o",
		
		mail = &myEmail.
		);
 **/

%MACRO
	isMail(emailAdr) / store
	des="Permet de vérifier le bon formatage d'un email"
;
	%if &emailAdr. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &emailAdr. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%sysfunc(prxmatch(
						%sysfunc(prxparse(/[a-z0-9!#\$%&''*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&''*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/i)),
						&emailAdr.)
					)
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(isMail);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%isMail()) sans argument;

			%help(isMail);
		%end;

	%MACRO_END: /** FIN **/
%MEND isMail;
/**
Exemple :
	%isMail(?);
	%isMail();

	%let isValidEmail = %isMail(michel.truong@ext.XYZ-Hunter.com);
	%put NOTE:--[APP]-- le mail est &isValidEmail.;

	%let isValidEmail = %isMail(michel.truong@ext);
	%put NOTE:--[APP]-- le mail est &isValidEmail.;

	%let isValidEmail = %isMail(@junk.mail);
	%put NOTE:--[APP]-- le mail est &isValidEmail.;

	data t_email;
		length first email phone $32;
		input first email phone $32.;

		datalines;
			Kim1 Kim@mail.com 0689912549
			Kim2 K123_yo@gmail.fr.com +33698912549
			Kim3 @gml.eu.com +33 6 79 91 25 49
			Kim4 @gml.com +33-6-79-91-25-49
			Kim5 K@m (555)-555-5555
			Kim6 K@@@@@gmail.com 555-555-5555
		;
	run;

	proc sql;
		create table t_checkMail as
			select email, resolve('%isMail('||email||')') as validMail
			from t_email
		;
	quit;
 **/

%MACRO
	isPhone(phoneNumber) / store
	des="Permet de vérifier le bon formatage d'un téléphone"
;
	%if %quote(&phoneNumber.) eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if %quote(&phoneNumber.) eq or %quote(&phoneNumber.) eq "" %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%sysfunc(prxmatch(
						%sysfunc(prxparse(/^(\+{1}[\d]{1,3})?([\s-.])?(([\(]{1}[\d]{2,3}[\)]{1}[\s-.]?)|([\d]{2,3}[\s-.]?))?\d[\-\.\s]?\d[\-\.\s]?\d[\-\.\s]?\d[\-\.\s]?\d[\-\.\s]?\d?[\-\.\s]?\d?[\-\.\s]?\d?[\-\.\s]?\d?$/)),
						%quote(&phoneNumber.))
					)
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(isPhone);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%isPhone()) sans argument;

			%help(isPhone);
		%end;

	%MACRO_END: /** FIN **/
%MEND isPhone;
/**
Exemple :
	%isPhone(?);
	%isPhone();

	%let isValidPhone = %isPhone(+33 6 98 97 21 37);
	%put NOTE:--[APP]-- le téléphone est &isValidPhone.;

	data t_data;
		length first email phone $32;
		input first email phone $32.;

		datalines;
			Kim1 Kim@mail.com 0689912549
			Kim2 K123_yo@gmail.fr.com +33698912549
			Kim3 @gml.eu.com +33 6 79 91 25 49
			Kim4 @gml.com +33-6-79-91-25-49
			Kim5 K@m (555)-555-5555
			Kim6 K@@@@@gmail.com 555.555-5555
			Kim7 K@@@@@gmail.com +33-555-555-5555
			Kim8 K@@@@@gmail.com (0)6789101112
			Kim9 Kim@mail.com 068991254910111213
		;
	run;

	proc sql;
		create table t_checkPhone as
			select phone, resolve('%isPhone('||phone||')') as validPhone
			from t_data
		;
	quit;
 **/

%MACRO
	file2Cipher(myFile, cipher=ON) / store
	des="Permet d'obfusquer un fichier plat afin de rendre la lecture difficile"
;
	%if &myFile. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &myFile. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%if %isFile(&myFile.) eq 0 %then %do;
				%put ERROR:--[APP]-- le fichier transmis en argument n%str(%')existe pas, veuillez vérifier son orthographe/chemin;
				%goto MACRO_END;
			%end;

			%let obfext = .OBF;

			%let myFileTMP = %qsysfunc(dequote(&myFile.));
			%let isUnix = %isUnixPath(&myFileTMP.);

			%let slashC = \;
			%if &isUnix. eq 1 %then %do;
				%let slashC = /;
			%end;

			%let fileName2Save = %qsysfunc(scan("&myFileTMP.", -1, "&slashC."));
			%let path2Save = %qsysfunc(substr(&myFileTMP., 1, %sysfunc(find(&myFileTMP., &fileName2Save.))-2));

			%if %upcase(&cipher.) eq ON %then %do;
				data _null_;
					length obfuscatedStr $ 76 buffer $ 57;
					retain buffer '';

					/** on lit octet par octet **/
					infile "&myFile." recfm=F lrecl=1 end=eof;
					input @1 stream $char1.;

					file "&path2Save.\&fileName2Save.&obfext." lrecl=76;
					/** bufferisation de l'octet lu **/
					substr(buffer, (_N_ - (ceil(_N_ / 57) - 1) * 57), 1) = byte(rank(stream));

					if mod(_N_, 57) = 0 or EOF then do;
						if eof then
							obfuscatedStr = put(trim(buffer), $base64X76.);
						else
							obfuscatedStr = put(buffer, $base64X76.);

					    put obfuscatedStr;

					    buffer = '';
					end;
				run;

				%put NOTE:--[APP]-- le fichier obfusqué nommé &fileName2Save.&obfext. se trouve ŕ &path2Save.;
				%put WARNING:--[APP]-- /!\pensez ŕ supprimer le fichier source/!\;
			%end;
			%else %if %upcase(&cipher.) eq OFF %then %do;
				%let fileUnOBF2Save = %qsysfunc(substr(&fileName2Save., 1, %sysfunc(find(%upcase(&fileName2Save.), &obfext.))-1));

				data _null_;
					length b64 $ 76 byte $ 1;
					infile "&path2Save.\&fileName2Save." lrecl= 76 truncover length=b64length;
					input @1 b64 $base64X76.;
					if _N_=1 then put2Log "NOTE:--[APP]-- Base64 détecté avec longueur : " b64length;

					file "&path2Save.\&fileUnOBF2Save." recfm=F lrecl= 1;
					do i=1 to (b64length/4)*3;
						byte = byte(rank(substr(b64, i, 1)));
						put byte $char1.;
					end;
				run;

				%put NOTE:--[APP]-- le fichier obfusqué nommé &fileName2Save. a été correctement mis en clair;
				%put NOTE:--[APP]-- nom : &fileUnOBF2Save.;
				%put NOTE:--[APP]-- chemin : &path2Save.;
			%end;
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(file2Cipher);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%file2Cipher()) sans argument;

			%help(file2Cipher);
		%end;

	%MACRO_END: /** FIN **/
%MEND file2Cipher;
/**
Exemple :
	%file2cipher(?);
	%file2cipher();

	%file2cipher('F:\SASDATA\KST\tests1.txt');
	%file2cipher('F:\SASDATA\KST\tests1.txt.obf', cipher=OFF);

	%file2cipher('F:\SASDATA\KST\test2OBF.txt');
	%file2cipher('F:\SASDATA\KST\test2OBF.txt.obf', cipher=OFF);

	%file2cipher('\\Chemin abolu\Reseau\ou\non\Librairie_SAS\00_LIB_Macros_Communes.sas');
 **/

%MACRO
	logParser(myLog, emailLog=NO, from=, to=, cc=, step=, signature=) / store
	des="Permet d'analyser un fichier log SAS"
;
	%if &myLog. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &myLog. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			proc format /*library=stMacL*/;
				value fmtLogErrType
					1 = 'ERROR [SAS]'
					2 = 'WARNING [SAS]'
					3 = 'NOTE [SAS]'
					4 = 'NOTE [SAS] - A SURVEILLER : 0 OBS'
					5 = 'NOTE [SAS] - A SURVEILLER : ARRET TRAITEMENT'
					6 = 'ERROR [APP]'
					7 = 'WARNING [APP]'
					8 = 'NOTE [APP]'
				;
			run;

			%if %isFile(&myLog.) eq 0 %then %do;
				%put ERROR:--[APP]-- le fichier LOG transmis en argument n%str(%')existe pas, veuillez vérifier son orthographe/chemin;
				%goto MACRO_END;
			%end;

			%let myLogTMP = %qsysfunc(dequote(&myLog.));
			%let isUnix = %isUnixPath(&myLogTMP.);

			%let slashC = \;
			%if &isUnix. eq 1 %then %do;
				%let slashC = /;
			%end;

/*			%let fileName2Save = %qsysfunc(scan("&myLogTMP.", -1, "&slashC."));*/
/*			%let path2Save = %qsysfunc(substr(&myLogTMP., 1, %sysfunc(find(&myLogTMP., &fileName2Save.))-2));*/
/*			%let fileName2Save = LOG_PARSED_%qsysfunc(scan("&myLogTMP.", -1, "&slashC."));*/

			filename logDsc "&myLogTMP.";
			data myLogDATA;
				attrib
					logName
						length=$512.
						label='Nom du fichier LOG'
					txt
						length=$512.
						label='message dans le SAS LOG'
					linum
						length=8.
						format=8.
						label='Ligne # dans le SAS LOG'
					type
						length=8.
						format=fmtLogErrType.
						label='Type'
		        ;
				infile logDsc lrecl=1024 pad END=eof;
		 
				INPUT @1 getline $1024.;

				logName = "&myLogTMP.";
				intext = substr(upcase(getline), 1, 1023);
		 
				linum + 1;

		        if index(intext, 'ERROR') eq 1 then do;
					if index(intext, '-[HELP]-') eq 0 then do;
						if index(intext, '[APP]') then do;
							type = 6;
							txt = intext;
							output;
						end;
						else do;
							type = 1;
							txt = intext;
							output;
						end;
					end;
				end;
		        else if index(intext, 'WARNING') eq 1 then do;
					if index(intext, '-[HELP]-') eq 0 then do;
						if index(intext, '[APP]') then do;
							type = 7;
							txt = intext;
							output;
						end;
						else do;
							type = 2;
							txt = intext;
							output;
						end;
					end;
				end;
		        else if index(intext, 'NOTE') eq 1 then do;
					if index(intext, '-[HELP]-') eq 0 then do;
						if index(intext, '[APP]') then do;
							type = 8;
							txt = intext;
							output;
						end;
						else do;
							if index(intext, 'STOPPED PROCESSING') then do;
								type = 5;
				 				txt = intext;
					            output;
							end;
							else if
								index(intext, 'WITH 0 ROWS')
								or
								index(intext, 'HAS 0 OBSERVATIONS')
								or
								index(intext, 'NOTE: 0 RECORDS')
								or
								index(intext, 'NOTE: NO ROWS')
							then do;
								type = 4;
				 				txt = intext;
					            output;
							end;
							else do;
								type = 3;
								txt = intext;
								output;
							end;
						end;
					end;
				end;
				drop getline eof intext;
			run;

			proc sort data=myLogDATA; by type linum; run;

			proc sql noprint;
				create table myLogSynthesis as
					select count(1) as NB, type, compress(put(type, 8.)) as cType
					from myLogDATA
					group by type, calculated cType
				;
			quit;

			%if %upcase(&emailLog.) eq YES %then %do;
				%let SAS_ERRORS       = 0;
				%let SAS_WARNINGS     = 0;
				%let SAS_NOTES        = 0;
				%let SAS_TRAPPED_NOTE = 0;
				%let DEV_ERRORS       = 0;
				%let DEV_WARNINGS     = 0;
				%let DEV_NOTES        = 0;

				proc sql noprint; 
					select NB into:SAS_ERRORS from myLogSynthesis where type = 1;
					select NB into:SAS_WARNINGS  from myLogSynthesis where type = 2;
					select NB into:SAS_NOTES from myLogSynthesis where type = 3;
					select NB into:SAS_TRAPPED_NOTE from myLogSynthesis where type in (4, 5);
					select NB into:DEV_ERRORS from myLogSynthesis where type = 6;
					select NB into:DEV_WARNINGS  from myLogSynthesis where type = 7;
					select NB into:DEV_NOTES from myLogSynthesis where type = 8;
				quit;

				%let SAS_ERRORS       = %sysfunc(strip(&SAS_ERRORS.      ));
				%let SAS_WARNINGS     = %sysfunc(strip(&SAS_WARNINGS.    ));
				%let SAS_NOTES        = %sysfunc(strip(&SAS_NOTES.       ));
				%let SAS_TRAPPED_NOTE = %sysfunc(strip(&SAS_TRAPPED_NOTE.));
				%let DEV_ERRORS       = %sysfunc(strip(&DEV_ERRORS.      ));
				%let DEV_WARNINGS     = %sysfunc(strip(&DEV_WARNINGS.    ));
				%let DEV_NOTES        = %sysfunc(strip(&DEV_NOTES.       ));

				data _null_;
					call symput('TOT_ERRORS' , strip(sum(&SAS_ERRORS., &DEV_ERRORS., 0)));
					call symput('TOT_WARNINGS' , strip(sum(&SAS_WARNINGS., &DEV_WARNINGS., 0)));
					call symput('TOT_NOTES' , strip(sum(&SAS_NOTES., &DEV_NOTES., 0)));
				run;

				%if &to. eq %then %do;
					%put ERROR:--[APP]-- il n%str(%')y a pas de destinataire(s), merci de le(s) renseigner;
					%help(logParser);
					%goto MACRO_END;
				%end;

				%let attach =
						%sendFile(&myLogTMP.)
						%sendFile(%sysfunc(pathName(WORK))&slashC.mylogdata.sas7bdat)
						%sendFile(%sysfunc(pathName(WORK))&slashC.mylogsynthesis.sas7bdat)
					;

				%let myEmail = 
Bonjour#_
Veuillez trouver ci dessous la synthčse du fichier LOG#_
> SYNTHESE LOG SAS_
=>> TOTAL ERREURS  [&SAS_ERRORS.]_
=>> TOTAL WARNINGS [&SAS_WARNINGS.]_
=>> TOTAL NOTES    [&SAS_NOTES.]#_
> NOTES A SURVEILLER [&SAS_TRAPPED_NOTE.]#_
> SYNTHESE LOG FONCTIONNELLE_
=>> TOTAL ERREURS  [&DEV_ERRORS.]_
=>> TOTAL WARNINGS [&DEV_WARNINGS.]_
=>> TOTAL NOTES    [&DEV_NOTES.]#_
Pour plus de détail consultez les fichiers en PJ#_
Cordialement#_
&signature.
				;

				%sendMail(
					%if &from. ne %then %do;
						from = &from.,
					%end;
					to = &to.,
					%if &cc. ne %then %do;
						cc = &cc.,
					%end;

					attach = &attach.,
					
					subject = 
						%if &TOT_ERRORS. > 0 %then %do;
							%if &step. ne %then %do;
								"[ANALYSE LOG] - ERREUR(S) DETECTEE(S) - NOM ETAPE/PROGRAMME : &step."
							%end;
							%else %do;
								"[ANALYSE LOG] - ERREUR(S) DETECTEE(S)"
							%end;
						%end;
						%else %if &TOT_WARNINGS. > 0 %then %do;
							%if &step. ne %then %do;
								"[ANALYSE LOG] - ALERTE(S) DETECTEE(S) - NOM ETAPE/PROGRAMME : &step."
							%end;
							%else %do;
								"[ANALYSE LOG] - ALERTE(S) DETECTEE(S)"
							%end;
						%end;
						%else %do;
							%if &SAS_TRAPPED_NOTE. > 0 %then %do;
								%if &step. ne %then %do;
									"[ANALYSE LOG] - SANS ERREUR MAIS A SURVEILLER - NOM ETAPE/PROGRAMME : &step."
								%end;
								%else %do;
									"[ANALYSE LOG] - SANS ERREUR MAIS A SURVEILLER"
								%end;
							%end;
							%else %do;
								%if &step. ne %then %do;
									"[ANALYSE LOG] - SANS ERREUR - NOM ETAPE/PROGRAMME : &step."
								%end;
								%else %do;
									"[ANALYSE LOG] - SANS ERREUR"
								%end;
							%end;
						%end;
					,
					
					mail = &myEmail.
					);
			%end;
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(logParser);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%logParser()) sans argument;

			%help(logParser);
		%end;

	%MACRO_END: /** FIN **/
%MEND logParser;
/**
Exemple :
	%logParser(?);
	%logParser();

	%logParser('F:\SASDATA\KST\test.log');
	%logParser('F:\SASDATA\KST\test.log',
		emailLog = YES,
		from = SAS.PRD@XYZ-Hunter.com,
		to = michel.truong@ext.XYZ-Hunter.com
			 mtruong@iok.fr
		,
		step = calcul truc muche,
		signature = Equipe DEV
	);
 **/

%MACRO
	delGlobalVars() / store
	des="Permet de vider les macros variables globales"
;

	data gVarTmp;
		set SASHELP.VMACRO(keep=SCOPE NAME WHERE=(scope='GLOBAL'
												  /*and NAME not in (
												  					'SASWORKLOCATION', '_CLIENTAPP', '_CLIENTAPPABREV',
																	'_CLIENTMACHINE', '_CLIENTPROJECTNAME', '_CLIENTPROJECTPATH',
																	'_CLIENTTASKLABEL', '_CLIENTUSERID', '_CLIENTUSERNAME',
																	'_CLIENTVERSION', '_EG_WORKSPACEINIT', '_SASHOSTNAME',
																	'_SASPROGRAMFILE', '_SASSERVERNAME', 'SYSDBMSG', 'SYSDBRC',
																	'SYS_SQL_IP_ALL', 'SYS_SQL_IP_STMT',
																	'SASLIBROOT'
																)*/
												  and NAME not like '%ROOT%'
												  and NAME not like 'P_%'
												  and NAME not like 'APP_%'
												  and NAME not like '%SAS%'
												  and NAME not like 'SYS%'
												  and NAME not like '_CLIENT%'
												)
						);
	run;

	data _NULL_;
		set gVarTmp;

		call execute('%SYMDEL ' !! TRIM(LEFT(NAME)) !! ' / NOWARN;');
	run;

	proc datasets library=WORK memtype=data nolist nodetails;
		delete gVarTmp;
	quit;
%MEND delGlobalVars;

%MACRO
	setDynVar(dynVarFile, backUP=YES, displayVar=NO, cleanVarBefore=YES) / store
	des="Permet de créer des macro variables globales ŕ partir d'un fichier de paramétrage CSV"
;
	%if &dynVarFile. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &dynVarFile. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%if %upcase(&cleanVarBefore.) eq YES %then %do;
				%delGlobalVars();
			%end;

			%if %isFile(&dynVarFile.) eq 0 %then %do;
				%put ERROR:--[APP]-- le fichier des variables transmis en argument n%str(%')existe pas, veuillez vérifier son orthographe/chemin;
				%goto MACRO_END;
			%end;

			%let thisFile = %qsysfunc(dequote(&dynVarFile.));

			data myDynVar;
				infile "&thisFile."
				delimiter=";" MISSOVER DSD lrecl=32767 firstobs=1;
			 
				informat varName $64.;
				informat varValue $256.;
				informat comments $512.;
			 
				input 
				varName $
				varValue $
				comments $
				;
			run;

			data _NULL_;
				set myDynVar;
				call symputx(varName, varValue, 'G');
			run;

			%if %upcase(&displayVar.) eq YES %then %do;
				%put _USER_;
			%end;

			%if %upcase(&backUP.) eq YES %then %do;
				%let myDynVarFileTMP = %qsysfunc(dequote(&dynVarFile.));
				%let isUnix = %isUnixPath(&myDynVarFileTMP.);

				%let slashC = \;
				%if &isUnix. eq 1 %then %do;
					%let slashC = /;
				%end;

				%let fileName2Save = %qsysfunc(scan("&myDynVarFileTMP.", -1, "&slashC."));
				%let path2Save = %qsysfunc(substr(&myDynVarFileTMP., 1, %sysfunc(find(&myDynVarFileTMP., &fileName2Save.))-2));
				%let fileName2Save = %qsysfunc(scan("&myDynVarFileTMP.", -1, "&slashC.")).BCK_%getTimeStamp();

				%if &isUnix. eq 0 %then %do;
/*					x "copy &myDynVarFileTMP. &path2Save.&slashC.&fileName2Save. /Y";*/
					x copy /Y "&myDynVarFileTMP." "&path2Save.&slashC.&fileName2Save.";
				%end;
				%else %do;
					x "yes | cp -rf &myDynVarFileTMP. &path2Save.&slashC.&fileName2Save.";
				%end;
			%end;
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(setDynVar);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%setDynVar()) sans argument;

			%help(setDynVar);
		%end;

	%MACRO_END: /** FIN **/
%MEND setDynVar;
/**
Exemple :
	%setDynVar(?);
	%setDynVar();

	%setDynVar('F:\SASDATA\KST\myVar.csv');
	%setDynVar('F:\SASDATA\KST\my Var.csv', displayVar = YES);

	%setDynVar(
		'\\Chemin abolu\Reseau\ou\non\_PARAM_PROJET_\_000_FICHIER_PARAMETRAGE_DTM.csv',
		displayVar=YES,
		backUP=NO
		);
 **/

%MACRO
	updateDynVar(dynVarFile, backUP=YES) / store
	des="Permet de mettre ŕ jour le fichier de paramétrage CSV en argument avec les données de la table SAS de paramétrage"
;
	%if &dynVarFile. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &dynVarFile. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%if %isFile(&dynVarFile.) eq 0 %then %do;
				%put ERROR:--[APP]-- le fichier des variables transmis en argument n%str(%')existe pas, veuillez vérifier son orthographe/chemin;
				%goto MACRO_END;
			%end;

			%if %isTable(myDynVar) ne 1 %then %do;
				%put ERROR:--[APP]-- la table de paramétrage SAS nommée [myDynVar] n%str(%')existe pas, aucune mise ŕ jour ne sera appliquée;
				%goto MACRO_END;
			%end;

			%if %upcase(&backUP.) eq YES %then %do;
				%let myDynVarFileTMP = %qsysfunc(dequote(&dynVarFile.));
				%let isUnix = %isUnixPath(&myDynVarFileTMP.);

				%let slashC = \;
				%if &isUnix. eq 1 %then %do;
					%let slashC = /;
				%end;

				%let fileName2Save = %qsysfunc(scan("&myDynVarFileTMP.", -1, "&slashC."));
				%let path2Save = %qsysfunc(substr(&myDynVarFileTMP., 1, %sysfunc(find(&myDynVarFileTMP., &fileName2Save.))-2));
				%let fileName2Save = %qsysfunc(scan("&myDynVarFileTMP.", -1, "&slashC.")).BCK_%getTimeStamp();

				%if &isUnix. eq 0 %then %do;
/*					x "copy &myDynVarFileTMP. &path2Save.&slashC.&fileName2Save. /Y";*/
					x copy /Y "&myDynVarFileTMP." "&path2Save.&slashC.&fileName2Save.";
				%end;
				%else %do;
					x "yes | cp -rf &myDynVarFileTMP. &path2Save.&slashC.&fileName2Save.";
				%end;
			%end;


			%let thisFile = %qsysfunc(dequote(&dynVarFile.));
			proc export data=myDynVar
				outfile="&thisFile."
				dbms=csv
				replace;
				delimiter=';';
				putnames=no;
			run;
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(updateDynVar);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%updateDynVar()) sans argument;

			%help(updateDynVar);
		%end;

	%MACRO_END: /** FIN **/
%MEND updateDynVar;
/**
Exemple :
	%updateDynVar(?);
	%updateDynVar();

	%updateDynVar('\\Chemin abolu\Reseau\ou\non\_PARAM_PROJET_\_000_FICHIER_PARAMETRAGE_DTM.csv');

	%updateDynVar(
		'\\Chemin abolu\Reseau\ou\non\_PARAM_PROJET_\_000_FICHIER_PARAMETRAGE_DTM.csv',
		backUP=NO
	);
 **/

%MACRO
	makeHistoJobTab(histoTable, err=YES) / store
	des="Créer une table vierge avec un nom générique ou défini des historiques de jobs"
;
	%if &histoTable. eq %then %do;
		%if &err. eq YES %then %do;
			%put WARNING:--[APP]-- une table historique sera construite dans la WORK - Veuillez la sauvegarder;
		%end;
		data histo_Jobs(/*compress=yes*/);
	%end;
	%else %do;
		%if &err. eq YES %then %do;
			%put WARNING:--[APP]-- la table historique des logs en argument n%str(%')existe pas et sera construite;
		%end;
		data &histoTable.(/*compress=yes*/);
	%end;

		set _null_;
		attrib
			stepName label='Nom du Programme/Traitement' length=$128 format=$128.
			weekNum label='N° Semaine' length=$2 format=$2.
			jobDate label='Date du traitement' length=8 format=DDMMYY10.
			jobSTime label='Heure début traitement' length=8 format=DATETIME16.
			jobETime label='Heure fin traitement' length=8 format=DATETIME16.
			jobDuration label='Durée traitement' length=$16 format=$16.
			jobPeriod label='Périodicité Traitement (D, W, M, T, S, A)' length=$1 format=$1.
			jobStatus label='Etats du traitement (OK, KO, WARNING)' length=$16 format=$16.
			comments label='Commentaires' length=$1024 format=$1024.
			nomDev label='Nom du Dévelopeur' length=$128 format=$128.
		;
	run;
%MEND makeHistoJobTab;

%MACRO
	checkHistoLog(histoTable) / store
	des="Vérifie la structure de la table historique des job"
;
	%global histoCheckErr;
	%let histoCheckErr = 0;
	%let myVarL =
				  nomDev
				  stepName
				  weekNum
				  jobDate
				  jobSTime
				  jobETime
				  jobDuration
				  jobPeriod
				  jobStatus
				  comments
	;
	%let myNbVal = %getNbVal(&myVarL.);

	%if &histoTable. ne %then %do;
		proc contents data=&histoTable. out=thisContents noprint; run;
		%do i=1 %to &myNbVal.;
			%let myVar = %scan(&myVarL., &i.);
			
			proc sql noprint;
				select count(1) into: countCheck
				from thisContents
				where name eq "&myVar."
				;
			quit;

			%if &countCheck. eq 0 %then %do;
				%put ERROR:--[APP]-- La table des historiques des jobs n%str(%')est pas correctement formatée (&myVar. absent);
				%let histoCheckErr = 1;

				%goto MACRO_END;
			%end;
		%end;
	%end;

	%MACRO_END: /** FIN **/
%MEND checkHistoLog;

%MACRO
	historyJobLog(histoTable, nomDev=, stepName=, jobPeriod=M, jobStatus=OK, comments=, runTimeAutoOff=ON) / store
	des="Permet de gérer les historiques des traitements (qui, quel traitement, quand, durée, status etc...)"
;
	%global LOGHISTINIT LOGRUNBEGIN;
	%let thisHistoTab = ;

	%if &histoTable. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &histoTable. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';

		%let LOGHISTINIT = 1;

		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%if &histoTable. ne %then %do;
				%let thisHistoTab = &histoTable.;

				%if %isTable(&thisHistoTab.) eq 0 %then %do;
					%makeHistoJobTab(&thisHistoTab., err=NO);
				%end;

				%checkHistoLog(&histoTable.);
				%if &histoCheckErr. > 0 %then %do;
					%goto MACRO_END;
				%end;
			%end;

			%if %symexist(TOP) eq 0 and %symexist(runBegin) eq 0 %then %do;
				%if &runTimeAutoOff. eq ON %then %do;
					%runTime();
					%let LOGRUNBEGIN = &runBegin.;
				%end;
				%else %do;
					%put ERROR:--[APP]-- Veuillez lancer le chronométrage avant avec la macro %nrstr(%runTime();) avant de lancer cette procédure;
				%end;

				%goto MACRO_END;
			%end;

			%if %symexist(TOP) and %symexist(runBegin) %then %do;
				%if &runTimeAutoOff. eq ON %then %do;
					%let runEnd = %sysfunc(datetime());
					%let runDiff = %sysfunc(sum(&&runEnd., -&&runBegin.));
					%let duration = %sysfunc(sum(&runDiff.), time8.);
					%runTime();
				%end;
			%end;

			%makeHistoJobTab(histoJob_TEMP, err=NO);

			%if (&stepName. eq or &stepName. eq '') and %length(&stepName.) = 0 and &LOGHISTINIT. = 2 %then %do;
				%put ERROR:--[APP]-- le nom de l%str(%')étape ne doit pas ętre vide;
				%goto MACRO_END;
			%end;

			%if (&stepName. eq or &stepName. eq '') and %length(&stepName.) = 0 and &LOGHISTINIT. = 1 %then %do;
				%let LOGHISTINIT = 2;
				%goto MACRO_END;
			%end;

			proc sql noprint;
				insert into histoJob_TEMP
				set
					%if (&stepName. ne or &stepName. ne '') and %length(&stepName.) > 0 %then %do;
						%let stepNameF = %qsysfunc(dequote(&stepName.));
						stepName = "&stepNameF.",
					%end;

					weekNum = put(week(today(),'v'),Z2.),
					jobDate = today(),

					jobSTime = &LOGRUNBEGIN.,
					jobETime = &runEnd.,
					jobDuration = "&duration.",

					%if %upcase(&jobPeriod.) eq D
						or %upcase(&jobPeriod.) eq W
						or %upcase(&jobPeriod.) eq M
						or %upcase(&jobPeriod.) eq T
						or %upcase(&jobPeriod.) eq S
						or %upcase(&jobPeriod.) eq A
					%then %do;
						jobPeriod = "&jobPeriod.",
					%end;
					%else %do;
						jobPeriod = "M",
					%end;

					%if %upcase(&jobStatus.) eq OK
						or %upcase(&jobStatus.) eq KO
						or %upcase(&jobStatus.) eq WARNING
					%then %do;
						jobStatus = "&jobStatus.",
					%end;
					%else %do;
						jobStatus = "OK",
					%end;

					%if (&comments. ne or &comments. ne '') and %length(&comments.) > 0 %then %do;
						%let commentsF = %qsysfunc(dequote(&comments.));
						comments = "&commentsF.",
					%end;
					%else %do;
						comments = "",
					%end;

					%if (&nomDev. ne or &nomDev. ne '') and %length(&nomDev.) > 0 %then %do;
						%let nomDevF = %qsysfunc(dequote(&nomDev.));
						nomDev = "&nomDevF."
					%end;
					%else %do;
						nomDev = ""
					%end;
				;
			quit;

			%if &thisHistoTab. ne histo_Jobs %then %do;
				proc append data=histoJob_TEMP base=&thisHistoTab.; run;
				data &thisHistoTab.; set &thisHistoTab.(where=(stepName)); run;
			%end;
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(historyJobLog);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%makeHistoJobTab();
			%let thisHistoTab = histo_Jobs;
			%let errHandler = 'OK';
			%goto ERR_HANDLER;
		%end;

	%MACRO_END: /** FIN **/
%MEND historyJobLog;
/**
Exemple :
	%historyJobLog(?);
	%historyJobLog();

	libname maLib 'F:\SASDATA\KST\data\';

	*1er traitement - création & initialisation de la table des logs
	%historyJobLog(maLib.maLog_que_je_veux_garder);

		data test1;
			time_slept=sleep(3, 1);

			do key=1 to 30000;
				length data $64.;
				data = put(key, words64.);
				output test1;
			end;
		run;

	%historyJobLog(maLib.maLog_que_je_veux_garder,
		nomDev = "Michel TRUONG",
		stepName = "Test Procédure Truc Muche",
		jobPeriod = A,
		comments = "C'est l'histoire d'une procédure qui s'est perdue en chemin... Les boules! =ţ"
	);


	*2čme traitement - initialisation de la table des logs déjŕ existante
	%historyJobLog(maLib.maLog_que_je_veux_garder);

		data test1;
			time_slept=sleep(23, 1);

			do key=1 to 30000;
				length data $64.;
				data = put(key, words64.);
				output test1;
			end;
		run;

	%historyJobLog(maLib.maLog_que_je_veux_garder,
		nomDev = "Michel TRUONG",
		stepName = "Une autre procédure",
		jobPeriod = M,
		comments = "RAF..."
	);


	*3čme traitement - sans table de log en paramétrage => va donc créer une table dans la work avec un warning
	%historyJobLog();

		data test1;
			time_slept=sleep(3, 1);

			do key=1 to 30000;
				length data $64.;
				data = put(key, words64.);
				output test1;
			end;
		run;

	%historyJobLog(,
		nomDev = "Michel TRUONG",
		stepName = "Test Procédure Truc Muche",
		jobPeriod = A,
		comments = "I need a nap..."
	);
 **/

%MACRO
	checkDiff(tableRef, table2Compare=, keys2Compare=, keepAllCols=NO) / store
	des="Permet de comparer les mouvements entre 2 tables (changement de produits ou garanties dans une table de référence sur 2 périodes différentes par exemple)"
;
	%if &tableRef. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &tableRef. eq
				or &table2Compare. eq
				or &keys2Compare. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';

		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			proc contents data=&tableRef. out=thisTRefContents noprint; run;
			proc contents data=&table2Compare. out=thisT2CContents noprint; run;

			proc sql noprint;
				select count(1) into :tRefNbCols
				from thisTRefContents;

				select count(1) into :t2CNbCols
				from thisT2CContents;
			quit;

			%if &tRefNbCols. ^= &t2CNbCols. %then %do;
				%put ERROR:--[APP]-- Les 2 tables comparées n%str(%')ont pas le męme nombre de colones;
				%goto MACRO_END;
			%end;

			proc sql noprint;
				select name into :tRefCols separated by ' '
				from thisTRefContents
				order by name;

				select name into :t2CCols separated by ' '
				from thisT2CContents
				order by name;
			quit;

			%do i=1 %to &tRefNbCols.;
				%let myRefCol = %scan(&tRefCols., &i.);
				%let my2CCol = %scan(&t2CCols., &i.);

				%if &myRefCol. ne &my2CCol. %then %do;
					%put ERROR:--[APP]-- Les noms des colones ne correspondent pas (colone "&myRefCol." vs colone "&my2CCol.");
					%goto MACRO_END;
				%end;
			%end;

			proc sort data=&tableRef.
					  out=tableRef;
				by &keys2Compare.;
			run;

			proc sort data=&table2Compare.
					  out=table2Compare;
				by &keys2Compare.;
			run;

			%let thisCols2Keep = &keys2Compare.;
			%if %upcase(&keepAllCols.) eq YES %then %do;
				data _null_;
				  length tmp $2000;
				  tmp = cat('"', tranwrd("&keys2Compare."," ",'" "'), '"');
				  call symput('whereException', tmp);
				run;

				proc sql noprint;
					select name, count(1)
						   into :t2CCols2Rename separated by ' ', :total2CCols2Rename
					from thisT2CContents
					where name not in (&whereException.)
					order by name;
				quit;

				%do i=1 %to &total2CCols2Rename.;
					%let my2CCol = %scan(&t2CCols2Rename., &i.);

					%let thisCols2Keep = &thisCols2Keep. &my2CCol. &my2CCol._2Compare;
				%end;
			%end;

			data checkDiff(keep=&thisCols2Keep. presence);
				/*retain &keys2Compare. &thisCols2Keep. presence;*/

				merge tableRef(in=a)
					  table2Compare(in=b
					  				%if %upcase(&keepAllCols.) eq YES %then %do;
						  				rename=(
											%do i=1 %to &total2CCols2Rename.;
												%let my2CCol = %scan(&t2CCols2Rename., &i.);
												&my2CCol = &my2CCol._2Compare
											%end;
											)
									%end;
									);
				attrib presence format=$32.LENGTH=$32;

				by &keys2Compare.;

				if a and b then do;
					presence = 'table référence & nouvelle table';
				end;
				if a and not b then do;
					presence = 'table référence seule';
				end;
				if not a and b then do;
					presence = 'nouvelle table seule'; /* ATTENTION POTENTIELLE ERREUR... */
				end;
			run;

			proc sql;
				select count(1) as NB, presence
				from checkDiff
				group by presence
				;
			quit;

			proc sql noprint;
				select sum(count(1), 0) into: nbDiff
				from checkDiff
				where presence = 'nouvelle table seule'
				;

				select sum(count(1), 0) into: nbDiffOld
				from checkDiff
				where presence = 'table référence seule'
				;
			quit;

			%if &nbDiff. %then %do;
				%put ERROR:--[APP]-- ATTENTION, il y a &nbDiff. différence(s) dans la nouvelle version;
			%end;
			%else %do;
				%if &nbDiffOld. %then %do;
					%put WARNING:--[APP]-- ATTENTION, il y a &nbDiffOld. produit(s)/garantie(s) qui a(ont) disparu(s) depuis la précédente version;
				%end;
				%else %do;
					%put NOTE:--[APP]-- il n%str(%')y a pas de différence;
				%end;
			%end;
			%put NOTE:--[APP]-- pour plus d%str(%')informations, consulter la table [checkDiff], [tableRef] et/ou [table2Compare];
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(checkDiff);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%checkDiff()) avec un argument ŕ blanc, veuillez consulter l%str(%')aide ci-dessous pour plus de précision;

			%help(checkDiff);
		%end;

	%MACRO_END: /** FIN **/
%MEND checkDiff;
/**
Exemple :
	%checkDiff(?);

	%checkDiff(
		tableRef = maLib.maLog_que_je_veux_garder,
		table2Compare = histojob_temp,
		keys2Compare = stepName nomDev,
		keepAllCols = YES
	);

	%checkDiff(
		tableRef = maLib.maLog_que_je_veux_garder,
		table2Compare = histojob_temp,
		keys2Compare = stepName nomDev
	);

	data FORMATS_CDR_SAMPLE;
		set FORMATS.FORMATS_CDR(obs=89);
	run;
	%checkDiff(
		tableRef = FORMATS.FORMATS_CDR,
		table2Compare = FORMATS_CDR_SAMPLE,
		keys2Compare = CPOSTB CODE_DEPT CODE_DEPT_BIS DEPARTEMENT,
		keepAllCols = YES
	);
 **/

%MACRO
	importFlatFile(importParam) / store
	des="Permet d'importer des fichiers plats en donnant un fichier de paramétrage"
;
	%if &importParam. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &importParam. eq or &importParam. eq "" %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';

		%let thisImportParam = %qsysfunc(dequote(&importParam.));
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%if %isFile(&thisImportParam.) eq 0 %then %do;
				%put ERROR:--[APP]-- le fichier de description pour l%str(%')import, transmis en argument n%str(%')existe pas, veuillez vérifier son orthographe/chemin;
				%goto MACRO_END;
			%end;

			%let importKeyWords = fileName|outDataName|fileEncoding|fileDelim|fileTermSTR|removeHeader|autoLoad|genSASFolder;

			data thisImportTMP(where=(isBlank = 'NO'));
				infile "&thisImportParam."
				ENCODING="UTF-8" lrecl=2048 firstobs=1 DSD DLM='09'x;

				informat thisParam $2048.;

				input 
					thisParam $
				;

				linum + 1;

				reg = prxparse("/^\s*$/i");
				pos = prxmatch(reg, trim(thisParam));
				isBlank = ifc(pos>0, 'YES', 'NO');

				reg = prxparse("/^#/i");
				pos = prxmatch(reg, trim(thisParam));
				isCommented = ifc(pos>0, 'YES', 'NO');

				reg = prxparse("/^(&importKeyWords.)/i");
				pos = prxmatch(reg, trim(thisParam));
				isHeader = ifc(pos>0, 'YES', 'NO');
			run;

			data thisImportHeadCheck;
				set thisImportTMP(where=(isCommented eq 'NO' and isHeader eq 'YES'));
				/* https://support.sas.com/rnd/base/datastep/perl_regexp/regexp-tip-sheet.pdf */
				reg = prxparse("/^(&importKeyWords.)=((';')|('[0-9a-fA-F]{2,2}'x)|([a-zA-Z_.\-0-9']+))$/i");
				pos = prxmatch(reg, trim(thisParam));
				isValid = ifc(pos>0, 'YES', 'NO');

				impParam = prxchange("s/(&importKeyWords.)(=)([a-zA-Z0-9_.\-';]*)/\L$1/i", -1, trim(thisParam));
				impParamValue = prxchange("s/(&importKeyWords.)(=)([a-zA-Z0-9_.\-';]*)/\3/i", -1, trim(thisParam));
			run;

			proc sql noprint;
				select count(1), thisParam, linum into :isImportErr, :lineImportErr trimmed, :lineNum trimmed
				from thisImportHeadCheck
				where isValid = 'NO';
			quit;

			%if &isImportErr. %then %do;
				%put ERROR:--[APP]-- le fichier de paramétrage contient des mots clés inconnus;
				%put ERROR:--[APP]-- fichier de paramétrage : &thisImportParam.;
				%put ERROR:--[APP]-- instruction inconnue ou en erreur : &lineImportErr. (ligne:&lineNum.);
				%put;
				%help(importFlatFile);
				%goto MACRO_END;
			%end;

			data _null_;
				set thisImportHeadCheck;

				if impParam eq 'filedelim'
				   or impParam eq 'fileencoding' then do;
					call symput(impParam, impParamValue);
				end;
				else do;
					if impParam eq 'outdataname' then do;
						call symput(impParam, compress(dequote(impParamValue)));
					end;
					else do;
						call symput(impParam, dequote(impParamValue));
					end;
				end;
			run;

			%let accentedChar=ŕčěňůŔČĚŇŮáéíóúýÁÉÍÓÚÝâęîôűÂĘÎÔŰăńőĂŃŐäëďöü˙ÄËĎÖÜźçÇßŘřĹĺĆćś;
			data thisImportBodyCheck;
				set thisImportTMP(where=(isCommented eq 'NO' and isHeader eq 'NO'));

				reg = prxparse("/^([a-zA-Z0-9_]*);([a-zA-Z0-9\s&accentedChar.]*);((\${0,1}\s{0,})([0-9]+)|(\s{0,})([0-9]+)(\.??)([0-9]+))$/i");
				pos = prxmatch(reg, trim(thisParam));
				isValid = ifc(pos>0, "YES", "NO");

				colName = prxchange("s/([a-zA-Z0-9_]*)(;)([a-zA-Z0-9\s&accentedChar.]*)(;)(\${0,1})(\s{0,})([0-9]+)(((\.??)([0-9]+))*)/\1/i", -1, trim(thisParam));
				colLabel = prxchange("s/([a-zA-Z0-9_]*)(;)([a-zA-Z0-9\s&accentedChar.]*)(;)(\${0,1})(\s{0,})([0-9]+)(((\.??)([0-9]+))*)/\3/i", -1, trim(thisParam));
				colFormat = prxchange("s/([a-zA-Z0-9_]*)(;)([a-zA-Z0-9\s&accentedChar.]*)(;)(\${0,1})(\s{0,})([0-9]+)(((\.??)([0-9]+))*)/\5/i", -1, trim(thisParam));
				colLenght = prxchange("s/([a-zA-Z0-9_]*)(;)([a-zA-Z0-9\s&accentedChar.]*)(;)(\${0,1})(\s{0,})([0-9]+)(((\.??)([0-9]+))*)/\7\8/i", -1, trim(thisParam));

				hasComma = index(colLenght, '.');
			run;

			proc sql noprint;
				select count(1), thisParam, linum into :isImportErr, :lineImportErr trimmed, :lineNum trimmed
				from thisImportBodyCheck
				where isValid = 'NO';
			quit;

			%if &isImportErr. %then %do;
				%put ERROR:--[APP]-- le fichier de paramétrage contient de(s) description(s) en erreur;
				%put ERROR:--[APP]-- fichier de paramétrage : &thisImportParam.;
				%put ERROR:--[APP]-- description en erreur : &lineImportErr. (ligne:&lineNum.);
				%put;
				%help(importFlatFile);
				%goto MACRO_END;
			%end;

			%let thisImportParamTMP = %qsysfunc(dequote(&thisImportParam.));
			%let isUnix = %isUnixPath(&thisImportParamTMP.);

			%let slashC = \;
			%if &isUnix. eq 1 %then %do;
				%let slashC = /;
			%end;

			%let fileImportParamName = %qsysfunc(scan("&thisImportParamTMP.", -1, "&slashC."));
			%let path2Import = %qsysfunc(substr(&thisImportParamTMP., 1, %sysfunc(find(&thisImportParamTMP., &fileImportParamName.))-2));
			%let fileName2Save = %qsysfunc(scan("&thisImportParamTMP.", -1, "&slashC."));
			%let thisSrcImpFileName = &path2Import.&slashC.&fileName.;

			%if %isFile(&thisSrcImpFileName.) eq 0 %then %do;
				%put ERROR:--[APP]-- le fichier ŕ importer n%str(%')existe pas, veuillez vérifier son orthographe/chemin dans le fichier de paramétrage;
				%goto MACRO_END;
			%end;

			%if not %symexist(genSASFolder) %then %do;
				%let thisGenSASFolder = ;
			%end;
			%else %if %upcase(&genSASFolder.) eq ROOT %then %do;
				%let thisGenSASFolder = ;
			%end;
			%else %do;
				%let thisTMPGenSASFolder = %sysfunc(dequote(&genSASFolder));
				%let thisGenSASFolder = &thisTMPGenSASFolder.&slashC.;
			%end;

			%let thisImpGenSASFileName = &path2Import.&slashC.&thisGenSASFolder.&fileImportParamName..makT.sas;
			%let thisFinalPathFolder2Gen = &path2Import.&slashC.&thisGenSASFolder;
			%let thisDesFile2Import = &thisFinalPathFolder2Gen.&fileImportParamName.;

			%let thisAutoLoad = YES;
			%if %symexist(autoLoad) %then %do;
				%if %upcase(&autoLoad.) eq NO %then %do;
					%let thisAutoLoad = NO;
				%end;
			%end;

			%let thisRemoveHeader = YES;
			%if %symexist(removeHeader) %then %do;
				%if %upcase(&removeHeader.) eq NO %then %do;
					%let thisRemoveHeader = NO;
				%end;
			%end;

			%let thisFileTermSTR = CRLF;
			%if %symexist(fileTermSTR) %then %do;
				%if %upcase(&fileTermSTR.) ne CRLF %then %do;
					%let thisFileTermSTR = &fileTermSTR.;
				%end;
			%end;

			%let thisFileEncoding = 'WLATIN1';
			%if %symexist(fileEncoding) %then %do;
				%if %upcase(&fileEncoding.) ne 'WLATIN1' %then %do;
					%let thisFileEncoding = &fileEncoding.;
				%end;
			%end;

			%isFile(&thisFinalPathFolder2Gen., mkdir=YES, verbose=ON);

			data toGen;
				set thisImportBodyCheck(keep=colName colLabel colFormat colLenght hasComma);

				attrib lineLabel2Gen length=$2048 format=$2048. informat=$2048.;
				attrib lineLength2Gen length=$2048 format=$2048. informat=$2048.;
				attrib lineFormat2Gen length=$2048 format=$2048. informat=$2048.;
				attrib lineInFormat2Gen length=$2048 format=$2048. informat=$2048.;
				attrib lineInput2Gen length=$2048 format=$2048. informat=$2048.;

				lineLabel2Gen = strip(colName) || ' = "' || strip(colLabel) || '"';
				lineLength2Gen = strip(colName) || ' ' || ifc(strip(colFormat) eq "$", "$" || strip(colLenght), "8");
				lineFormat2Gen = strip(colName) || ' '  || ifc(strip(colFormat) eq "$", "$", "BEST") || tranwrd(strip(colLenght), ',', '.') || ifc(strip(colFormat) eq "$", ".", ifc(strip(hasComma) > 0, "", "."));
				lineInFormat2Gen = strip(colName) || ' '  || ifc(strip(colFormat) eq "$", "$", "BEST") || tranwrd(strip(colLenght), ',', '.') || ifc(strip(colFormat) eq "$", ".", ifc(strip(hasComma) > 0, "", "."));

				lineInput2Gen = strip(colName)
									|| ' ' 
									|| ifc(strip(colFormat) eq "$", ": $CHAR", ": ?? BEST") 
									|| tranwrd(strip(colLenght), ',', '.')
									|| ifc(strip(colFormat) eq "$", ".", ifc(strip(hasComma) > 0, "", "."));
			run;

			x DEL /F "&thisImpGenSASFileName.";

			data _null_;
				file "&thisImpGenSASFileName." encoding="UTF-8";

				length line $2048;

				line = "/* Programme Import SAS généré le " || put(%sysfunc(datetime()), datetime19.) || " */";
				put line;
				put "/* Fichier Descriptif d'import : &thisDesFile2Import. */";
				put;
				put "/* --[DEBUT IMPORT]-- */";
				put;
				put "DATA &outDataName.;";
				put;
			run;
			data _null_;
				file "&thisImpGenSASFileName." mod;
				put @3 "LENGTH ";
			run;
			data _null_;
				set toGen;

				file "&thisImpGenSASFileName." mod;
				put @7 lineLength2Gen;
			run;
			data _null_;
				file "&thisImpGenSASFileName." mod;
				put @7 ";";
				put @3 "LABEL ";
			run;
			data _null_;
				set toGen;

				file "&thisImpGenSASFileName." mod;
				put @7 lineLabel2Gen;
			run;
			data _null_;
				file "&thisImpGenSASFileName." mod;
				put @7 ";";
				put @3 "FORMAT ";
			run;
			data _null_;
				set toGen;

				file "&thisImpGenSASFileName." mod;
				put @7 lineFormat2Gen;
			run;
			data _null_;
				file "&thisImpGenSASFileName." mod;
				put @7 ";";
				put @3 "INFORMAT ";
			run;
			data _null_;
				set toGen;

				file "&thisImpGenSASFileName." mod;
				put @7 lineInFormat2Gen;
			run;
			data _null_;
				file "&thisImpGenSASFileName." mod;
				encodingLine = "ENCODING='" || %sysfunc(compress(&thisFileEncoding.)) || "'";
				delimLine = %sysfunc(compress("DLM=&fileDelim."));

				put @7 ";";
				put @3 "INFILE '&thisSrcImpFileName.'";
				put @7 "LRECL=32767";
				put @7 encodingLine;
				put @7 "TERMSTR=&thisFileTermSTR.";
				put @7 delimLine;
				put @7 "MISSOVER";
				put @7 "DSD";

				%if &thisRemoveHeader. eq YES %then %do;
					put @7 "FIRSTOBS=2";
				%end;

				put @7 ";";
				put;
			run;
			data _null_;
				file "&thisImpGenSASFileName." mod;
				put @3 "INPUT ";
			run;
			data _null_;
				set toGen;

				file "&thisImpGenSASFileName." mod;
				put @7 lineInput2Gen;
			run;
			data _null_;
				file "&thisImpGenSASFileName." mod;

				put @7 ";";
				put;
				put "RUN;";
				put;
				put "/* --[FIN IMPORT]-- */";
			run;

			%if &thisAutoLoad. eq YES %then %do;
				%put NOTE:--[APP]-- début import données décrites dans [&thisDesFile2Import.];
				%put;
					%inc "&thisImpGenSASFileName.";
				%put;
				%put NOTE:--[APP]-- fin import données;
			%end;
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(importFlatFile);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%importFlatFile()) avec un argument ŕ blanc, veuillez consulter l%str(%')aide ci-dessous pour plus de précision;

			%help(importFlatFile);
		%end;

	%MACRO_END: /** FIN **/
%MEND importFlatFile;
/**
Exemple :
	%importFlatFile(?);
	%importFlatFile();

	%importFlatFile(F:\SASDATA\KST\Test import\FORMATS_COMMUNES_CSV.sasdesc);
	%importFlatFile('F:\SASDATA\KST\Test import\FORMATS_COMMUNES_TAB.sasdesc');
 **/

%MACRO
	importFromFolder(folder2Import, extension=sasdesc, dirContents2import=DIR_CONTENTS_2_IMPORT, genSAS=importFromFolder.sas, autoLoad=YES) / store
	des="Permet d'importer tous les fichiers de descriptions de la macro %importFlatFile depuis un dossier"
;
	%if &folder2Import. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &folder2Import. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';

		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%if %isFile(&folder2Import.) eq 0 %then %do;
				%put ERROR:--[APP]-- le dossier spécifié en argument n%str(%')existe pas;
				%goto MACRO_END;
			%end;

			%let thisImportParamTMP = %qsysfunc(dequote(&folder2Import.));
			%let isUnix = %isUnixPath(&thisImportParamTMP.);

			%let slashC = \;
			%if &isUnix. eq 1 %then %do;
				%let slashC = /;
			%end;

			data &dirContents2import.(keep=fileSeq baseFile pathFullName impFlatFile);
				length baseFile $ 128 pathFullName $ 1024 impFlatFile $ 2048;
				/* allocate directory */
				rc = FILENAME('xdir', "&thisImportParamTMP.");

				if rc ne 0 then do;
					%put ERROR:--[APP]-- impossible de rattacher un fileref au dossier spécifié;
					go to END_DATASTEP;
				end;

				/* Open directory */
				dirid = DOPEN('xdir');
				if dirid eq 0 then do;
					%put ERROR:--[APP]-- impossible d%str(%'ouvrir) le répertoire spécifié;
					go to END_DATASTEP;
				end;

				/* get number of information items */
				nfiles = DNUM(dirid);
				do j = 1 to nfiles;
					baseFile = dread(dirid, j);
					pathFullName = strip(strip("&thisImportParamTMP.") || "&slashC." || strip(baseFile));

					%if %length(&extension.) or &extension. ne %then %do;
						ext = scan(baseFile, -1, '.');
						if ext = "&extension." then do;
							fileSeq + 1;

							impFlatFile = strip("importFlatFile('" || strip(pathFullName) || "');");
							/*call execute("%" || impFlatFile);*/
							output;
						end;
					%end;
					%else %do;
						fileSeq + 1;
						output;
					%end;
				end;

				rc = DCLOSE(dirid);

				/* deallocate the directory */
				rc = FILENAME('xdir');

				END_DATASTEP:
			run;

			%let thisImpGenSASFileName = &thisImportParamTMP.&slashC.&genSAS.;
			x DEL /F "&thisImpGenSASFileName.";

			data _null_;
				file "&thisImpGenSASFileName." encoding="UTF-8";

				length line $2048;

				line = "/* Programme SAS Import Répertoire généré le " || put(%sysfunc(datetime()), datetime19.) || " */";
				put line;
				put;
				put "/* --[DEBUT IMPORT]-- */";
				put;
			run;

			data _null_;
				set &dirContents2import.;
				file "&thisImpGenSASFileName." mod;

				line = '%'||strip(impFlatFile);
				put @7 line;
			run;

			data _null_;
				file "&thisImpGenSASFileName." mod;
				put;
				put "/* --[FIN IMPORT]-- */";
			run;
			
			%if %upcase(&autoLoad.) eq YES %then %do;
				%inc "&thisImpGenSASFileName.";
			%end;
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(importFromFolder);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%importFromFolder()) avec un argument ŕ blanc, veuillez consulter l%str(%')aide ci-dessous pour plus de précision;

			%help(importFromFolder);
		%end;

	%MACRO_END: /** FIN **/
%MEND importFromFolder;
/**
Exemple :
	%importFromFolder(?);
	%importFromFolder();

	%importFromFolder(
		folder2Import = 'F:\SASDATA\KST\Test import',
		autoLoad = NO);
 **/

%MACRO
	genDictionary(folder2Excel) / store
	des="Permet de générer un fichier dictionnaire de données Excel"
;
	%let excelDictFileName = DICTIONNAIRE_SAS.xlsx;

	%if &folder2Excel. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &folder2Excel. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';

		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%if %isFile(&folder2Excel.) eq 0 %then %do;
				%put ERROR:--[APP]-- le dossier spécifié en argument n%str(%')existe pas;
				%goto MACRO_END;
			%end;

			%let thisImportParamTMP = %qsysfunc(dequote(&folder2Excel.));
			%let isUnix = %isUnixPath(&thisImportParamTMP.);

			%let slashC = \;
			%if &isUnix. eq 1 %then %do;
				%let slashC = /;
			%end;

			%let thisExcelDictFileName = &thisImportParamTMP.&slashC.&excelDictFileName.;
			x DEL /F "&thisExcelDictFileName.";

			proc sql noprint;
				create table dict_tab as
					select LIBNAME as NOM_LIBRAIRIE, MEMNAME as NOM_TABLE, NOBS as NB_LIGNES, NVAR as NB_COLONNES
					from dictionary.tables
					where upcase(libname) not in ('SASHELP', 'MAPS', 'MAPSSAS', 'MAPSGFK', 'WORK')
					/* and upcase(memtype)='DATA'*/
					order by calculated NOM_LIBRAIRIE, calculated NOM_TABLE
				;
			quit;

			proc sql noprint;
				create table dict_col as
					select LIBNAME as NOM_LIBRAIRIE, MEMNAME as NOM_TABLE,
						   NAME as NOM_COLONNE, TYPE, LENGTH as LONGUEUR, LABEL, FORMAT, INFORMAT, VARNUM as ORDRE_COLONNE
					from dictionary.columns
					where upcase(libname) not in ('SASHELP', 'MAPS', 'MAPSSAS', 'MAPSGFK', 'WORK')
					/* and upcase(memname)='CLASS'*/
					order by calculated NOM_LIBRAIRIE, calculated NOM_TABLE, calculated ORDRE_COLONNE
				;
			quit;

			proc sql noprint;
				create table dict_dup_col as
					select a.*
					from DICT_COL as a
					inner join (
						select count(1) as NB, NOM_COLONNE, NOM_TABLE
						from DICT_COL
						group by NOM_COLONNE, NOM_TABLE
						having calculated NB > 1
					) as b
						on a.NOM_COLONNE = b.NOM_COLONNE
							and a.NOM_TABLE = b.NOM_TABLE
					order by NOM_COLONNE, NOM_TABLE, NOM_LIBRAIRIE
				;
			quit;

			ods excel file = "&thisExcelDictFileName."
				options(sheet_name = 'TABLES' autofilter = 'all'  frozen_headers="1");
				proc print data = dict_tab; run;

				ods excel options(sheet_name = 'COLONNES' autofilter = 'all'  frozen_headers="1");
				proc print data = dict_col;
				run;

				ods excel options(sheet_name = 'COLONNES_X_TABLES' autofilter = 'all'  frozen_headers="1");
				proc print data = dict_dup_col;
				run;
			ods excel close;
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(genDictionary);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%genDictionary()) avec un argument ŕ blanc, veuillez consulter l%str(%')aide ci-dessous pour plus de précision;

			%help(genDictionary);
		%end;

	%MACRO_END: /** FIN **/
%MEND genDictionary;
/**
Exemple :
	%genDictionary(?);
	%genDictionary();

	%genDictionary('F:\SASDATA\KST');
 **/

%MACRO
	dde2Out(ddeOut, data2Out, ddeTemplate) / store
	des="Permet de remplir un fichier Excel en mode dde avec macro VBA interne de présentation (ŕ faire selon besoin)"
;
	%if &ddeOut. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &ddeOut. eq or &data2Out. eq or &ddeTemplate. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';

		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;

			%if %isFile(&ddeTemplate.) eq 0 %then %do;
				%put ERROR:--[APP]-- le template DDE en argument n%str(%')existe pas, merci de vérifier son chemin;
				%goto MACRO_END;
			%end;

			%let thisPath2CheckTMP = %qsysfunc(dequote(&ddeTemplate.));
			%let isUnix = %isUnixPath(&thisPath2CheckTMP.);

			%let slashC = \;
			%if &isUnix. eq 1 %then %do;
				%let slashC = /;
			%end;

			%let thisDDEOut = %qsysfunc(scan("&ddeOut.", -1, "&slashC."));
			%let thisPath2DDEOut = %qsysfunc(substr(&ddeOut., 1, %sysfunc(find(&ddeOut., &thisDDEOut.))-2));

			%if %isFile(&thisPath2DDEOut.) eq 0 %then %do;
				%put ERROR:--[APP]-- le répertoire de sortie du fichier DDE ŕ générer en argument n%str(%')existe pas, merci de vérifier son chemin;
				%goto MACRO_END;
			%end;

			%let thisFinalFileName = &thisPath2DDEOut.&slashC.&thisDDEOut.;
			x DEL /F "&thisFinalFileName.";
			x COPY "&ddeTemplate." "&thisFinalFileName." /Y;

			libname xlsDDE PCFILES path = "&thisFinalFileName." /*server=<Server> port=<port> user= pass=*/;

/*			proc datasets lib=xlsDDE nolist;*/
/*				delete RAW_DATA;*/
/*			quit;*/

			data xlsDDE.RAW_DATA;
				set &data2Out.;
			run;

			libname xlsDDE clear;
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(dde2Out);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%dde2Out()) avec un argument ŕ blanc, veuillez consulter l%str(%')aide ci-dessous pour plus de précision;

			%help(dde2Out);
		%end;

	%MACRO_END: /** FIN **/
%MEND dde2Out;
/**
Exemple :
	%dde2Out(?);
	%dde2Out();

	%dde2Out(
		ddeOut = F:\SASDATA\KST\export_DDE_%getTimeStamp().xlsm,
		data2Out = sashelp.cars,
		ddeTemplate = F:\SASDATA\KST\template_DDE.xlsm
	);
 **/

%MACRO
	setDigitalSignature(myFile) / store
	des="Permet de construire la signature électronique d'un fichier plat (programme SAS, log etc...)"
;
	%if &myFile. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &myFile. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%global fileHash256 fileHashMD5;

			%if %isFile(&myFile.) eq 0 %then %do;
				%put ERROR:--[APP]-- le fichier transmis en argument pour construire sa signature électronique n%str(%')existe pas, veuillez vérifier son orthographe/chemin;
				%goto MACRO_END;
			%end;

			%let file2Hash = %qsysfunc(dequote(&myFile.));
			%let isUnix = %isUnixPath(&file2Hash.);

			%let slashC = \;
			%if &isUnix. eq 1 %then %do;
				%let slashC = /;
			%end;

			data hashFileTMP;
				infile "&file2Hash." lrecl=2048 pad END=eof;
		 
				INPUT @1 getline $2048.;
				
				intext = compress(trim(substr(upcase(getline), 1, 2047)));
				linum + 1;
				lntext = length(intext);

				if lntext <= 7 then do;
					intext2 = intext;
				end;
				else do;
					if lntext > 7 and lntext <= 13 then do;
						if mod(linum, 2) then
							intext2 = substr(intext, 1, 5);
						else
							intext2 = substr(intext, length(intext) - 5, length(intext));
					end;
					else do;
						if mod(linum, 2) then
							intext2 = substr(intext, 1, 7);
						else
							intext2 = substr(intext, length(intext) - 7, length(intext));
					end;
				end;

				drop getline eof;
			run;

			data hashSignature(keep=text);
				set hashFileTMP end=eof;

				length text $32767;
				retain text '';

				text = cats(text, intext2);
				if eof then output;
			run;

			proc sql;
				select 
					put(sha256(text), $hex64.), put(md5(text), $hex32.)
					into
						:fileHash256, :fileHashMD5
				from hashSignature;
			quit;

/*			proc datasets library=WORK memtype=data nolist nodetails;*/
/*				delete hashFileTMP hashSignature;*/
/*			quit;*/
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(setDigitalSignature);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%setDigitalSignature()) sans argument;

			%help(setDigitalSignature);
		%end;

	%MACRO_END: /** FIN **/
%MEND setDigitalSignature;
/**
Exemple :
	%setDigitalSignature(?);
	%setDigitalSignature();

	%setDigitalSignature('F:\SASDATA\KST\00_LIB_Macros_Communes_ORIGINAL.sas');
	%setDigitalSignature('F:\SASDATA\KST\00_LIB_Macros_Communes_TEST.sas');
 **/

%MACRO
	getDigitalSignature(hashSignatureType=SHA256) / store
	des="Permet de récupérer la signature électronique d'un fichier plat (programme SAS, log etc...)"
;
		%if %symexist(fileHash256) and %symexist(fileHashMD5) %then %do;
			%if %upcase(&hashSignatureType.) eq SHA256 %then %do;
				%let signature = &fileHash256.;
			%end;
			%else %do;
				%let signature = &fileHashMD5.;
			%end;

/*			proc datasets library=WORK memtype=data nolist nodetails;*/
/*				delete hashFileTMP hashSignature;*/
/*			quit;*/

			%sysfunc(compress(&signature.))
		%end;
		%else %do;
			%put ERROR:--[APP]-- Merci de lancer la macro %setDigitalSignature() avant...;
		%end;

	%MACRO_END: /** FIN **/
%MEND getDigitalSignature;
/**
Exemple :
	%setDigitalSignature(
		'\\Chemin abolu\Reseau\ou\non\Librairie_SAS\00_LIB_Macros_Communes.sas'
	);
	%let dSigSHA = %getDigitalSignature();
	%debugVar(dSigSHA);

	%setDigitalSignature('F:\SASDATA\KST\00_LIB_Macros_Communes_ORIGINAL.sas');
	%let dSigSHA = %getDigitalSignature();
	%debugVar(dSigSHA);

	%setDigitalSignature('F:\SASDATA\KST\00_LIB_Macros_Communes_TEST.sas');
	%let dSigSHA = %getDigitalSignature();
	%debugVar(dSigSHA);
 **/

%MACRO
	cleanFileB4Import(file2Clean, type2Clean=ALL, fileType=RISE, cleanTag=_CLEAN_, newFileName2Save=) / store
	des="Permet de nettoyer un fichier plat avant son import"
;
	%if &file2Clean. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &file2Clean. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%if %isFile(&file2Clean.) eq 0 %then %do;
				%put ERROR:--[APP]-- le fichier transmis en argument n%str(%')existe pas, veuillez vérifier son orthographe/chemin;
				%goto MACRO_END;
			%end;

			%let thisCleanTag = _CLEAN_;
			%if %upcase(&cleanTag.) ne _CLEAN_ %then %do;
				%let thisCleanTag = %qsysfunc(dequote(&cleanTag.));
			%end;

			%let thisFile2Clean = %qsysfunc(dequote(&file2Clean.));
			%let isUnix = %isUnixPath(&thisFile2Clean.);

			%let slashC = \;
			%if &isUnix. eq 1 %then %do;
				%let slashC = /;
			%end;

			%let fileName2Save = %qsysfunc(scan("&thisFile2Clean.", -1, "&slashC."));
			%let fileName2SaveNoExt = %qsysfunc(scan("&fileName2Save.", 1, "."));
			%let fileName2SaveExt = %qsysfunc(scan("&thisFile2Clean.", -1, "."));
			%let path2Save = %qsysfunc(substr(&thisFile2Clean., 1, %sysfunc(find(&thisFile2Clean., &fileName2Save.))-2));

			%let thisFinaleFile2Save = &path2Save.\&fileName2SaveNoExt.&thisCleanTag..&fileName2SaveExt.;
			%if &newFileName2Save. ne %then %do;
				%let _tmpFileName2Save = %qsysfunc(dequote(&newFileName2Save.));
				%let thisFinaleFile2Save = &path2Save.\&_tmpFileName2Save..&fileName2SaveExt.;
			%end;

			%let thisType2Clean = %qsysfunc(dequote(&type2Clean.));

			%let thisChar2Replace = \x0A|\x0D|\x09;
			%if %upcase(&type2Clean.) ne ALL %then %do;
				%let thisChar2Replace = &thisType2Clean.;
			%end;

			x DEL /F "&thisFinaleFile2Save.";

			data _null_;
				length _outfile_ $32767;

				file "&thisFinaleFile2Save." encoding="WLATIN1" lrecl=32767;
				infile "&thisFile2Clean." firstobs=1 lrecl=32767 dsd truncover ignoredoseof;
				input @;

				%if %upcase(&fileType.) eq RISE %then %do;
					_infile_ = prxchange("s/\xA0|\x0A|\x0D|\x09/ /i", -1, trim(_infile_));
					_outfile_ = prxchange("s/\s{1,}-\s{2,}/0/i", -1, trim(_infile_));
				%end;
				%else %do;
					_outfile_ = prxchange("s/&thisChar2Replace./ /i", -1, trim(_infile_));
				%end;

				put _outfile_;
			run;

			%put NOTE:--[APP]-- Le fichier a été correctement nettoyé et enregistré ici [&thisFinaleFile2Save.];
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%help(cleanFileB4Import);
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%cleanFileB4Import()) sans argument ou avec un argument vide, veuillez consulter l%str(%')aide ci-dessous;

			%help(cleanFileB4Import);
		%end;

	%MACRO_END: /** FIN **/
%MEND cleanFileB4Import;
/**
Exemple :
	%cleanFileB4Import(?);
	%cleanFileB4Import();

	%cleanFileB4Import(
		file2Clean = F:\SASDATA\KST\Test import\Referentiel_DZ.csv
	);

	%cleanFileB4Import(
		file2Clean = F:\SASDATA\KST\Test import\Referentiel_DZ.csv,
		type2Clean = "\xA0|\x0A|\x0D|\x09|\s{1,}-\s{2,}",
		cleanTag = _NETTOYÉ_
	);

	%cleanFileB4Import(
		file2Clean = F:\SASDATA\KST\Test import\Referentiel_DZ.csv,
		fileType = RISE,
		cleanTag = _NETTOYÉ_
	);

	%cleanFileB4Import(
		file2Clean = F:\SASDATA\KST\Test import\Referentiel_DZ.csv,
		fileType = RISE,
		cleanTag = _NETTOYÉ_,
		newFileName2Save = "Hello you"
	);
 **/
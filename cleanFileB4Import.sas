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
%MEND setSTLib; %setSTLib();
options noquotelenmax mstored sasmstore=stmALL;

%MACRO helpCleanFileB4Import();
	%put ERROR:--[HELP]--   • NOM MACRO :;
	%put ERROR:--[HELP]--      %nrstr(%cleanFileB4Import());
	%put WARNING:--[HELP]-- • DESCRIPTION :;
	%put NOTE:--[HELP]--       Permet de nettoyer un fichier plat avant son import;
	%put WARNING:--[HELP]-- • SYNTAXE :;
	%put NOTE:--[HELP]--       %nrstr(%cleanFileB4Import(&file2Clean. <, regex=DEFAULT <, fileType=CLADAG <, cleanTag=_CLEANED_ <, newFileName2Save=>>>>));
	%put WARNING:--[HELP]-- • ARGUMENT(S) :;
	%put NOTE:--[HELP]--       > file2Clean : chemin absolu du fichier plat à nettoyer;
	%put NOTE:--[HELP]--       > regex (facultatif) : le type de correction (en expression régulière) - valeur par défaut : DEFAULT;
	%put NOTE:--[HELP]--       >                      nettoie les caractères orphelins \x0A|\x0D (représentant le LF, CR);
	%put NOTE:--[HELP]--       > fileType (facultatif) : le type du fichier modèle à corriger - valeur par défaut : CLADAG;
	%put NOTE:--[HELP]--       >                         le fichier CLADAG, tout comme le fichier RISE a les mêmes problèmes à savoir;
	%put NOTE:--[HELP]--       >                           •> existence des \xA0, espace insécable;
	%put NOTE:--[HELP]--       >                           •> existence des caractères orphelins \x0A|\x0D représentant le LF et CR;
	%put NOTE:--[HELP]--       >                           •> existence des \x09, tabulation;
	%put NOTE:--[HELP]--       >                           •> existence des \s{2,}, espaces à répétition;
	%put NOTE:--[HELP]--       >                              •>> qui seront remplacés par un simple espace;
	%put NOTE:--[HELP]--       >                           •> existence des \s{1,}-\s{1,}, champ contenant que le signe - entouré d%str(%')un certain nombres d%str(%')espaces;
	%put NOTE:--[HELP]--       >                              •>> qui seront remplacés par la valeur 0;
	%put NOTE:--[HELP]--       > cleanTag (facultatif) : le tag par défaut, pour discriminer le nom du fichier nettoyé;
	%put NOTE:--[HELP]--       > newFileName2Save (facultatif) : le nom du fichier nettoyé de sorti si existe;
	%put WARNING:--[HELP]-- • RETOUR(S) :;
	%put NOTE:--[HELP]--       > produit un fichier plat nettoyé, avec le suffixe _CLEANED_ par défaut;
	%put WARNING:--[HELP]-- • EXEMPLE(S) :;
	%put NOTE:--[HELP]--       > %nrstr(%cleanFileB4Import(?);) *pour afficher l%str(%')aide;
	%put NOTE:--[HELP]--       > %nrstr();
	%put NOTE:--[HELP]--       > *---nettoyage simple sans argument précis (CLADAG)---*;
	%put NOTE:--[HELP]--       > %nrstr(%let monFichierANettoyer = F:\SASDATA\DEEP\LABO\PERSONNEL\M47624\Test import\Fichier à nettoyer.csv;);
	%put NOTE:--[HELP]--       > %nrstr(%cleanFileB4Import(file2Clean = &monFichierANettoyer.););
%MEND helpCleanFileB4Import;

%MACRO
	cleanFileB4Import(file2Clean, regex=DEFAULT, fileType=CLADAG, cleanTag=_CLEANED_, newFileName2Save=) /
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

			%let thisFinalFile2Save = &path2Save.\&fileName2SaveNoExt.&thisCleanTag..&fileName2SaveExt.;
			%if &newFileName2Save. ne %then %do;
				%let _tmpFileName2Save = %qsysfunc(dequote(&newFileName2Save.));
				%let thisFinalFile2Save = &path2Save.\&_tmpFileName2Save..&fileName2SaveExt.;
			%end;

			%let thisRegex = %qsysfunc(dequote(&regex.));

			%let thisRegex2Replace = \x0A|\x0D;
			%if %upcase(&regex.) ne DEFAULT %then %do;
				%let thisRegex2Replace = &thisRegex.;
			%end;

			x DEL /F "&thisFinalFile2Save.";

			data _null_;
				length _outfile_ $32767.;

				file "&thisFinalFile2Save." encoding="WLATIN1" lrecl=32767;
				infile "&thisFile2Clean." lrecl=32767 pad END=eof;

				INPUT @1 _getline $32767.;

				%if %upcase(&fileType.) eq CLADAG and %upcase(&regex.) eq DEFAULT %then %do;
					_infile_ = prxchange("s/\xA0|\x0A|\x0D|\x09|\s{2,}/ /", -1, trim(_getline));
					_outfile_ = prxchange("s/\s{1,}-\s{1,}/0/", -1, trim(_infile_));
				%end;
				%else %do;
					_outfile_ = prxchange("s/&thisRegex2Replace./ /", -1, trim(_getline));
				%end;

				put _outfile_;
			run;

			%put NOTE:--[APP]-- Le fichier a été correctement nettoyé et enregistré ici [&thisFinalFile2Save.];
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%helpCleanFileB4Import();
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- vous avez apppelé la macro %nrstr(%cleanFileB4Import()) sans argument ou avec un argument vide, veuillez consulter l%str(%')aide ci-dessous;

			%helpCleanFileB4Import();
		%end;

	%MACRO_END: /** FIN **/
%MEND cleanFileB4Import;
/**
Exemple :
	%cleanFileB4Import(?);
	%cleanFileB4Import();

	%let root = G:\ARCHIVAGE\DEEP\TEST;
	%let file_name = CLADAG_T201804_20191022 init.csv;
	%let file_2_clean = &root.\&file_name.;

	%cleanFileB4Import(
		file2Clean = &file_2_clean.
	);

	%cleanFileB4Import(
		file2Clean = &file_2_clean.,
		regex = "\s{0,}ND\s{0,}",
		cleanTag = _SANS_ND_
	);

	%cleanFileB4Import(
		file2Clean = &file_2_clean.,
		newFileName2Save = "my new file"
	);
 **/
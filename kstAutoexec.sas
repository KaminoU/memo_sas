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
/**
 * Si l'exécution automatique est souhaité de l'Autoexec :
 *    Outils > Options > [Général] • Exécuter automatiquement un flux de processus "Autoexec" lorsque le projet s'ouvre
 **/
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

	/** IMPORT FICHIER DES PARAMETRAGES **/
	%setDynVar(
		"&sasLibRoot.\_000_FICHIER_PARAMETRAGE_DTM.csv",
		displayVar=YES,
		backUP=NO
	);

	/**
		[OBLIGATOIRE] permet de monter les librairies de travail vers le bon environnement, DEV et/ou QUAL

		DECLARATION LIBRAIRIES :
		• les bibliothèques préfixées par D_* pointent sur l'environnement de DEV
		• les bibliothèques préfixées par Q_* pointent sur l'environnement de QUALIF
	 **/ %mountLibraries();

	 /**
		[OBLIGATOIRE] permet de mapper les noms court/long des librairies SAS via des macros globales

	 	MAPPING librairies...
		La longueur maximale d'un libref SAS est de 8 caractères.

		Le nouveau mapping est défini dans le fichier de paramétrage _001_LIBRARIES_MAPPING.csv :
		• Environnement de DEV => libDev <=> libProd
		• Environnement de QUALIF => libQual <=> libProd
	 **/ %librariesMapping();
%MEND _init;
%_init();

%MACRO
	control(displayMapping=YES, autoMappingIfNotExisted=YES) /
	des="Permet d'afficher le chemin absolu du mapping dynamique"
;
	%let map_table_name = LIBRARIES_MAPPING;

	%if %symexist(ENV) %then %do;
		%if %isTable(&map_table_name.) ne 1 %then %do;
			%if %ucpase(&autoMappingIfNotExisted.) eq YES %then %do;
				%_init();
				%mountLibraries();
				%librariesMapping();

				%goto _CONTROLLER;
			%end;

			%put2Log(" [Environnement : %getEnv()]::Aucune définition trouvée, merci de monter les librairies logiques avec le mapping avant ");
			%goto _END;
		%end;

		%goto _CONTROLLER;
	%end;

	%_CONTROLLER:
		proc sql;
			create table _ctrl as
				select _t.*, _d.path
				from (
					select *, symget(nomVar) as map_def
					from &map_table_name.
				) as _t left join (
					select libname, path
					from DICTIONARY.LIBNAMES
					where libname like 'D_%' and path like 'G:\%'
				) as _d
					on _t.map_def = _d.libname
			;
		quit;

		%if %upcase(&displayMapping.) eq YES %then %do;
			%put2Log(" [Environnement : %getEnv()]:: ", tag=INFO, typeLog=WARNING);
			%put2Log(" Rappel : depuis votre poste, l'accès au G doit se faire sans le bloc [ARCHIVAGE\KST] ", tag=INFO, typeLog=WARNING);
			%put2Log("          par exemple, G:\ARCHIVAGE\KST\_ENV_\_DEV_\DTM_LAB deviendra G:\_ENV_\_DEV_\DTM_LAB ", tag=INFO, typeLog=WARNING);
			data _null_;
				set _ctrl;

				call execute('%put2Log(" • La macro variable nommée %nrstr(&' || compress(nomVar) || '.) = ' || compress(map_def) || ' ", tag=INFO, typeLog=NOTE);');
				call execute('%put2Log(" • La librairie logique nommée ' || compress(map_def) || ' pointe sur ' || compbl(path) || ' ", tag=INFO, typeLog=NOTE);');
				call execute('%put;');
			run;
		%end;

	%_END:  /** o( ^  ^ )o BYE o( ^  ^ )o **/
%MEND control;
%control();
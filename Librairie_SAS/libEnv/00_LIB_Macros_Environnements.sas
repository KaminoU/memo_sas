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
/*************
 ** OBJECTIFS *
 ****************************************************************************************************************

    Macros permettant de gérer les environnements :
      • mountLibraries
      • getEnv
      • librariesMapping /!\ ATTENTION /!\ cette macro dépend de la macro d'import à charger avant...

 ****************************************************************************************************************
 ** Date Création : 13/11/2018                                                                                  *
 ** Date MAJ      : 20/11/2018                                                                                  *
 ** Version       : 1.0                                                                                         *
 ** Auteur(s)     : Michel TRUONG                                                                               *
 ****************************************************************************************************************/
%let sasLibRoot = \\Chemin abolu\Reseau\ou\non;

options noquotelenmax mstored sasmstore=stmEnv;
libname stmEnv "&sasLibRoot.\Librairie_SAS\libEnv";

%MACRO
	getEnv() / store
	des="Permet de se positionner sur un environnement, DEV, QUAL ou PROD"
;
	%if %symexist(ENV) %then %do;
		%if %upcase(&env.) eq DEV or %upcase(&env.) eq DEVELOPPEMENT %then %do;
			%let env2Return = DEV;
		%end;
		%else %if %upcase(&env.) eq QUAL or %upcase(&env.) eq QUALIFICATION %then %do;
			%let env2Return = QUAL;
		%end;
		%else %if %upcase(&env.) eq PROD or %upcase(&env.) eq PRODUCTION %then %do;
			%let env2Return = PROD;
		%end;

		%sysfunc(compress(&env2Return.))
		%goto MACRO_END;
	%end;

	%put2Log(" Merci d'importer le fichier de paramétrage contenant la définition des environnements en premier ");

	%MACRO_END: /** FIN **/
%MEND getEnv;
/**
Exemple :
	%let sasLibRoot = \\Chemin abolu\Reseau\ou\non\Librairie_SAS;
	options noquotelenmax mstored sasmstore=stMacL;
	libname stMacL "&sasLibRoot.";

	%setDynVar(
		'\\Chemin abolu\Reseau\ou\non\_PARAM_PROJET_\_000_FICHIER_PARAMETRAGE_DTM.csv',
		displayVar=YES,
		backUP=NO);

	%debugVar(env);
	%let monEnv = %getEnv();
	%debugVar(monEnv);
 **/

%MACRO
	runOnProdOnly(prgSAS2Include) / store
	des="Permet de lancer de manière sécuriser les traitements qu'en environnement de Production seulement..."
;
	%if &prgSAS2Include. eq %then %do;
		%put2Log(" [Environnement : %getEnv()]::Merci de saisir le programme SAS à inclure pour être lancé seulement sur l'environnement de production ");

		%goto ERR_HANDLER;
	%end;

	%if %getEnv() eq PROD or %getEnv() eq PRODUCTION %then %do;
		%put2Log(" [Environnement : %getEnv()]::DÉBUT Traitement ", typeLog = NOTE);/**[ DÉBUT TRAITEMENT EN PROD SEUL ]***********************/

		%let _file2Inc = %qsysfunc(dequote(&prgSAS2Include.));
		%if %isFile("&_file2Inc.") = 1 %then %do;
			%inc "&_file2Inc.";
		%end;

		%put2Log(" [Environnement : %getEnv()]::FIN Traitement ", typeLog = NOTE);/**[ FIN TRAITEMENT EN PROD SEUL ]***************************/
	%end;

	%MACRO_END: /** FIN **/
%MEND runOnProdOnly;
/**
Exemple :
	%let prgSas = '\\Chemin abolu\Reseau\ou\non\Librairie_SAS\hello.sas';
	%runOnProdOnly(&prgSas.);
 **/


%MACRO
	mountArchivesData(archiveDate, scope=ARCHIVE, server=EXPLOIT) / store
	des="Permet de monter des dossiers archivés en lecture seule dans SAS"
;
	%if %symexist(PATH_PARAM) %then %do;
		%importFlatFile("&path_param.\&name_lib_archives_2_mount_param..sasdesc");

		%if %symexist(archive_folder_name) = 0 %then %do;
			%put2Log(" Aucune définition de préfixe pour le nom de dossier d'archivage (doit être ARCHIVE_DTM) ");
			%put2Log(" Merci de réimporter le fichier de paramétrage en lançant le programme _000_PARAMETRAGES.sas ");

			%goto MACRO_END;
		%end;

		%if &archiveDate. eq or &archiveDate. eq "" %then %do;
			%put2Log(" Veuillez indiquer la date du dossier d'archivage à monter ");

			%goto MACRO_END;
		%end;

		%if %upcase(&scope.) ne ARCHIVE and %upcase(&scope.) ne BACKUP %then %do;
			%put2Log(" Veuillez indiquer le type de données à monter (scope = ARCHIVE ou scope = BACKUP) ");

			%goto MACRO_END;
		%end;

		%if %upcase(&server.) ne EXPLOIT and %upcase(&server.) ne LABO %then %do;
			%put2Log(" Veuillez indiquer le serveur d'origine (server = EXPLOIT ou server = LABO) ");

			%goto MACRO_END;
		%end;

		%if %isFile("&racine_deep_archivage.\&archive_folder_name._&archiveDate.") = 0 %then %do;
			%put2Log(" Dossier &archive_folder_name._&archiveDate. non trouvé sur le disque G (&path_archiv_root_G.) ");

			%goto MACRO_END;
		%end;

		%let _archiveFolder2Mount = &archive_folder_name._&archiveDate.\&server.;
		%let _lrefPrefix = AR_;
		%if %upcase(&scope.) eq BACKUP %then %do;
			%let _archiveFolder2Mount = &archive_folder_name._&archiveDate.\BACKUP_DELETION\&server.;
			%let _lrefPrefix = BK_;
		%end;

		data _test;
			set _ARCHIVES_2MOUNT;

			if length(nomDossier) > 4 then do;
				if upcase(substr(nomDossier, 1, 4)) eq 'DTM_' then do;
					_newRef = substr(nomDossier, 5, length(nomDossier));
				end;
				else do;
					if upcase(substr(nomDossier, 1, 4)) eq 'DWT_' then do;
						_newRef = substr(nomDossier, 5, length(nomDossier));
					end;
					else do;
						_newRef = substr(nomDossier, 1, 5);
					end;
				end;
			end;
			else do;
				_newRef = nomDossier;
			end;
		run;

		data _null_;
			set _test;
			/*call execute("libname &_lrefPrefix." || compress(_newRef) || " '&racine_deep_archivage.\&_archiveFolder2Mount.\" || compress(nomDossier) || "' access=readonly compress=yes;");*/
			call execute("libname &_lrefPrefix." || compress(_newRef) || " '&racine_deep_archivage.\&_archiveFolder2Mount.\" || compress(nomDossier) || "' access=readonly;");
		run;
	%end;
	%else %do;
		%put2Log(" Merci d'importer le fichier de paramétrage contenant la définition des environnements en premier ");
	%end;

	%MACRO_END: /** FIN **/
%MEND mountArchivesData;
/**
Exemple :
	*-- Comportement par défaut : Monter dynamiquement les répertoires archives en lecture seule, à partir d'une date d'arrêtée donnée en argument --;
	%mountArchivesData(20181231, scope = ARCHIVE, server = EXPLOIT);


	*-- Monter dynamiquement les tables supprimées et conservées dans le répertoire des suppressions Backup de données --;
	%mountArchivesData(20181231, scope = BACKUP, server = EXPLOIT);
 **/

%MACRO
	mountLibraries() / store
	des="Permet de monter des librairies SAS"
;
	%if %symexist(ENV) %then %do;
		%if %getEnv() eq PROD %then %do;
			%put;
			%put2Log(
				" [Environnement : %getEnv()]::Vous êtes en environnement de Production, il n'y a aucune librairie à monter... ",
				typeLog = NOTE
			);

			%goto MACRO_END;
		%end;

		%importFlatFile("&path_param.\&name_lib_mapping_param..sasdesc");

		%let isTab = %isTable(LIBRARIES_MAPPING);
		/*%let _root = F:\SASDATA\DEEP\EXPLOIT;*/
		%let _root = G:\ARCHIVAGE\DEEP\_ENV_;

		%if &isTab. = 1 %then %do;
			%let root = &_root.\_DEV_;
			%if %getEnv() eq QUAL %then %do;
				%let root = &_root.\_QUAL_;
			%end;

			data _null_;
				set LIBRARIES_MAPPING;

				%if %getEnv() eq DEV %then %do;
					/*call execute('libname ' || compress(libDev) || " '&root.\" || compress(libProd) || "' compress=yes;");*/
					call execute('libname ' || compress(libDev) || " '&root.\" || compress(libProd) || "';");
				%end;
				%else %if %getEnv() eq QUAL %then %do;
					/*call execute('libname ' || compress(libQual) || " '&root.\" || compress(libProd) || "' compress=yes;");*/
					call execute('libname ' || compress(libQual) || " '&root.\" || compress(libProd) || "';");
				%end;

			run;

			%put2Log(
				" [Environnement : %getEnv()]::Les librairies ont été correctement montées ",
				typeLog = NOTE
			);

			%goto MACRO_END;
		%end;

		%put2Log(" [Environnement : %getEnv()]::La table LIBRARIES_MAPPING n'existe pas, merci de vérifier sa création... ");
	%end;
	%else %do;
		%put2Log(" Merci d'importer le fichier de paramétrage contenant la définition des environnements en premier ");
	%end;

	%MACRO_END: /** FIN **/
%MEND mountLibraries;
/**
Exemple :
	%mountLibraries();
 **/

%MACRO
	unMountLibraries() / store
	des="Permet de démonter des librairies SAS"
;
	%if %symexist(ENV) %then %do;
		%if %getEnv() eq PROD %then %do;
			%put;
			%put2Log(
				" [Environnement : %getEnv()]::Vous êtes en environnement de Production, il n'y a aucune librairie à démonter... ",
				typeLog = NOTE
			);

			%goto MACRO_END;
		%end;

		%importFlatFile("&path_param.\&name_lib_mapping_param..sasdesc");

		%let isTab = %isTable(LIBRARIES_MAPPING);
		/*%let _root = F:\SASDATA\DEEP\EXPLOIT;*/
		%let _root = G:\ARCHIVAGE\DEEP\_ENV_;

		%if &isTab. = 1 %then %do;
			%let root = &_root.\_DEV_;
			%if %getEnv() eq QUAL %then %do;
				%let root = &_root.\_QUAL_;
			%end;

			data _null_;
				set LIBRARIES_MAPPING;

				%if %getEnv() eq DEV %then %do;
					call execute('libname ' || compress(libDev) || ' clear;');
				%end;
				%else %if %getEnv() eq QUAL %then %do;
					call execute('libname ' || compress(libQual) || ' clear;');
				%end;

			run;

			%put2Log(
				" [Environnement : %getEnv()]::Les librairies ont été correctement démontées ",
				typeLog = NOTE
			);

			%goto MACRO_END;
		%end;

		%put2Log(" [Environnement : %getEnv()]::La table LIBRARIES_MAPPING n'existe pas, merci de vérifier sa création... ");
	%end;
	%else %do;
		%put2Log(" Merci d'importer le fichier de paramétrage contenant la définition des environnements en premier ");
	%end;

	%MACRO_END: /** FIN **/
%MEND unMountLibraries;
/**
Exemple :
	%unMountLibraries();
 **/

%MACRO
	killLibraries() / store
	des="Permet de vider les librairies SAS"
;
	%if %symexist(ENV) %then %do;
		%if %getEnv() eq PROD %then %do;
			%put;
			%put2Log(
				" [Environnement : %getEnv()]::Vous êtes en environnement de Production!!! Il n'y a rien à supprimer... ",
				typeLog = NOTE
			);

			%goto MACRO_END;
		%end;

		%importFlatFile("&path_param.\&name_lib_mapping_param..sasdesc");

		%let isTab = %isTable(LIBRARIES_MAPPING);

		%if &isTab. = 1 %then %do;
			data _null_;
				set LIBRARIES_MAPPING;

				%if %getEnv() eq DEV %then %do;
					call execute('proc datasets lib=' || compress(libDev) || ' nolist nodetails kill; quit; run;');
				%end;
				%else %if %getEnv() eq QUAL %then %do;
					call execute('proc datasets lib= ' || compress(libQual) || ' nolist nodetails kill; quit; run;');
				%end;

			run;

			%put2Log(
				" [Environnement : %getEnv()]::Les librairies ont correctement été purgées de leurs tables ",
				typeLog = NOTE
			);

			%goto MACRO_END;
		%end;

		%put2Log(" [Environnement : %getEnv()]::La table LIBRARIES_MAPPING n'existe pas, merci de vérifier sa création... ");
	%end;
	%else %do;
		%put2Log(" Merci d'importer le fichier de paramétrage contenant la définition des environnements en premier ");
	%end;

	%MACRO_END: /** FIN **/
%MEND killLibraries;
/**
Exemple :
	%killLibraries();
 **/

%MACRO
	librariesMapping() / store
	des="Permet de mapper les noms des librairies longs/courts sur un environnement spécifique, DEV, QUAL ou PROD"
;
	%if %symexist(ENV) %then %do;
		%importFlatFile("&path_param.\&name_lib_mapping_param..sasdesc");

		%let isTab = %isTable(LIBRARIES_MAPPING);

		%if &isTab. = 1 %then %do;
			data _null_;
				set LIBRARIES_MAPPING;

				%if %getEnv() eq DEV %then %do;
	/*%put ERROR:--[DEBUG]-- Je suis en DEV --[/DEBUG]--;*/
					call symputx(compress(nomVar), compress(libDev), 'G');
				%end;
				%else %if %getEnv() eq QUAL %then %do;
	/*%put ERROR:--[DEBUG]-- Je suis en QUAL --[/DEBUG]--;*/
					call symputx(compress(nomVar), compress(libQual), 'G');
				%end;
				%else %if %getEnv() eq PROD %then %do;
	/*%put ERROR:--[DEBUG]-- Je suis en PROD --[/DEBUG]--;*/
					call symputx(compress(nomVar), compress(libProd), 'G');
				%end;

			run;

			%put2Log(
				" [Environnement : %getEnv()]::Les macro variables des librairies ont correctement été mappées selon le fichier de paramétrage _001_LIBRARIES_MAPPING.csv : ",
				typeLog = NOTE
			);

			proc sql noprint;
				select nomVar into :varList2Disp separated by ' '
				from LIBRARIES_MAPPING;
			quit;
			%let thisNbVal = %getNbVal(&varList2Disp.);

			%do i=1 %to &thisNbVal.;
				%let thisVar = %scan(&varList2Disp., &i.);
				%put2Log(" [Environnement : %getEnv()]::&&thisVar. : &&&thisVar ", typeLog = NOTE);
			%end;

			%goto MACRO_END;
		%end;

		%put2Log(" La table LIBRARIES_MAPPING n'existe pas, merci de vérifier sa création... ");
	%end;
	%else %do;
		%put2Log(" Merci d'importer le fichier de paramétrage contenant la définition des environnements en premier ");
	%end;

	%MACRO_END: /** FIN **/
%MEND librariesMapping;
/**
Exemple :
	%let sasLibRoot = \\Chemin abolu\Reseau\ou\non\Librairie_SAS;
	options noquotelenmax mstored sasmstore=stMacL;
	libname stMacL "&sasLibRoot.";

	%librariesMapping();

	%let myVar = 
		DTM
		DTM_HIST
		DTM_HIST_PROD
		DTM_INVE
		DTM_INVEST_PROD
		DTM_LAB
		DTM_LAB_PROD
		DTM_PROD
		DWT_EXT
		FORMATS
	;
	%debugVar(&myVar.);
 **/

%MACRO
	buildData() / store
	des="Permet de créer des jeux de données pour les différents environnement DEV ou QUAL"
;
	%if %symexist(ENV) %then %do;
		%if %getEnv() eq PROD %then %do;
			%put;
			%put2Log(
				" [Environnement : %getEnv()]::Vous êtes en environnement de Production, aucune table ne sera échantillonnée... ",
				typeLog = NOTE
			);

			%goto MACRO_END;
		%end;

		%importFlatFile("&path_param.\&name_data_survey_param..sasdesc");

		%if not %symexist(nbObs2build) %then %do;
			%put;
			%put2Log(" [Environnement : %getEnv()]::Le fichier de paramétrage &name_default_param. ne contient pas la déclaration et définition de la macro variable nbObs2build ");
			%put2Log(" Merci d'y ajouter une ligne contenant nbObs2build avec le nombre des observations souhaités comme échantillonage ");

			%goto MACRO_END;
		%end;

		proc sql noprint;
			select
				'&' || compress(libFrom) || '.',
				compress(libFrom),
				compress(data2Build)
					into
						:lLib2Copy separated by ' ',
						:lLibFrom separated by ' ',
						:lData2Build separated by ' '
			from DATA_2_BUILD
			;
		quit;

	/*%debugVar(lLib2Copy);*/
	/*%debugVar(lLibFrom);*/
	/*%debugVar(lData2Build);*/

		%if %getEnv() eq DEV %then %do;
			%if &nbObs2build. ne 0 and %upcase(&nbObs2build.) ne ALL and &nbObs2build. ne %then %do;
				options obs=&nbObs2build.;
			%end;
			%else %do;
				options obs=max;
			%end;
		%end;
		%else %do;
			options obs=max;
		%end;

		%let thisNbVal = %getNbVal(&lLib2Copy.);

		%do i=1 %to &thisNbVal.;
			%let thisLib2Copy = %scan(&lLib2Copy., &i.);
			%let thislLibFrom = %scan(&lLibFrom., &i.);
			%let thisData2Build = %scan(&lData2Build., &i.);
			
			/*%put ERROR:--[DEBUG]-- i(&i.) : &thisLib2Copy. : &thislLibFrom. : &thisData2Build. --[/DEBUG]--;*/

			proc datasets lib=&thisLib2Copy. nolist;
				copy in=&thislLibFrom. out=&thisLib2Copy.;
					select &thisData2Build.;
			quit;
		%end;

		%put2Log(
			" [Environnement : %getEnv()]::L'échantillonage des données a été correctement réalisé ",
			typeLog = NOTE
		);
	%end;
	%else %do;
		%put2Log(" Merci d'importer le fichier de paramétrage contenant la définition des environnements en premier ");
	%end;

	%MACRO_END: /** FIN **/
%MEND buildData;
/**
Exemple :
	%buildData();
 **/

%MACRO
	updateListOfSASPrgCSV(pathOfParam, csvFileName) / store
	des="Permet de mettre à jour le fichier CSV listant tous les programmes SAS"
;
	%if %symexist(ENV) %then %do;
		%let thisFullPathOfParam = %qsysfunc(dequote(&pathOfParam.));
		%let thisCSVFileName = %qsysfunc(dequote(&csvFileName.));

		data _null_;
			file "&thisFullPathOfParam.\&thisCSVFileName." encoding="WLATIN1";
			length line $2048;
			put "SAS_program";
		run;

		data _null_;
			set L_SAS_PRG_SCANNED;
			file "&thisFullPathOfParam.\&thisCSVFileName." mod;
			length line $2048;

			if current_folder ne "" then do;
				line = cats(root, "\", unc_app_env, "\", current_folder, "\", current_sas_prg);
			end;
			else do;
				line = cats(root, "\", unc_app_env, "\", current_sas_prg);
			end;

			put line;
		run;
	%end;
	%else %do;
		%put2Log(" Merci d'importer le fichier de paramétrage contenant la définition des environnements en premier ");
	%end;

	%MACRO_END: /** FIN **/
%MEND updateListOfSASPrgCSV;

%MACRO
	getListOfFolderFromEnv(outVar=APP_listOfFolderFromEnv) / store
	des="Permet d'avoir la liste des répertoire d'un environnement donné"
;
	%if %symexist(ENV) %then %do;
		%let thisOutVar = %qsysfunc(compress(&outVar.));
		%global &thisOutVar.;
		%let &thisOutVar. = ;

		filename pipedir pipe "NET USE T: /DELETE /Y && NET USE T: &path_unc. && DIR ""&path_unc_app_root.\&path_unc_app_env."" /B/O:N/A:D" lrecl=32767;
		data filenames;
			infile pipedir truncover;
			input line $1024.;
		run;

		proc sql noprint;
			select trim(compbl(line)) into :listOfFolder separated by ' '
			from filenames
			where upcase(line) LIKE 'PRG_%'
				  or upcase(line) LIKE 'USER_%'
			;
		quit;

		%let &thisOutVar. = &listOfFolder.;
	%end;
	%else %do;
		%put2Log(" Merci d'importer le fichier de paramétrage contenant la définition des environnements en premier ");
	%end;

	%MACRO_END: /** FIN **/
%MEND getListOfFolderFromEnv;
/**
Exemple :
	%getListOfFolderFromEnv(outVar=listOfFolderFromEnv);
	%put2Log(" La liste des répertoires de l'environnement de DEV est &listOfFolderFromEnv. ");
 **/

%MACRO
	makeCopyBatchFile(sourceEnv, targetEnv, autoLoad=NO, checkIsTargetFolderExisted=YES) / store
	des="Permet de créer un script batch pour la copie/déploiement d'un environnement à l'autre"
;
	%if &sourceEnv. eq or &sourceEnv. eq "" %then %do;
		%put2Log(" Merci d'indiquer votre environnement source pour la génération du script de déploiement ");
		%goto MACRO_END;
	%end;
	%if &targetEnv. eq or &targetEnv. eq "" %then %do;
		%put2Log(" Merci d'indiquer votre environnement cible pour la génération du script de déploiement ");
		%goto MACRO_END;
	%end;
	%if &sourceEnv. eq &targetEnv. %then %do;
		%put2Log(" Les 2 environnements source & cible sont identiques ; aucune action ne sera réalisée... ");
		%goto MACRO_END;
	%end;
	%if %upcase(&sourceEnv.) ne DEV and %upcase(&sourceEnv.) ne QUAL and %upcase(&sourceEnv.) ne PROD %then %do;
		%put2Log(" Vous avez spécifié un environnement source inconnu ; les valeurs possibles sont DEV, QUAL ou PROD ");
		%goto MACRO_END;
	%end;
	%if %upcase(&targetEnv.) ne DEV and %upcase(&targetEnv.) ne QUAL and %upcase(&targetEnv.) ne PROD %then %do;
		%put2Log(" Vous avez spécifié un environnement cible inconnu ; les valeurs possibles sont DEV, QUAL ou PROD ");
		%goto MACRO_END;
	%end;

	%if %symexist(ENV) %then %do;		
		proc sql noprint;
			select distinct unc_app_root into :unc_app_root
			from L_SAS_PRG_SCANNED
			;
		quit;

		data _null_;
			file "&path_bat_script.\sas2Deploy.bat" encoding="WLATIN1";
			length line $2048;
			put "echo off";
			put 'CHCP 28591 > NULL'; /* pour gérer un bug connu de windows ne permettant pas d'interpréter correctement les caractères accentués dans les commandes */

			line = cat("SET P_ROOT=", "&unc_app_root.");
			put line;
		run;

		%if %upcase(&checkIsTargetFolderExisted.) eq YES %then %do;
			proc sql noprint;
				create table l_folder_2_check as
					select distinct current_folder, "&targetEnv." as target_env
					from L_SAS_PRG_SCANNED
					where is_deployable = 1
				;
			quit;

			data _null_;
				set l_folder_2_check;
				file "&path_bat_script.\sas2Deploy.bat" mod;
				length line $2048;

				line = cat('MKDIR "%P_ROOT%\_', trim(target_env), '_\', trim(current_folder), '" 2>NUL');
				put line;
			run;
		%end;

		proc sql noprint;
			create table l_SAS_2_deploy as
				select a.current_folder, a.current_sas_prg, "&sourceEnv." as source_env, "&targetEnv." as target_env
				from L_SAS_PRG_SCANNED as a
				where is_deployable = 1
			;
		quit;

		data _null_;
			set l_SAS_2_deploy;
			file "&path_bat_script.\sas2Deploy.bat" mod;
			length line $2048;

			line = cat('COPY "%P_ROOT%\_', trim(source_env), '_\', trim(current_folder), '\', trim(current_sas_prg), '" "%P_ROOT%\_', trim(target_env), '_\', trim(current_folder), '\', trim(current_sas_prg), '" ');
			put line;
		run;

		%put2Log(
			" La génération du script de déploiement s'est déroulée correctement ; vous trouverez le script nommé sas2Deploy.bat à la racine du disque K:\ ",
			typeLog = NOTE
		);

		%if %upcase(&autoLoad.) eq YES %then %do;
			x "&path_bat_script.\sas2Deploy.bat";

			%put2Log(
				" Le déploiement s'est déroulé correctement - environnement source ::&sourceEnv.:: > environnement cible ::&targetEnv.:: ",
				typeLog = NOTE
			);

			%put2Log(
				" Le script nommé sas2Deploy.bat a été supprimé du disque K:\ après son exécution. Si vous souhaitez le consulter, appelez la macro avec [autoLoad = NO] ",
				typeLog = NOTE
			);
			x DEL /F "&path_bat_script.\sas2Deploy.bat";
		%end;
	%end;
	%else %do;
		%put2Log(" Merci d'importer le fichier de paramétrage contenant la définition des environnements en premier ");
	%end;

	%MACRO_END: /** FIN **/
%MEND makeCopyBatchFile;
/**
Exemple :
	%makeCopyBatchFile(sourceEnv = %getEnv(), targetEnv = QUAL);
	%makeCopyBatchFile(sourceEnv = %getEnv(), targetEnv = QUAL, autoLoad = YES);
 **/

%MACRO
	sasFileCopy(descIn, descOut) / store
	des="Permet de copier des fichiers en passant par SAS, dans le cas où les script batch ne fonctionnent pas à cause de l'environnement"
;
	/* byte-for-byte copying */
	data _null_;
		length filein 8 fileid 8;

		filein = fopen("&descIn.", 'I', 1, 'B');
		fileid = fopen("&descOut.", 'O', 1, 'B');

		rec = '20'x;

		do while(fread(filein)=0);
			rc = fget(filein, rec, 1);
			rc = fput(fileid, rec);
			rc = fwrite(fileid);
		end;

		rc = fclose(filein);
		rc = fclose(fileid);
	run;

	%MACRO_END: /** FIN **/
		filename in clear;
		filename out clear;
%MEND sasFileCopy;
/**
Exemple :
	filename in "\\T3FC9\\KST\test_input.xlsx";
	filename out "\\T3FC9\\KST\test_output.xlsx";

	%sasFileCopy(in, out);

	*Test data backup du K vers l'archivage;
	*filename in "\\T3F42\KST\bibi_semiconf.sas7bdat"; -- Chemin KO --;
	*filename in "\\T3F42\KST\SASDATA\DEEP\EXPLOIT\bibi_semiconf.sas7bdat"; -- Chemin KO --;
	filename in "F:\SASDATA\DEEP\EXPLOIT\bibi_semiconf.sas7bdat";
	filename out "\\T3f42\ARCHIVAGE_DEEP\myOData.sas7bdat";
	%sasFileCopy(in, out);

	*list mapping on the server;
	filename diskinfo DRIVEMAP;
	data _null_;
	  infile diskinfo;
	  input;
	  put _infile_;
	run;

	filename in "F:\SASDATA\DEEP\EXPLOIT\DTM\bibi_semiconf.sas7bdat";
	filename out "G:\ARCHIVAGE_DEEP\TEST_BACKUP\myOData.sas7bdat";
	%sasFileCopy(in, out);

	x copy /B /Y "F:\SASDATA\DEEP\EXPLOIT\DTM\bibi_semiconf.sas7bdat" "G:\TEST_BACKUP\myOData.sas7bdat"; *KO - Chemin G??!!;
	x copy /B /Y "F:\SASDATA\DEEP\EXPLOIT\DTM\bibi_semiconf.sas7bdat" "F:\SASDATA\DEEP\EXPLOIT\DTM\myOData.sas7bdat.VIA_X"; *OK - 0s;

	filename in "F:\SASDATA\DEEP\EXPLOIT\DTM\bibi_semiconf.sas7bdat";
	filename out "F:\SASDATA\DEEP\EXPLOIT\DTM\myOData.sas7bdat.VIA_MACRO";
	%sasFileCopy(in, out); *OK - 10s;
 **/

%MACRO
	sasFileCopyBatch(sourceEnv, targetEnv, checkIsTargetFolderExisted=YES) / store
	des="Permet de batcher la copie avec la primitive %sasFileCopy"
;
	%if &sourceEnv. eq or &sourceEnv. eq "" %then %do;
		%put2Log(" Merci d'indiquer votre environnement source pour la génération du script de déploiement ");
		%goto MACRO_END;
	%end;
	%if &targetEnv. eq or &targetEnv. eq "" %then %do;
		%put2Log(" Merci d'indiquer votre environnement cible pour la génération du script de déploiement ");
		%goto MACRO_END;
	%end;
	%if &sourceEnv. eq &targetEnv. %then %do;
		%put2Log(" Les 2 environnements source & cible sont identiques ; aucune action ne sera réalisée... ");
		%goto MACRO_END;
	%end;
	%if %upcase(&sourceEnv.) ne DEV and %upcase(&sourceEnv.) ne QUAL and %upcase(&sourceEnv.) ne PROD %then %do;
		%put2Log(" Vous avez spécifié un environnement source inconnu ; les valeurs possibles sont DEV, QUAL ou PROD ");
		%goto MACRO_END;
	%end;
	%if %upcase(&targetEnv.) ne DEV and %upcase(&targetEnv.) ne QUAL and %upcase(&targetEnv.) ne PROD %then %do;
		%put2Log(" Vous avez spécifié un environnement cible inconnu ; les valeurs possibles sont DEV, QUAL ou PROD ");
		%goto MACRO_END;
	%end;

	%if %symexist(ENV) %then %do;
		%if %upcase(&checkIsTargetFolderExisted.) eq YES %then %do;
			proc sql noprint;
				create table l_folder_2_check as
					select distinct root, unc_app_env, current_folder, "_&targetEnv._" as target_env
					from L_SAS_PRG_SCANNED
					where is_deployable = 1
				;
			quit;

			data _NULL_;
				set l_folder_2_check;
				call execute('data _null_; newDir = dcreate("' || trim(current_folder) || '", "' || trim(root) || '\' || trim(target_env) || '"); run;');
			run;
		%end;

		proc sql noprint;
			create table l_SAS_2_deploy as
				select a.root, a.current_folder, a.current_sas_prg, "_&sourceEnv._" as source_env, "_&targetEnv._" as target_env
				from L_SAS_PRG_SCANNED as a
				where is_deployable = 1
			;
		quit;

		data _NULL_;
			set l_SAS_2_deploy;
			call execute('filename in "' || trim(root) || '\' || trim(source_env) || '\' || trim(current_folder) || '\' || trim(current_sas_prg) || '";');
			call execute('filename out "' || trim(root) || '\' || trim(target_env) || '\' || trim(current_folder) || '\' || trim(current_sas_prg) || '";');
			call execute('%sasFileCopy(in, out);');
		run;
	%end;

	%MACRO_END: /** FIN **/
%MEND sasFileCopyBatch;
/**
Exemple :
	%sasFileCopyBatch(sourceEnv = %getEnv(), targetEnv = QUAL);
 **/

%MACRO
	scanFolder4SASFile(updateCSV=YES, scope=ALL) / store
	des="Permet de scanner un répertoire pour lister les programmes SAS"
;
	%if %symexist(ENV) %then %do;
		data L_SAS_PRG_SCANNED;
			attrib root label="Chemin Projet non UNC" length=$256 format=$256. informat=$256.;

			attrib unc_app_root label="Chemin Projet UNC" length=$256 format=$256. informat=$256.;
			attrib unc_app_env label="Environnement courant" length=$16 format=$16. informat=$16.;
			attrib current_folder label="Répertoire courant" length=$128 format=$128. informat=$128.;
			attrib current_sas_prg label="Nom programme SAS" length=$128 format=$128. informat=$128.;

			attrib is_deployable label="Est déployable" length=8. format=1. informat=1.;
			attrib to_include label="Programmes à inclure" length=8. format=1. informat=1.;

			stop;
		run;

		%if %upcase(&scope.) eq ALL or %upcase(&scope.) eq APP_ONLY %then %do;
			%getListOfFolderFromEnv(outVar=listOfFolderFromEnv);

			%let thisNbVal = %getNbVal(&listOfFolderFromEnv.);
			%let maNlleListe = %getValueFromList(&listOfFolderFromEnv., delim='|');
			%do i=1 %to &thisNbVal.;
				%let APP_thisFolder = %scan(&maNlleListe., &i., '|');

				filename
					pipedir pipe
					"NET USE T: /DELETE /Y && NET USE T: &path_unc. && DIR ""&path_unc_app_root.\&path_unc_app_env.\&APP_thisFolder.\*.sas"" /A/B/O:GEN"
					lrecl=32767;

				data filenames;
					infile pipedir truncover;
					input line $128.;
				run;

				proc sql noprint;
					insert into L_SAS_PRG_SCANNED
						select "&path_root." as root,
							   "&path_unc_app_root." as unc_app_root,
							   "&path_unc_app_env." as unc_app_env,
							   "&APP_thisFolder." as current_folder,
							   line as current_sas_prg,
							   1 as is_deployable,
							   case
							   		when upcase(calculated current_folder) LIKE 'USER_%' then 1
									else 0
							   end as to_include
						from filenames
						where upcase(line) LIKE '%.SAS'
					;
				quit;

				proc sql noprint;
					select count(1) into : APP_nbSASInserted trimmed
					from L_SAS_PRG_SCANNED
					where upcase(current_folder) = "%upcase(&APP_thisFolder.)";
				quit;

				%put2Log(
					" &APP_nbSASInserted. programme(s) SAS détecté(s) à l'adresse [&path_unc_app_root.\&path_unc_app_env.\&APP_thisFolder.] ",
					typeLog = NOTE
				);
			%end;
		%end;

		%if %upcase(&scope.) eq ALL or %upcase(&scope.) eq FORMATS_ONLY %then %do;
			filename
				pipedir pipe
				"NET USE T: /DELETE /Y && NET USE T: &path_unc. && DIR ""&path_unc_app_root.\&path_unc_app_format.\*.sas"" /A/B/O:GEN"
				lrecl=32767;

			data filenames;
				infile pipedir truncover;
				input line $128.;
			run;

			proc sql noprint;
				insert into L_SAS_PRG_SCANNED
					select "&path_root." as root,
						   "&path_unc_app_root." as unc_app_root,
						   "&path_unc_app_format." as unc_app_env,
						   "" as current_folder,
						   line as current_sas_prg,
						   0 as is_deployable,
						   0 as to_include
					from filenames
					where upcase(line) LIKE '%.SAS'
				;
			quit;

			proc sql noprint;
				select count(1) into : APP_nbSASInserted trimmed
				from L_SAS_PRG_SCANNED
				where upcase(unc_app_env) = "%upcase(&path_unc_app_format.)";
			quit;

			%put2Log(
				" &APP_nbSASInserted. programme(s) SAS détecté(s) à l'adresse [&path_unc_app_root.\&path_unc_app_format.] ",
				typeLog = NOTE
			);
		%end;

		%if %upcase(&scope.) eq ALL or %upcase(&scope.) eq SAS_ONLY %then %do;
			filename
				pipedir pipe
				"NET USE T: /DELETE /Y && NET USE T: &path_unc. && DIR ""&path_unc_app_root.\&path_unc_app_prg.\*.sas"" /A/B/O:GEN"
				lrecl=32767;

			data filenames;
				infile pipedir truncover;
				input line $128.;
			run;

			proc sql noprint;
				insert into L_SAS_PRG_SCANNED
					select "&path_root." as root,
						   "&path_unc_app_root." as unc_app_root,
						   "&path_unc_app_prg." as unc_app_env,
						   "" as current_folder,
						   line as current_sas_prg,
						   0 as is_deployable,
						   0 as to_include
					from filenames
					where upcase(line) LIKE '%.SAS'
				;
			quit;

			proc sql noprint;
				select count(1) into : APP_nbSASInserted trimmed
				from L_SAS_PRG_SCANNED
				where upcase(unc_app_env) = "%upcase(&path_unc_app_prg.)";
			quit;

			%put2Log(
				" &APP_nbSASInserted. programme(s) SAS détecté(s) à l'adresse [&path_unc_app_root.\&path_unc_app_prg.] ",
				typeLog = NOTE
			);
		%end;

		%if %upcase(&updateCSV.) eq YES %then %do;
			%updateListOfSASPrgCSV(&path_param., &name_prg_list_param..csv);
			%put2Log(
				" Le fichier de paramétrage &path_param.\&name_prg_list_param..csv est bien mis à jour... ",
				typeLog = NOTE
			);
		%end;
	%end;
	%else %do;
		%put2Log(" Merci d'importer le fichier de paramétrage contenant la définition des environnements en premier ");
	%end;

	%MACRO_END: /** FIN **/
%MEND scanFolder4SASFile;
/**
Exemple :
	%scanFolder4SASFile();
	scanFolder4SASFile(updateCSV=NO, scope=ALL);
	scanFolder4SASFile(updateCSV=NO, scope=FORMATS_ONLY);
	scanFolder4SASFile(updateCSV=NO, scope=SAS_ONLY);
 **/

%MACRO
	prgSAS2Include(scope=ALL) / store
	des="Permet d'importer des programmes SAS dynamiquement en provenance des répertoires USER_*'"
;
	%if %symexist(ENV) %then %do;
		%scanFolder4SASFile(updateCSV = NO, scope = ALL);

		proc sql noprint;
			create table _PRG_SAS_2_INC as
				select root, unc_app_env, current_folder, current_sas_prg, is_deployable, to_include
				from L_SAS_PRG_SCANNED
				where is_deployable = 1 and  to_include = 1
			;
		quit;

		%let thisScope = ALL;
		%if %upcase(&scope.) ne ALL %then %do;
			%let thisScope = %qsysfunc(dequote(&scope.));

			%let is2IncExisted = 0;
			proc sql noprint;
				select count(1) into :is2IncExisted
				from _PRG_SAS_2_INC
				where upcase(current_folder) = upcase("&thisScope.")
				;
			quit;

			%if &is2IncExisted. = 0 %then %do;
				%put2Log(" Le répertoire spécifié &scope. n'existe pas. Merci de vérifier la saisie. ");
				%goto MACRO_END;
			%end;
		%end;

		data _null_;
			set _PRG_SAS_2_INC(
				%if &thisScope. ne ALL %then %do;
					where=(upcase(current_folder) = upcase("&thisScope."))
				%end;
			);

			call execute('%inc "' || trim(root) || '\' || trim(unc_app_env) || '\' || trim(current_folder) || '\' || trim(current_sas_prg) || '";');
			call symput('totalIncluded', _N_);
		run;

		%if &totalIncluded. > 1 %then %do;
			%put2Log(" %sysfunc(trim(&totalIncluded.)) programmes SAS ont été correctement importés ", typeLog = NOTE);
		%end;
		%else %do;
			%put2Log(" %sysfunc(trim(&totalIncluded.)) programme SAS a été correctement importé ", typeLog = NOTE);
		%end;
	%end;
	%else %do;
		%put2Log(" Merci d'importer le fichier de paramétrage contenant la définition des environnements en premier ");
	%end;

	%MACRO_END: /** FIN **/
%MEND prgSAS2Include;
/**
Exemple :
	%prgSAS2Include();

	%prgSAS2Include(scope = user_SAS_programmes);
 **/

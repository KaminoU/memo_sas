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

    Macros permettant de gérer le projet :
      • Cette librairie est dépendante de la librairie des environnements, il faut donc la charger après

 ****************************************************************************************************************
 ** Date Création : 27/11/2018                                                                                  *
 ** Date MAJ      : 27/11/2018                                                                                  *
 ** Version       : 1.0                                                                                         *
 ** Auteur(s)     : Michel TRUONG                                                                               *
 ****************************************************************************************************************/
%let sasLibRoot = \\Chemin abolu\Reseau\ou\non;

options noquotelenmax mstored sasmstore=stmGes;
libname stmGes "&sasLibRoot.\Librairie_SAS\libGestionProjet";

%MACRO
	isPreRequesiteOK(outVar=APP_isPreReqOK, canCreateSigTab=NO) / store
	des="Permet de vérifier que les prérequis sont OK ou KO"
;
	%if %symexist(ENV) %then %do;
		%let thisOutVar = %qsysfunc(compress(&outVar.));
		%global &thisOutVar.;
		%let &thisOutVar. = 1;

		%setDynVar("&path_param.\&name_default_param.", displayVar=YES, backUP=NO);

		%isPWSetOK();
		%if &isPWSetOK. = 0 %then %do;
			%let &thisOutVar. = 0;
			%goto MACRO_END;
		%end;

		%setZLibSig();
		%if &setZLibSig. = 0 %then %do;
			%let &thisOutVar. = 0;
			%goto MACRO_END;
		%end;

		%let APP_thisSigTable = &tech_sig_lib..&tech_sig_tab.;
		%let isTab = %isTable(&APP_thisSigTable.);

		%if %upcase(&canCreateSigTab.) eq NO %then %do;
			%if &isTab. = 0 %then %do;
				%put2Log(" [Environnement : %getEnv()]::La table &APP_thisSigTable. n'existe pas ");

				%let &thisOutVar. = 0;
				%goto MACRO_END;
			%end;
		%end;
		%else %if %upcase(&canCreateSigTab.) eq YES %then %do;
			%if &isTab. = 1 %then %do;
				%put2Log(" La table &APP_thisSigTable. existe déjà ");

				%let &thisOutVar. = 0;
				%goto MACRO_END;
			%end;
		%end;
	%end;
	%else %do;
		%put2Log(" Merci d'importer le fichier de paramétrage contenant la définition des environnements en premier ");
	%end;
	
	%MACRO_END: /** FIN **/
%MEND isPreRequesiteOK;
/**
Exemple :
	%isPreRequesiteOK(outVar = APP_isPreRequesiteOK);
	%put2Log(" [Environnement : %getEnv()]::pré requis OK/KO? &APP_isPreRequesiteOK. ");

	%isPreRequesiteOK(outVar = APP_isPreRequesiteOK, canCreateSigTab = YES);
	%put2Log(" [Environnement : %getEnv()]::pré requis OK/KO? &APP_isPreRequesiteOK. ");
 **/


%MACRO
	isPWSetOK() / store
	des="Permet de vérifier que le mot de passe est bien présent dans le fichier de paramétrage"
;
	%global isPWSetOK;
	%let isPWSetOK = 1;

	%if not %symexist(mdp_tables) %then %do;
		%put2Log(" Le mot de passe n'est pas défini dans le fichier de paramétrage ");
		%let isPWSetOK = 0;
		%goto MACRO_END;
	%end;

	%MACRO_END: /** FIN **/
%MEND isPWSetOK;

%MACRO
	setZLibSig() / store
	des="Permet de monter la librairie zLibSig contenant la table des signatures"
;
	%global setZLibSig;
	%let setZLibSig = 1;

	%let isFile = %isFile("&path_tech_tables.");
	%if &isFile. = 0 %then %do;
		%put2Log(" Le répertoire [Tables_Techniques_SAS] est absent du dossier &sasLibRoot. ");
		%let setZLibSig = 0;
		%goto MACRO_END;		
	%end;

	libname &tech_sig_lib. "&path_tech_tables." compress=yes;

	%MACRO_END: /** FIN **/
%MEND setZLibSig;

%MACRO
	createTableSignature() / store
	des="Permet de créer la table des signatures digitales des programmes SAS"
;
	%isPreRequesiteOK(canCreateSigTab = YES);
	%if &APP_isPreReqOK. = 0 %then %do;
		%goto MACRO_END;
	%end;

	data &tech_sig_lib..&tech_sig_tab.(pw="&mdp_tables." encrypt=yes);
		attrib v_projet_SAS label="Version du Projet" length=$32 format=$32. informat=$32.;
		attrib nom_prg_SAS label="Nom Programme SAS" length=$128 format=$128. informat=$128.;

		attrib sig_DEV label="Signature en DEV" length=$256 format=$256. informat=$256.;
		attrib sig_QUAL label="Signature en QUALIFICATION" length=$256 format=$256. informat=$256.;
		attrib sig_PROD label="Signature en PRODUCTION" length=$256 format=$256. informat=$256.;

		attrib tot_err_DEV label="Total Erreurs SAS en DEV" length=8 format=8. informat=8.;
		attrib tot_warn_DEV label="Total Warnings SAS en DEV" length=8 format=8. informat=8.;
		attrib tot_trap_note_DEV label="Total Notes SAS !!A SURVEILLER!! en DEV" length=8 format=8. informat=8.;

		attrib tot_err_app_DEV label="Total Erreurs APP en DEV" length=8 format=8. informat=8.;
		attrib tot_warn_app_DEV label="Total Warnings APP en DEV" length=8 format=8. informat=8.;

		attrib tot_err_QUAL label="Total Erreurs SAS en QUALIFICATION" length=8 format=8. informat=8.;
		attrib tot_warn_QUAL label="Total Warnings SAS en QUALIFICATION" length=8 format=8. informat=8.;
		attrib tot_trap_note_QUAL label="Total Notes SAS !!A SURVEILLER!! en QUALIFICATION" length=8 format=8. informat=8.;

		attrib tot_err_app_QUAL label="Total Erreurs APP en QUALIFICATION" length=8 format=8. informat=8.;
		attrib tot_warn_app_QUAL label="Total Warnings APP en QUALIFICATION" length=8 format=8. informat=8.;

		attrib tot_err_PROD label="Total Erreurs SAS en PRODUCTION" length=8 format=8. informat=8.;
		attrib tot_warn_PROD label="Total Warnings SAS en PRODUCTION" length=8 format=8. informat=8.;
		attrib tot_trap_note_PROD label="Total Notes SAS !!A SURVEILLER!! en PRODUCTION" length=8 format=8. informat=8.;

		attrib tot_err_app_PROD label="Total Erreurs APP en PRODUCTION" length=8 format=8. informat=8.;
		attrib tot_warn_app_PROD label="Total Warnings APP en PRODUCTION" length=8 format=8. informat=8.;

		attrib comment label="Commentaires" length=$2048 format=$2048. informat=$2048.;
		attrib date_modif label="Date de modification" length=8 format=datetime19. informat=datetime19.;
		attrib date_creat label="Date de création" length=8 format=datetime19. informat=datetime19.;
		attrib deleted_at label="Date de suppression" length=8 format=datetime19. informat=datetime19.;

		stop;
	run;

	%put2Log(
		" La table &tech_sig_lib..&tech_sig_tab. a bien été créée ",
		typeLog = NOTE
	);

	%MACRO_END: /** FIN **/
%MEND createTableSignature;
/**
Exemple :
	%createTableSignature();

 	proc sql noprint;
		insert into &tech_sig_lib..&tech_sig_tab.(pw="{SAS003}40E1BDE386CC08DC0140F07D3CF59E71D34E")
		set
			v_projet_SAS = "v1.3",
			nom_prg_SAS = "mon programme.SAS",
			sig_DEV = "",
			sig_QUAL = "",
			sig_PROD = "",
			tot_err_DEV = .,
			tot_warn_DEV = .,
			tot_err_QUAL = .,
			tot_warn_QUAL = .,
			comment = "C'est un test...",
			date_modif = .,
			date_creat = datetime()
		;
	quit;
 **/

%MACRO
	readTableSignature(outData=TABLE_SIGNATURE/*, orderBy=date_modif date_creat v_projet_SAS nom_prg_SAS*/) / store
	des="Permet de lire la table des signatures digitales des programmes SAS"
;
	%if &outData. eq %then %do;
		%put2Log(" [Environnement : %getEnv()]::Le nom de la table de sortie ne doit pas être vide ");
		%goto MACRO_END;
	%end;

	%isPreRequesiteOK();
	%if &APP_isPreReqOK. = 0 %then %do;
		%goto MACRO_END;
	%end;

	/*%let thisOrderBy = %getValueFromList(&orderBy., delim=', ');*/
 	proc sql noprint;
		create table &outData. as
			select *
			from &tech_sig_lib..&tech_sig_tab.(pw="&mdp_tables.")
			/*order by &thisOrderBy.*/
			order by date_modif desc, date_creat desc, v_projet_SAS, nom_prg_SAS
		;
	quit;

	%MACRO_END: /** FIN **/
%MEND readTableSignature;
/**
Exemple :
	%readTableSignature();
 **/

%MACRO
	getListOfExistedVersions(outData=TABLE_SIGNATURE_VERSION) / store
	des="Permet de consulter la liste des versions existantes"
;
	%if &outData. eq %then %do;
		%put2Log(" [Environnement : %getEnv()]::Le nom de la table de sortie ne doit pas être vide ");
		%goto MACRO_END;
	%end;

	%isPreRequesiteOK();
	%if &APP_isPreReqOK. = 0 %then %do;
		%goto MACRO_END;
	%end;

 	proc sql noprint;
		create table &outData. as
			select count(1) as  NB_PrgSAS, v_projet_sas, put(datepart(date_creat), yymmdd10.) as m_arrete
			from &tech_sig_lib..&tech_sig_tab.(pw="&mdp_tables.")
			where deleted_at = .
			group by v_projet_sas, calculated m_arrete
			order by calculated m_arrete desc
		;
	quit;

	%MACRO_END: /** FIN **/
%MEND getListOfExistedVersions;
/**
Exemple :
	%getListOfExistedVersions();
 **/

%MACRO
	getMaxVersion(outVar=APP_maxVersion) / store
	des="Permet d'avoir la version courante"
;
	%isPreRequesiteOK();
	%if &APP_isPreReqOK. = 0 %then %do;
		%goto MACRO_END;
	%end;

	%let thisOutVar = %qsysfunc(compress(&outVar.));
	%global &thisOutVar.;
	%let &thisOutVar. = ;

 	proc sql noprint;
		select distinct v_projet_sas into :&thisOutVar. trimmed
		from &tech_sig_lib..&tech_sig_tab.(pw="&mdp_tables.")
		where deleted_at = .
		having date_creat = max(date_creat)
		;
	quit;

	%MACRO_END: /** FIN **/
%MEND getMaxVersion;
/**
Exemple :
	%getMaxVersion();
	%debugVar(APP_maxVersion);
 **/

%MACRO
	setVersion(version=AUTOINC, outVar=APP_workingVersion, autoUpdateCSV=YES, dynVarFile=) / store
	des="Permet de définir une version de projet de manière sécurisée"
;
	%if %symexist(ENV) %then %do;
		%let thisOutVar = %qsysfunc(compress(&outVar.));
		%global &thisOutVar.;
		%let &thisOutVar. = ;

		%if %upcase(&version.) eq PARAM %then %do;
			%let &thisOutVar. = &version_projet.;

			%if %upcase(&autoUpdateCSV.) eq YES %then %do;
			 	proc sql noprint;
					update myDynVar
					set
						varValue = "&version_projet."
					where varName = "version_projet"
					;
				quit;
			%end;
		%end;
		%else %if %upcase(&version.) eq AUTOINC %then %do;
			%getMaxVersion();

			%let thisOutVar = %qsysfunc(compress(&outVar.));

			data _workingVersion;
				attrib
					maxVersion length=$64 format=$64. informat=$64.
					NameVersion length=$64 format=$64. informat=$64.
					symbolVersion length=$64 format=$64. informat=$64.
					NumVersion length=$64 format=$64. informat=$64.
					NumVersionN length=8 format=8. informat=8.
					padVersion length=$7 format=$7. informat=$7.
				;

				maxVersion = "&APP_maxVersion.";

				NameVersion = prxchange("s/([a-z0-9-\s]*\s*)(v\.?\s*)([0-9]*)/\1/i", -1, maxVersion);
				symbolVersion = prxchange("s/([a-z0-9-\s]*\s*)(v\.?\s*)([0-9]*)/\2/i", -1, maxVersion);
				NumVersion = prxchange("s/([a-z0-9-\s]*\s*)(v\.?\s*)([0-9]*)/\3/i", -1, maxVersion);

				NumVersionN = sum(input(NumVersion, 8.), 1);
				padVersion = put(NumVersionN, &version_z_leading..);
			run;

			proc sql noprint;
				select trim(NameVersion)
					   || ' ' || compress(symbolVersion)
					   || compress(padVersion) into :&thisOutVar. trimmed
				from _workingVersion;
			quit;

			%if %upcase(&autoUpdateCSV.) eq YES %then %do;
			 	proc sql noprint;
					update myDynVar
					set
						varValue = (
							select trim(NameVersion)
								   || ' ' || compress(symbolVersion)
								   || compress(padVersion)
							from _workingVersion
						)
					where varName = "version_projet"
					;
				quit;
			%end;
		%end;
		%else %do;
			%let &thisOutVar. = %sysfunc(trim(&version.));

			%if %upcase(&autoUpdateCSV.) eq YES %then %do;
			 	proc sql noprint;
					update myDynVar
					set
						varValue = "&version."
					where varName = "version_projet"
					;
				quit;
			%end;
		%end;

		%if &dynVarFile. eq %then %do;
			%put2Log(
				" Aucun fichier de paramétrage est défini pour l'argument {dynVarFile} => aucun mise à jour ne sera effectué ",
				typeLog=WARNING
			);
			%goto MACRO_END;
		%end;
		%updateDynVar(%qsysfunc(dequote(&dynVarFile.)));
	%end;
	%else %do;
		%put2Log(" Merci d'importer le fichier de paramétrage contenant la définition des environnements en premier ");
	%end;

	%MACRO_END: /** FIN **/
%MEND setVersion;
/**
Exemple :
	%setVersion(
		version = PARAM,
		dynVarFile = '\\Chemin abolu\Reseau\ou\non\_PARAM_PROJET_\_000_FICHIER_PARAMETRAGE_DTM.csv'
	);
	%debugVar(APP_workingVersion);

	%setVersion(
		version = DTM V. Test 1,
		dynVarFile = '\\Chemin abolu\Reseau\ou\non\_PARAM_PROJET_\_000_FICHIER_PARAMETRAGE_DTM.csv'
	);
	%debugVar(APP_workingVersion);

	%setVersion(
		version = AUTOINC,
		dynVarFile = '\\Chemin abolu\Reseau\ou\non\_PARAM_PROJET_\_000_FICHIER_PARAMETRAGE_DTM.csv'
	);
	%debugVar(APP_workingVersion);

	%setVersion(
		dynVarFile = '\\Chemin abolu\Reseau\ou\non\_PARAM_PROJET_\_000_FICHIER_PARAMETRAGE_DTM.csv'
	);
	%debugVar(APP_workingVersion);
 **/

%MACRO
	insertIntoTableSignature(
		v_projet_SAS = "",
		nom_prg_SAS = "",
		sig_DEV = "",
		sig_QUAL = "",
		sig_PROD = "",

		tot_err_DEV = .,
		tot_warn_DEV = .,
		tot_trap_note_DEV = .,
		tot_err_app_DEV = .,
		tot_warn_app_DEV = .,

		tot_err_QUAL = .,
		tot_warn_QUAL = .,
		tot_trap_note_QUAL = .,
		tot_err_app_QUAL = .,
		tot_warn_app_QUAL = .,

		tot_err_PROD = .,
		tot_warn_PROD = .,
		tot_trap_note_PROD = .,
		tot_err_app_PROD = .,
		tot_warn_app_PROD = .,

		comment = "",
		date_modif = datetime(),
		date_creat = datetime(),
		deleted_at = .
	) / store
	des="Permet d'écrire dans la table des signatures digitales des programmes SAS"
;
	%isPreRequesiteOK();
	%if &APP_isPreReqOK. = 0 %then %do;
		%goto MACRO_END;
	%end;

	%if &v_projet_SAS. eq or &v_projet_SAS. eq "" %then %do;
		%if &version_projet. eq or &version_projet. eq "" %then %do;
			%put2Log(" [Environnement : %getEnv()]::La version du projet SAS ne doit pas être vide, merci de renseigner {v_projet_SAS} ou le fichier de paramétrage ");
			%goto MACRO_END;
		%end;
	%end;

	%if &nom_prg_SAS. eq or &nom_prg_SAS. eq "" %then %do;
		%put2Log(" [Environnement : %getEnv()]::Le nom du programme SAS ne doit pas être vide, merci de renseigner {nom_prg_SAS} ");
		%goto MACRO_END;
	%end;

	%let this_v_projet_SAS_TMP = %qsysfunc(dequote(&v_projet_SAS.));
	%if &this_v_projet_SAS_TMP. ne %then %do;
		%let this_v_projet_SAS = &this_v_projet_SAS_TMP.;
	%end;
	%else %do;
		%let this_v_projet_SAS = %qsysfunc(dequote(&version_projet.));;
	%end;

	%let this_nom_prg_SAS = %qsysfunc(dequote(&nom_prg_SAS.));

	%let APP_isExist = 0;
	proc sql noprint;
		select count(1) as NB, deleted_at into :APP_isExist, :APP_del_at
		from &tech_sig_lib..&tech_sig_tab.(pw="&mdp_tables.")
		where v_projet_SAS = "&this_v_projet_SAS." 
			  and nom_prg_SAS = "&this_nom_prg_SAS."
			  and deleted_at ^= .
		;
	quit;

	%if &APP_isExist. > 0 %then %do;
		%put2Log(" [Environnement : %getEnv()]::L'enregistrement existe déjà pour le couple (&this_v_projet_SAS./&this_nom_prg_SAS.) ");
		%put2Log(" mais a été marqué comme supprimé le &APP_del_at. - veuillez faire un ROLLBACK sur cet enregistrement d'abord... ");
		%goto MACRO_END;
	%end;

	%let APP_isExist = 0;
	proc sql noprint;
		select count(1) as NB, cats('"', comment, '"') into :APP_isExist, :APP_oldComments
		from &tech_sig_lib..&tech_sig_tab.(pw="&mdp_tables.")
		where v_projet_SAS = "&this_v_projet_SAS." 
			  and nom_prg_SAS = "&this_nom_prg_SAS."
			  and deleted_at = .
		;
	quit;

	%let this_comment_TMP = %qsysfunc(dequote(&comment.));
	%if &this_comment_TMP. ne %then %do;
		%let this_comment = &this_comment_TMP.;
	%end;
	%else %do;
		%let this_comment = %qsysfunc(dequote(&APP_oldComments.));
	%end;

	%if &APP_isExist. > 0 %then %do;
		%put2Log(
			" [Environnement : %getEnv()]::L'enregistrement existe déjà pour le couple (&this_v_projet_SAS./&this_nom_prg_SAS.) ; une mise à jour sera appliquée... ",
			typeLog = NOTE/*WARNING*/
		);

	 	proc sql noprint;
			update &tech_sig_lib..&tech_sig_tab.(pw="&mdp_tables.")
			set
				%if %getEnv() eq DEV %then %do;
					sig_DEV = &sig_DEV.,
					tot_err_DEV = &tot_err_DEV.,
					tot_warn_DEV = &tot_warn_DEV.,
					tot_trap_note_DEV = &tot_trap_note_DEV.,
					tot_err_app_DEV = &tot_err_app_DEV.,
					tot_warn_app_DEV = &tot_warn_app_DEV.,
				%end;
				%else %if %getEnv() eq QUAL %then %do;
					sig_QUAL = &sig_QUAL.,
					tot_err_QUAL = &tot_err_QUAL.,
					tot_warn_QUAL = &tot_warn_QUAL.,
					tot_trap_note_QUAL = &tot_trap_note_QUAL.,
					tot_err_app_QUAL = &tot_err_app_QUAL.,
					tot_warn_app_QUAL = &tot_warn_app_QUAL.,
				%end;
				%else %if %getEnv() eq PROD %then %do;
					sig_PROD = &sig_PROD.,
					tot_err_PROD = &tot_err_PROD.,
					tot_warn_PROD = &tot_warn_PROD.,
					tot_trap_note_PROD = &tot_trap_note_PROD.,
					tot_err_app_PROD = &tot_err_app_PROD.,
					tot_warn_app_PROD = &tot_warn_app_PROD.,
				%end;

				comment = "&this_comment.",
				date_modif = datetime()
			where v_projet_SAS = "&this_v_projet_SAS."
				  and nom_prg_SAS = "&this_nom_prg_SAS."
				  and deleted_at = .
			;
		quit;

		%goto MACRO_END;
	%end;
	%else %do;
		%put2Log(
			" [Environnement : %getEnv()]::Nouvel enregistrement dans la table des signatures ajouté avec succes ",
			typeLog = NOTE
		);

	 	proc sql noprint;
			insert into &tech_sig_lib..&tech_sig_tab.(pw="&mdp_tables.")
			set
				v_projet_SAS = "&this_v_projet_SAS.",
				nom_prg_SAS = "&this_nom_prg_SAS.",
				sig_DEV = &sig_DEV.,
				sig_QUAL = &sig_QUAL.,
				sig_PROD = &sig_PROD.,

				tot_err_DEV = &tot_err_DEV.,
				tot_warn_DEV = &tot_warn_DEV.,
				tot_trap_note_DEV = &tot_trap_note_DEV.,
				tot_err_app_DEV = &tot_err_app_DEV.,
				tot_warn_app_DEV = &tot_warn_app_DEV.,

				tot_err_QUAL = &tot_err_QUAL.,
				tot_warn_QUAL = &tot_warn_QUAL.,
				tot_trap_note_QUAL = &tot_trap_note_QUAL.,
				tot_err_app_QUAL = &tot_err_app_QUAL.,
				tot_warn_app_QUAL = &tot_warn_app_QUAL.,

				tot_err_PROD = &tot_err_PROD.,
				tot_warn_PROD = &tot_warn_PROD.,
				tot_trap_note_PROD = &tot_trap_note_PROD.,
				tot_err_app_PROD = &tot_err_app_PROD.,
				tot_warn_app_PROD = &tot_warn_app_PROD.,

				comment = "&this_comment.",
				date_modif = &date_modif.,
				date_creat = &date_creat.,
				deleted_at = .
			;
		quit;

		%goto MACRO_END;
	%end;

	%MACRO_END: /** FIN **/
%MEND insertIntoTableSignature;
/**
Exemple :
	%insertIntoTableSignature(
		v_projet_SAS = "V-Test-1.0",
		nom_prg_SAS = "mon programme.SAS",
		comment = "Ceci est une version d'initialisation TEST MAJ après ROLLBACK"
	);

	%insertIntoTableSignature(
		v_projet_SAS = "V-Test-1.0",
		nom_prg_SAS = "mon programme.SAS"
	);

	%insertIntoTableSignature(
		nom_prg_SAS = "mon programme.SAS",
		comment = "Ceci est une version d'initialisation TEST",
		sig_DEV = "XXXXXXXX_%getTimeStamp()",
		tot_err_DEV = .,
		tot_warn_DEV = 0,
		tot_trap_note_DEV = 1,
		tot_err_app_DEV = 2,
		tot_warn_app_DEV = 3
	);
 **/

%MACRO
	deleteDataFromTableSignature(
		v_projet_SAS = "",
		nom_prg_SAS = "",
		rollBack = NO
	) / store
	des="Permet de supprimer ou rappeler une suppression de la table des signatures digitales des programmes SAS"
;
	%isPreRequesiteOK();
	%if &APP_isPreReqOK. = 0 %then %do;
		%goto MACRO_END;
	%end;

	%if &v_projet_SAS. eq or &v_projet_SAS. eq "" %then %do;
		%if &version_projet. eq or &version_projet. eq "" %then %do;
			%put2Log(" [Environnement : %getEnv()]::La version du projet SAS ne doit pas être vide, merci de renseigner {v_projet_SAS} ou le fichier de paramétrage ");
			%goto MACRO_END;
		%end;
	%end;

	%if &nom_prg_SAS. eq or &nom_prg_SAS. eq "" %then %do;
		%put2Log(" [Environnement : %getEnv()]::Le nom du programme SAS ne doit pas être vide, merci de renseigner {nom_prg_SAS} ");
		%goto MACRO_END;
	%end;

	%let this_v_projet_SAS_TMP = %qsysfunc(dequote(&v_projet_SAS.));
	%if &this_v_projet_SAS_TMP. ne %then %do;
		%let this_v_projet_SAS = &this_v_projet_SAS_TMP.;
	%end;
	%else %do;
		%let this_v_projet_SAS = %qsysfunc(dequote(&version_projet.));;
	%end;

	%let this_nom_prg_SAS = %qsysfunc(dequote(&nom_prg_SAS.));

	%let APP_isExist = 0;
	proc sql noprint;
		select count(1) as NB into :APP_isExist
		from &tech_sig_lib..&tech_sig_tab.(pw="&mdp_tables.")
		where v_projet_SAS = "&this_v_projet_SAS." 
			  and nom_prg_SAS = "&this_nom_prg_SAS."
			%if %upcase(&rollBack.) eq YES %then %do;
				and deleted_at ^= .
			%end;
			%else %do;
				and deleted_at = .
			%end;
		;
	quit;

	%if &APP_isExist. > 0 %then %do;
		%if %upcase(&rollBack.) eq YES %then %do;
		 	proc sql noprint;
				update &tech_sig_lib..&tech_sig_tab.(pw="&mdp_tables.")
				set
					date_modif = datetime(),
					deleted_at = .
				where v_projet_SAS = "&this_v_projet_SAS."
					  and nom_prg_SAS = "&this_nom_prg_SAS."
					  and deleted_at ^= .
				;
			quit;

			%put2Log(
				" [Environnement : %getEnv()]::La suppression abstraite du couple (&this_v_projet_SAS./&this_nom_prg_SAS.) a bien été restaurée dans la table des signatures ",
				typeLog = NOTE
			);
		%end;
		%else %do;
		 	proc sql noprint;
				update &tech_sig_lib..&tech_sig_tab.(pw="&mdp_tables.")
				set
					date_modif = datetime(),
					deleted_at = datetime()
				where v_projet_SAS = "&this_v_projet_SAS."
					  and nom_prg_SAS = "&this_nom_prg_SAS."
					  and deleted_at = .
				;
			quit;

			%put2Log(
				" [Environnement : %getEnv()]::La suppression abstraite du couple (&this_v_projet_SAS./&this_nom_prg_SAS.) a bien été appliquée dans la table des signatures ",
				typeLog = NOTE
			);
		%end;

		%goto MACRO_END;
	%end;
	%else %do;
		%put2Log(" [Environnement : %getEnv()]::Le couple (&this_v_projet_SAS./&this_nom_prg_SAS.) n'existe pas ");
		%put;
		%goto MACRO_END;
	%end;

	%MACRO_END: /** FIN **/
%MEND deleteDataFromTableSignature;
/**
Exemple :
	%deleteDataFromTableSignature(
		v_projet_SAS = "V-Test-1.0",
		nom_prg_SAS = "mon programme.SAS"
	);

	%deleteDataFromTableSignature(
		v_projet_SAS = "V-Test-1.0",
		nom_prg_SAS = "mon programme.SAS",
		rollBack = YES
	);
 **/

%MACRO
	addNewPrg2TSignature(
		nomProgrammeSAS,
		versionProjet = PARAM,
		commentaires = ""
	) / store
	des="Permet de calculer la signature d'un programme SAS et de suivre son évolution d'un environnement à l'autre"
;
	%MACRO thisHelp();
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%addNewPrg2TSignature());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet de calculer la signature d%str(%')un programme SAS et de suivre son évolution d%str(%')un environnement à l%str(%')autre;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%checkPrgLog2TSignature(&nomProgrammeSAS.<, &versionProjet.<, &commentaires.>>));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > nomProgrammeSAS (obligatoire) : nom du programme SAS (avec chemin absolu);
		%put NOTE:--[HELP]--       > versionProjet (optionnel) : nom de version du projet en cours;
		%put NOTE:--[HELP]--       >                             une version embarque plusieurs programmes, uniques, ayant pour objectif commun de répondre à un besoin fonctionnel;
		%put NOTE:--[HELP]--       >                             par défaut, le programme prendra la version renseignée dans le fichier de paramétrage _000_FICHIER_PARAMETRAGE_DTM.csv;
		%put NOTE:--[HELP]--       >                             il est possible d%str(%')écraser cette version en spécifiant une valeur propre (déconseillé, car risque de perte d%str(%')intégrité global);
		%put NOTE:--[HELP]--       > commentaires (optionnel) : commentaires...;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > créer une nouvelle entrée dans la table des signature avec la clé numérique du programme SAS;
	%MEND thisHelp;

	%if &nomProgrammeSAS. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &nomProgrammeSAS. eq or &nomProgrammeSAS. eq "" %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%isPreRequesiteOK();
			%if &APP_isPreReqOK. = 0 %then %do;
				%goto MACRO_END;
			%end;

			%if %isFile(&nomProgrammeSAS.) = 0 %then %do;
				%put2Log(" [Environnement : %getEnv()]::Le programme SAS transmis en argument n'existe pas, veuillez vérifier son orthographe/chemin ");
				%put2Log(&nomProgrammeSAS.);
				%goto MACRO_END;
			%end;

			%let myFileTMP = %qsysfunc(dequote(&nomProgrammeSAS.));

			%let isUnix = %isUnixPath(&myFileTMP.);

			%let slashC = \;
			%if &isUnix. eq 1 %then %do;
				%let slashC = /;
			%end;

			%let thisSASPrgName = %qsysfunc(scan("&myFileTMP.", -1, "&slashC."));
			%let path2Save = %qsysfunc(substr(&myFileTMP., 1, %sysfunc(find(&myFileTMP., &thisSASPrgName.))-2));

			%setDigitalSignature(&nomProgrammeSAS.);
			%let dSigSHA = %getDigitalSignature();

			proc datasets library=WORK memtype=data nolist nodetails;
				delete hashFileTMP hashSignature;
			quit;

			%let thisCommentaires = %qsysfunc(dequote(&commentaires.));
			%let thisVersionProjet = %qsysfunc(dequote(&versionProjet.));

			%insertIntoTableSignature(
				%if %upcase(&versionProjet.) ne PARAM %then %do;
					v_projet_SAS = "&thisVersionProjet.",
				%end;

				nom_prg_SAS = "&thisSASPrgName.",
				comment = "&thisCommentaires.",

				%if %getEnv() eq DEV %then %do;
					sig_DEV = "&dSigSHA."
				%end;
				%else %if %getEnv() eq QUAL %then %do;
					sig_QUAL = "&dSigSHA."
				%end;
				%else %if %getEnv() eq PROD %then %do;
					sig_PROD = "&dSigSHA."
				%end;
			);
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%thisHelp();
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put2Log(" [Environnement : %getEnv()]::Vous avez apppelé la macro %nrstr(%addNewPrg2TSignature()) sans argument ou avec un argument vide, veuillez consulter l'aide ci-dessous ");

			%thisHelp();
		%end;

	%MACRO_END: /** FIN **/
		/*data _null_; stop; run;*/
%MEND addNewPrg2TSignature;
/**
Exemple :
	%addNewPrg2TSignature(?);

	%addNewPrg2TSignature(
		nomProgrammeSAS = "&path_libraries.\00_LIB_Macros_Communes.sas",
		versionProjet = PARAM,
		commentaires = "T'vois pas que je teste?! RAH!!!"
	);

	%addNewPrg2TSignature(nomProgrammeSAS = "&path_libraries.\00_LIB_Macros_Communes.sas");
 **/

%MACRO
	addNewPrg2TSignatureFromFile(
		versionProjet = PARAM,
		commentaires = "",
		updateListOfSASPrg = YES
	) / store
	des="Permet d'initialiser table des signatures avec une liste de programmes SAS définis dans un fichier de paramétrage"
;
	%if %symexist(ENV) %then %do;
		%if %upcase(&updateListOfSASPrg.) eq YES %then %do;
			%scanFolder4SASFile();
		%end;

		%importFlatFile("&path_param.\&name_prg_list_param..sasdesc");

		%let isTab = %isTable(L_PRG_SAS);

		%if &isTab. = 1 %then %do;
			%let thisCommentaires = %qsysfunc(dequote(&commentaires.));
			%let thisVersionProjet = %qsysfunc(dequote(&versionProjet.));

			proc sql noprint;
				select SAS_program into :lSASPrg separated by '_'
				from L_PRG_SAS
				;
			quit;

			data _null_;
				set L_PRG_SAS;

	/*			call execute('%addNewPrg2TSignature(nomProgrammeSAS = "' || trim(left(SAS_program)) || '");');*/
				call symput(cats('prg_', _N_), cats('"', trim(left(SAS_program)), '"'));
				call symput('APP_max2Loop', _N_);
			run;

			%do i=1 %to &APP_max2Loop.;
				%addNewPrg2TSignature(
					nomProgrammeSAS = &&prg_&i.,
					versionProjet = &thisVersionProjet.,
					commentaires = "&thisCommentaires."
				);
			%end;

			%goto MACRO_END;
		%end;

		%put2Log(" [Environnement : %getEnv()]::La table L_PRG_SAS n'existe pas, merci de vérifier sa création... ");
	%end;
	%else %do;
		%put2Log(" Merci d'importer le fichier de paramétrage contenant la définition des environnements en premier ");
	%end;

	%MACRO_END: /** FIN **/
%MEND addNewPrg2TSignatureFromFile;
/**
Exemple :
	%addNewPrg2TSignatureFromFile(
		versionProjet = INIT,
		commentaires = "Version Initiale du Projet"
	);
 **/

%MACRO
	checkPrgLog2TSignature(
		nomProgrammeSAS,
		nomProgrammeLOG,
		versionProjet = PARAM,
		commentaires = ""
	) / store
	des="Permet de compatibiliser les erreurs et alertes présents dans le fichier LOGS des programmes SAS avec recalcul de la signature"
;
	%MACRO thisHelp();
		%put ERROR:--[HELP]--   • NOM MACRO :;
		%put ERROR:--[HELP]--      %nrstr(%checkPrgLog2TSignature());
		%put WARNING:--[HELP]-- • DESCRIPTION :;
		%put NOTE:--[HELP]--       Permet de compatibiliser les erreurs et alertes présents dans le fichier LOGS des programmes SAS avec recalcul de la signature;
		%put WARNING:--[HELP]-- • SYNTAXE :;
		%put NOTE:--[HELP]--       %nrstr(%checkPrgLog2TSignature(&nomProgrammeSAS., &nomProgrammeSAS.<, &versionProjet.<, &commentaires.>>));
		%put WARNING:--[HELP]-- • ARGUMENT(S) :;
		%put NOTE:--[HELP]--       > nomProgrammeSAS (obligatoire) : nom du programme SAS (avec chemin absolu);
		%put NOTE:--[HELP]--       > nomProgrammeLOG (obligatoire) : nom de la LOG du programme SAS (avec chemin absolu);
		%put NOTE:--[HELP]--       > versionProjet (optionnel) : nom de version du projet en cours;
		%put NOTE:--[HELP]--       >                             une version embarque plusieurs programmes, uniques, ayant pour objectif commun de répondre à un besoin fonctionnel;
		%put NOTE:--[HELP]--       >                             par défaut, le programme prendra la version renseignée dans le fichier de paramétrage _000_FICHIER_PARAMETRAGE_DTM.csv;
		%put NOTE:--[HELP]--       >                             il est possible d%str(%')écraser cette version en spécifiant une valeur propre (déconseillé, car risque de perte d%str(%')intégrité global);
		%put NOTE:--[HELP]--       > commentaires (optionnel) : commentaires...;
		%put WARNING:--[HELP]-- • RETOUR(S) :;
		%put NOTE:--[HELP]--       > enrichi la table des signatures avec les nouvelles informations;
	%MEND thisHelp;

	%if &nomProgrammeSAS. eq ? %then %do;
		%let errHandler = 'HELP';
		%goto ERR_HANDLER;
	%end;
	%else %if &nomProgrammeSAS. eq or &nomProgrammeLOG. eq %then %do;
		%let errHandler = 'BLANK';
		%goto ERR_HANDLER;
	%end;
	%else %do;
		%let errHandler = 'OK';
		%goto ERR_HANDLER;
	%end;

	%ERR_HANDLER:
		%if &errHandler. = 'OK' %then %do;
			%isPreRequesiteOK();
			%if &APP_isPreReqOK. = 0 %then %do;
				%goto MACRO_END;
			%end;

			%if %isFile(&nomProgrammeSAS.) = 0 %then %do;
				%put2Log(" [Environnement : %getEnv()]::Le programme SAS transmis en argument n'existe pas, veuillez vérifier son orthographe/chemin ");
				%put2Log(&nomProgrammeSAS.);
				%goto MACRO_END;
			%end;

			%if %isFile(&nomProgrammeLOG.) = 0 %then %do;
				%put2Log(" [Environnement : %getEnv()]::La log SAS transmise en argument n'existe pas, veuillez vérifier son orthographe/chemin ");
				%put2Log(&nomProgrammeLOG.);
				%goto MACRO_END;
			%end;

			%let thisCommentaires = %qsysfunc(dequote(&commentaires.));
			%let thisVersionProjet = %qsysfunc(dequote(&versionProjet.));

			%let myFileTMP = %qsysfunc(dequote(&nomProgrammeSAS.));

			%let isUnix = %isUnixPath(&myFileTMP.);

			%let slashC = \;
			%if &isUnix. eq 1 %then %do;
				%let slashC = /;
			%end;

			%let thisSASPrgName = %qsysfunc(scan("&myFileTMP.", -1, "&slashC."));
			%let path2Save = %qsysfunc(substr(&myFileTMP., 1, %sysfunc(find(&myFileTMP., &thisSASPrgName.))-2));

			%let thisFullLog = %qsysfunc(dequote(&nomProgrammeLOG.));
			%let thisSASLogName = %qsysfunc(scan("&thisFullLog.", -1, "&slashC."));

			%let thisSASPrgNameNoExt = %qsysfunc(scan("&thisSASPrgName.", -2, "."));
			%if %sysfunc(find(&thisSASLogName., &thisSASPrgNameNoExt.)) <= 0 %then %do;
				%put2Log(
					" [Environnement : %getEnv()]::Le nom de la log ne contient pas de référence au nom du programme SAS; ce n'est peut-être pas le bon ",
					typeLog=WARNING
				);
				%put2Log(" nom de la log : &thisSASLogName. ", typeLog=WARNING);
				%put2Log(" nom du programme : &thisSASPrgName. ", typeLog=WARNING);
			%end;

			%if %upcase(&thisVersionProjet.) eq PARAM %then %do;
				%let APP_version2Check = &version_projet.;
			%end;
			%else %do;
				%let APP_version2Check = &thisVersionProjet.;
			%end;

			%let APP_isExist = 0;
			proc sql noprint;
				select count(1) as NB into :APP_isExist
				from &tech_sig_lib..&tech_sig_tab.(pw="&mdp_tables.")
				where v_projet_SAS = "&APP_version2Check."
					  and nom_prg_SAS = "&thisSASPrgName."
					  and deleted_at = .
				;
			quit;

			%if &APP_isExist. < 1 %then %do;
				%put2Log(" [Environnement : %getEnv()]::Le couple (&thisSASPrgName./&APP_version2Check.) n'existe pas dans la table des signatures, merci de vérifier la saisie ");
				%goto MACRO_END;
			%end;

			%setDigitalSignature(&nomProgrammeSAS.);
			%let dSigSHA = %getDigitalSignature();

			proc datasets library=WORK memtype=data nolist nodetails;
				delete hashFileTMP hashSignature;
			quit;

			%let APP_SAS_ERRORS = 0;
			%let APP_SAS_WARNINGS = 0;
			%let APP_SAS_NOTES = 0;
			%let APP_SAS_TRAPPED_NOTE = 0;
			%let APP_DEV_ERRORS = 0;
			%let APP_DEV_WARNINGS = 0;
			%let APP_DEV_NOTES = 0;

			%logParser(&thisFullLog.);
			proc sql noprint; 
				select NB into:APP_SAS_ERRORS from myLogSynthesis where type = 1;
				select NB into:APP_SAS_WARNINGS  from myLogSynthesis where type = 2;
/*				select NB into:APP_SAS_NOTES from myLogSynthesis where type = 3;*/
				select NB into:APP_SAS_TRAPPED_NOTE from myLogSynthesis where type in (4, 5);
				select NB into:APP_DEV_ERRORS from myLogSynthesis where type = 6;
				select NB into:APP_DEV_WARNINGS  from myLogSynthesis where type = 7;
/*				select NB into:APP_DEV_NOTES from myLogSynthesis where type = 8;*/
			quit;

			%let thisEnv = %getEnv();
			
			%insertIntoTableSignature(
				%if %upcase(&thisVersionProjet.) ne PARAM %then %do;
					v_projet_SAS = "&thisVersionProjet.",
				%end;

				nom_prg_SAS = "&thisSASPrgName.",
				comment = "&thisCommentaires.",
				%if &thisEnv. eq DEV %then %do;
					sig_DEV = "&dSigSHA.",
					tot_err_DEV = &APP_SAS_ERRORS.,
					tot_warn_DEV = &APP_SAS_WARNINGS.,
					tot_trap_note_DEV = &APP_SAS_TRAPPED_NOTE.,
					tot_err_app_DEV = &APP_DEV_ERRORS.,
					tot_warn_app_DEV = &APP_DEV_WARNINGS.
				%end;
				%else %if &thisEnv. eq QUAL %then %do;
					sig_QUAL = "&dSigSHA.",
					tot_err_QUAL = &APP_SAS_ERRORS.,
					tot_warn_QUAL = &APP_SAS_WARNINGS.,
					tot_trap_note_QUAL = &APP_SAS_TRAPPED_NOTE.,
					tot_err_app_QUAL = &APP_DEV_ERRORS.,
					tot_warn_app_QUAL = &APP_DEV_WARNINGS.
				%end;
				%else %if &thisEnv. eq PROD %then %do;
					sig_PROD = "&dSigSHA.",
					tot_err_PROD = &APP_SAS_ERRORS.,
					tot_warn_PROD = &APP_SAS_WARNINGS.,
					tot_trap_note_PROD = &APP_SAS_TRAPPED_NOTE.,
					tot_err_app_PROD = &APP_DEV_ERRORS.,
					tot_warn_app_PROD = &APP_DEV_WARNINGS.
				%end;
			);

			%if %sysfunc(strip(&APP_SAS_ERRORS.)) > 0 %then %do;
				%let TLOGERR_SAS = ERROR;
			%end;
			%else %do;
				%let TLOGERR_SAS = NOTE;
			%end;

			%if %sysfunc(strip(&APP_SAS_WARNINGS.)) > 0 %then %do;
				%let TLOGWARN_SAS = WARNING;
			%end;
			%else %do;
				%let TLOGWARN_SAS = NOTE;
			%end;

			%if %sysfunc(strip(&APP_SAS_TRAPPED_NOTE.)) > 0 %then %do;
				%let TLOGTRAP_SAS = WARNING;
			%end;
			%else %do;
				%let TLOGTRAP_SAS = NOTE;
			%end;

			%if %sysfunc(strip(&APP_DEV_ERRORS.)) > 0 %then %do;
				%let TLOGERR_APP = ERROR;
			%end;
			%else %do;
				%let TLOGERR_APP = NOTE;
			%end;

			%if %sysfunc(strip(&APP_DEV_WARNINGS.)) > 0 %then %do;
				%let TLOGWARN_APP = WARNING;
			%end;
			%else %do;
				%let TLOGWARN_APP = NOTE;
			%end;

			%put2Log(
				" [Environnement : %getEnv()]::Synthèse des LOGS pour le couple (&thisSASPrgName./&APP_version2Check.) : ",
				typeLog = NOTE
			);
			%put2Log(" -[LOG SAS]- ", typeLog = NOTE);
			%put2Log(" TOTAL ERREURS : %sysfunc(strip(&APP_SAS_ERRORS.)) ", typeLog = &TLOGERR_SAS.);
			%put2Log(" TOTAL ALERTES : %sysfunc(strip(&APP_SAS_WARNINGS.)) ", typeLog = &TLOGWARN_SAS.);
			%put2Log(" TOTAL NOTES A SURVEILLER : %sysfunc(strip(&APP_SAS_TRAPPED_NOTE.)) ", typeLog = &TLOGTRAP_SAS.);
			%put2Log(" -[LOG APPLICATION]- ", typeLog = NOTE);
			%put2Log(" TOTAL ERREURS : %sysfunc(strip(&APP_DEV_ERRORS.)) ", typeLog = &TLOGERR_APP.);
			%put2Log(" TOTAL ALERTES : %sysfunc(strip(&APP_DEV_WARNINGS.)) ", typeLog = &TLOGWARN_APP.);
			%put;
		%end;
		%else %if &errHandler. = 'HELP' %then %do;
			%thisHelp();
		%end;
		%else %if &errHandler. = 'BLANK' %then %do;
			%put2Log(" [Environnement : %getEnv()]::Vous avez apppelé la macro %nrstr(%checkPrgLog2TSignature()) sans argument ou avec un argument vide, veuillez consulter l'aide ci-dessous ");

			%thisHelp();
		%end;

	%MACRO_END: /** FIN **/
		/*data _null_; stop; run;*/
%MEND checkPrgLog2TSignature;
/**
Exemple :
	%checkPrgLog2TSignature(?);
	%checkPrgLog2TSignature();

	%checkPrgLog2TSignature(
		nomProgrammeSAS = "&path_libraries.\00_LIB_Macros_Communes.sas",
		nomProgrammeLOG = "&path_log_fw.\000_T_GESTION_ENVIRONNEMENT_000_PARAMETRAGES_27NOV2018_151236.LOG",
		versionProjet = PARAM,
		commentaires = "test insertion erreurs logs"
	);

	%checkPrgLog2TSignature(
		nomProgrammeSAS = "&path_libraries.\00_LIB_Macros_Communes.sas",
		nomProgrammeLOG = "&path_log_fw.\000_T_GESTION_ENVIRONNEMENT_000_PARAMETRAGES_30NOV2018_102215.LOG",
		versionProjet = PARAM,
		commentaires = "test MAJ en QUALIF de la version V. INIT avec une nouvelle log"
	);
 **/

%MACRO
	countErrFromTableSignature(version=PARAM, scope=ALL, outVar=APP_totalErrSASPerVersion) / store
	des="Permet de récupérer le total Erreurs d'un environnement donné (par version), le scope vaut ALL, SAS ou APP"
;
	%if &version. eq %then %do;
		%put2Log(" [Environnement : %getEnv()]::La version à vérifier ne doit pas être vide ");
		%goto MACRO_END;
	%end;

	%if %upcase(&scope.) ne ALL and %upcase(&scope.) ne SAS and %upcase(&scope.) ne APP %then %do;
		%put2Log(" [Environnement : %getEnv()]::Le scope saisi est inconnu ; doit être ALL (par défaut), SAS ou APP ");
		%goto MACRO_END;
	%end;

	%isPreRequesiteOK();
	%if &APP_isPreReqOK. = 0 %then %do;
		%goto MACRO_END;
	%end;

	%let thisVersion = %qsysfunc(dequote(&version.));

	%if %upcase(&thisVersion.) eq PARAM %then %do;
		%let APP_version2Check = &version_projet.;
	%end;
	%else %do;
		%let APP_version2Check = &thisVersion.;
	%end;

	%let thisOutVar = %qsysfunc(compress(&outVar.));
	%global &thisOutVar.;
	%let &thisOutVar. = 0;
 	proc sql noprint;
		select sum(
			%if %getEnv() eq DEV %then %do;
				%if %upcase(&scope.) eq ALL %then %do;
					sum(tot_err_DEV), sum(tot_err_app_DEV)
				%end;
				%else %if %upcase(&scope.) eq SAS %then %do;
					tot_err_DEV
				%end;
				%else %if %upcase(&scope.) eq APP %then %do;
					tot_err_app_DEV
				%end;
			%end;
			%else %if %getEnv() eq QUAL %then %do;
				%if %upcase(&scope.) eq ALL %then %do;
					sum(tot_err_QUAL), sum(tot_err_app_QUAL)
				%end;
				%else %if %upcase(&scope.) eq SAS %then %do;
					tot_err_QUAL
				%end;
				%else %if %upcase(&scope.) eq APP %then %do;
					tot_err_app_QUAL
				%end;
			%end;
			%else %if %getEnv() eq PROD %then %do;
				%if %upcase(&scope.) eq ALL %then %do;
					sum(tot_err_PROD), sum(tot_err_app_PROD)
				%end;
				%else %if %upcase(&scope.) eq SAS %then %do;
					tot_err_PROD
				%end;
				%else %if %upcase(&scope.) eq APP %then %do;
					tot_err_app_PROD
				%end;
			%end;
			) into :&thisOutVar. trimmed
		from &tech_sig_lib..&tech_sig_tab.(pw="&mdp_tables.")
		where v_projet_SAS = "&APP_version2Check.";
	quit;

	%MACRO_END: /** FIN **/
%MEND countErrFromTableSignature;
/**
Exemple :
	%countErrFromTableSignature(scope=ALL, outVar=ERRS_ALL);
	%put2Log(" [Environnement : %getEnv()]::Le total des erreurs est &ERRS_ALL. ");
	%test(&ERRS_ALL.);

	%countErrFromTableSignature(scope=SAS, outVar=ERRS_SAS);
	%put2Log(" [Environnement : %getEnv()]::Le total des erreurs SAS est &ERRS_SAS. ");
	%test(&ERRS_SAS.);

	%countErrFromTableSignature(scope=APP, outVar=ERRS_APP);
	%put2Log(" [Environnement : %getEnv()]::Le total des erreurs APP est &ERRS_APP. ");
	%test(&ERRS_APP.);

%macro test(x);
	%if &x. = . %then %do;
		%put2Log(" Vide ", typeLog = NOTE);
	%end;
	%else %do;
		%put2Log(" Non vide et vaut &X. ", typeLog = NOTE);
	%end;
%mend;
 **/

%MACRO
	countWarningFromTableSignature(version=PARAM, scope=ALL, outVar=APP_totalErrSASPerVersion) / store
	des="Permet de récupérer le total Warnings d'un environnement donné (par version), le scope vaut ALL, SAS ou APP"
;
	%if &version. eq %then %do;
		%put2Log(" [Environnement : %getEnv()]::La version à vérifier ne doit pas être vide ");
		%goto MACRO_END;
	%end;

	%if %upcase(&scope.) ne ALL and %upcase(&scope.) ne SAS and %upcase(&scope.) ne APP %then %do;
		%put2Log(" [Environnement : %getEnv()]::Le scope saisi est inconnu ; doit être ALL (par défaut), SAS ou APP ");
		%goto MACRO_END;
	%end;

	%isPreRequesiteOK();
	%if &APP_isPreReqOK. = 0 %then %do;
		%goto MACRO_END;
	%end;

	%let thisVersion = %qsysfunc(dequote(&version.));

	%if %upcase(&thisVersion.) eq PARAM %then %do;
		%let APP_version2Check = &version_projet.;
	%end;
	%else %do;
		%let APP_version2Check = &thisVersion.;
	%end;

	%let thisOutVar = %qsysfunc(compress(&outVar.));
	%global &thisOutVar.;
	%let &thisOutVar. = 0;
 	proc sql noprint;
		select sum(
			%if %getEnv() eq DEV %then %do;
				%if %upcase(&scope.) eq ALL %then %do;
					sum(tot_warn_DEV), sum(tot_warn_app_DEV)
				%end;
				%else %if %upcase(&scope.) eq SAS %then %do;
					tot_warn_DEV
				%end;
				%else %if %upcase(&scope.) eq APP %then %do;
					tot_warn_app_DEV
				%end;
			%end;
			%else %if %getEnv() eq QUAL %then %do;
				%if %upcase(&scope.) eq ALL %then %do;
					sum(tot_warn_QUAL), sum(tot_warn_app_QUAL)
				%end;
				%else %if %upcase(&scope.) eq SAS %then %do;
					tot_warn_QUAL
				%end;
				%else %if %upcase(&scope.) eq APP %then %do;
					tot_warn_app_QUAL
				%end;
			%end;
			%else %if %getEnv() eq PROD %then %do;
				%if %upcase(&scope.) eq ALL %then %do;
					sum(tot_warn_PROD), sum(tot_warn_app_PROD)
				%end;
				%else %if %upcase(&scope.) eq SAS %then %do;
					tot_warn_PROD
				%end;
				%else %if %upcase(&scope.) eq APP %then %do;
					tot_warn_app_PROD
				%end;
			%end;
			) into :&thisOutVar. trimmed
		from &tech_sig_lib..&tech_sig_tab.(pw="&mdp_tables.")
		where v_projet_SAS = "&APP_version2Check.";
	quit;

	%MACRO_END: /** FIN **/
%MEND countWarningFromTableSignature;
/**
Exemple :
	%countWarningFromTableSignature(scope=ALL, outVar=WARNS_ALL);
	%put2Log(" [Environnement : %getEnv()]::Le total des alertes est &WARNS_ALL. ");

	%countWarningFromTableSignature(scope=SAS, outVar=WARNS_SAS);
	%put2Log(" [Environnement : %getEnv()]::Le total des alertes SAS est &WARNS_SAS. ");

	%countWarningFromTableSignature(scope=APP, outVar=WARNS_APP);
	%put2Log(" [Environnement : %getEnv()]::Le total des alertes APP est &WARNS_APP. ");
 **/

%MACRO
	isVersionFullParsed(outVar=APP_hasErrors, version2Check=PARAM) / store
	des="Permet de savoir si tous les programmes d'une version a été passé au analyseur de log avant le déploiement (le retour doit être à 0 autrement il y a un problème...)"
;
	%isPreRequesiteOK();
	%if &APP_isPreReqOK. = 0 %then %do;
		%goto MACRO_END;
	%end;

	%let thisVersion2Check = &version_projet.;
	%if %upcase(&version2Check.) ne PARAM %then %do;
		%let thisVersion2Check = &version2Check.;
	%end;

	%let thisOutVar = %qsysfunc(compress(&outVar.));
	%global &thisOutVar.;
	%let &thisOutVar. = 0;

	proc sql noprint;
		select count(1), nom_prg_SAS
			into :&thisOutVar. trimmed, :APP_prgName trimmed
		from &tech_sig_lib..&tech_sig_tab.(pw="&mdp_tables.")
		where v_projet_SAS = "&thisVersion2Check."
			%if %getEnv() eq DEV %then %do;
			  and (tot_err_DEV = .
			  	   or tot_warn_DEV = .
			  	   or tot_err_app_DEV = .
			  	   or tot_warn_app_DEV = .
			  )
			%end;
			%else %if %getEnv() eq QUAL %then %do;
			  and (tot_err_QUAL = .
			  	   or tot_warn_QUAL = .
			  	   or tot_err_app_QUAL = .
			  	   or tot_warn_app_QUAL = .
			  )
			%end;
			%else %if %getEnv() eq PROD %then %do;
			  and (tot_err_PROD = .
			  	   or tot_warn_PROD = .
			  	   or tot_err_app_PROD = .
			  	   or tot_warn_app_PROD = .
			  )
			%end;
		;
	quit;

	%if &thisOutVar. > 0 and %length(&APP_prgName.) > 0 %then %do;
		%put2Log(" [Environnement : %getEnv()]::Le couple (&APP_prgName./&version_projet.) n'a pas été analysé ");
		%put2Log(" Merci de faire analyser la log avant par la macro %nrstr(%checkPrgLog2TSignature()) ");
		%goto MACRO_END;
	%end;

	%MACRO_END: /** FIN **/
%MEND isVersionFullParsed;
/**
Exemple :
	%isVersionFullParsed();
	%put2Log(" [Environnement : %getEnv()]::Le total des alertes est &APP_hasErrors. ");
 **/

%MACRO
	deployProject(sourceEnv, targetEnv, refreshParam=YES, version2Deploy=PARAM,  autoLoad=YES) / store
	des="Permet de déployer le projet dans son intégralité d'un environnement à l'autre"
;
	%if &sourceEnv. eq or &sourceEnv. eq "" %then %do;
		%put2Log(" Merci d'indiquer votre environnement source pour le déploiement ");
		%goto MACRO_END;
	%end;
	%if &targetEnv. eq or &targetEnv. eq "" %then %do;
		%put2Log(" Merci d'indiquer votre environnement cible pour le déploiement ");
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
		%if %upcase(&refreshParam.) eq YES %then %do;
			%setDynVar("&path_param.\&name_default_param.", displayVar=YES, backUP=NO);
		%end;

		%isVersionFullParsed(outVar = APP_hasErrors, version2Check = &version2Deploy.);
		%if &APP_hasErrors. > 0 %then %do;
			%goto MACRO_END;
		%end;

		%let thisScope = &scope_errors.;
		%if &scope_errors. eq %then %do;
			%let thisScope = ALL;
		%end;
		%countErrFromTableSignature(scope = &thisScope., outVar = APP_ERRS);
		%if &APP_ERRS. > 0 %then %do;
			%put2Log(" [Environnement : %getEnv()]::Il existe &APP_ERRS. erreur(s). Merci de les corriger avant le déploiement ");
			%goto MACRO_END;
		%end;

		%let thisScope = &scope_warnings.;
		%if &scope_warnings. eq %then %do;
			%let thisScope = ALL;
		%end;
		%countWarningFromTableSignature(scope = &thisScope., outVar = APP_WARNS);
		%if &APP_WARNS. > 0 %then %do;
			%put2Log(" [Environnement : %getEnv()]::Il existe &APP_WARNS. alerte(s). Merci de les corriger avant le déploiement ");
			%goto MACRO_END;
		%end;
	%end;
	%else %do;
		%put2Log(" Merci d'importer le fichier de paramétrage contenant la définition des environnements en premier ");
	%end;

	%MACRO_END: /** FIN **/
%MEND deployProject;
/**
Exemple :
	%deployProject(
		sourceEnv = %getEnv(),
		targetEnv = QUAL,
		refreshParam = YES,
		version2Deploy = PARAM
	);
 **/

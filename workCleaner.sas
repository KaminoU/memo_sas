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
%MEND setSTLib;
%setSTLib();
options noquotelenmax mstored sasmstore=stmALL;

/************************
 *  /!\ UTILISATEUR /!\  *
 *****************************************************************************************************************************************************
 *
 *  Paramétrage utilisateur.
 *
 **/

%let max_date_2_del = '28NOV2019'd;
%let auto_flush = NO; /* valeurs possibles :: YES|NO */
%let run_mode = PIPE; /* valeurs possibles :: PIPE|XCMD */

%runTime();/**[ DEBUT ]***********************************************************************************************************************************/

%MACRO
	disk2Scan(fileDesc, diskName=G) /
	des="Permet de scanner un disque pour lister son utilisation"
;
	data _scan_&diskName.(drop=_: fileS where=(fileP));
		infile &fileDesc. truncover;
		input _line $1024.;

		length fileP $128.
			   fileN $128.
			   fileD 8.
			   fileT 8.
			   fileS $32.
			   fileSo 8.
			   fileSKo 8.
			   fileSMo 8.
			   fileSGo 8.
			   fileSTo 8.
			   folderType $16.
			   direction $16.
		;

		format fileP $128.
			   fileN $128.
			   fileD ddmmyy10.
			   fileT time6.
			   fileS $32.
			   fileSo 32.
			   fileSKo 32.
			   fileSMo 32.
			   fileSGo 32.1
			   fileSTo 32.1
			   folderType $16.
			   direction $16.
		;

		%let _pattern = ^([a-zA-Z]:\\)((?:[^\\\/:*?<>|\r\n]+\\)+)(.+)\s([0-9]{2}\/[0-9]{2}\/[0-9]{4})\s([0-9]{2}:[0-9]{2})\s([0-9]{1,});
		_pos = prxmatch("/&_pattern./i", _line);

		if _pos > 0 then do;
			fileP = prxchange("s/&_pattern./$1$2/", 1, _line);
			fileN = prxchange("s/&_pattern./$3/", 1, _line);
			fileD = input(prxchange("s/&_pattern./$4/", 1, _line), ddmmyy10.);
			fileT = input(prxchange("s/&_pattern./$5/", 1, _line), time6.);
			fileS = prxchange("s/&_pattern./$6/", 1, _line);
			fileSo = input(fileS, 32.);
			fileSKo = fileSo/1024;
			fileSMo = fileSKo/1024;
			fileSGo = fileSMo/1024;
			fileSTo = fileSGo/1024;

			folderType = scan(fileP, 2, '\');
			direction = scan(fileP, 3, '\');
		end;
	run;

	proc sql;
		create table _sum_&diskName. as
			select
					folderType,
					direction,
					count(1) as NB,
					sum(fileSo ) as fileSo_tot format = 32.,
					sum(fileSKo) as fileSKo_tot format = 32.,
					sum(fileSMo) as fileSMo_tot format = 16.1,
					sum(fileSGo) as fileSGo_tot format = 8.1,
					sum(fileSTo) as fileSTo_tot format = 8.1
			from _scan_&diskName.
			group by folderType, direction
		;
	quit;
%MEND disk2Scan;

%MACRO
	getOldDataFromScan2Flush(data_2_scan, max_date_2_del, direction=DEEP, auto_flush=NO) /
	des="Permet de sortir toutes les vieilleries présentes sur le serveur à purger"
;
	%if &data_2_scan. eq ? %then %do;
		%let ctrlHandler = 'HELP';
		%goto _CONTROLLER;
	%end;
	%else %if &data_2_scan. eq or &max_date_2_del. eq or &direction. eq %then %do;
		%let ctrlHandler = 'BLANK';
		%goto _CONTROLLER;
	%end;
	%else %do;
		%if %upcase(&direction.) ne DEEP and %upcase(&direction.) ne FIN and %upcase(&direction.) ne DR %then %do;
			%put ERROR:--[APP]-- Vous avez passé une occurrence non reconnue à la macro;
			%put ERROR:--[APP]-- valeur acceptée : DEEP (par défaut), FIN ou DR;
			%goto _END;
		%end;

		%let ctrlHandler = 'OK';
		%goto _CONTROLLER;
	%end;

	%_CONTROLLER:
		%if &ctrlHandler. = 'OK' %then %do;
			%let _hex = '67A2226223582A41DF11055989CABA44CC07EE99E57598BC2318383F6A63458A';
			%if %upcase(&direction.) eq FIN %then %do;
				%let _hex = '7DDE71F06A50C0122186F6FCA728DEE80132168EA550E380A3366F56013803C8';
			%end;
			%if %upcase(&direction.) eq DR %then %do;
				%let _hex = '3370591C09629449B85110D80CB9F75EC930DBCAF308B03CD6AA94E62B2D2608';
			%end;

			proc sql;
				create table _SASWORK as
					select compress(_tf.fileP) || compress(_tf.fileN) as folder2Flush, _tf.fileD, _tf.fileT,
						   sum(_tf.fileSo) as fileSo format = 32.,
						   calculated fileSo/1024 as fileKo format = 32.,
						   calculated fileKo/1024 as fileMo format = 16.1,
						   calculated fileMo/1024 as fileGo format = 8.1
					from (
						select _s1.*, _tmp.fileSo
						from (
							select fileP, fileN, fileD, fileT
							from &data_2_scan.
							where fileSo = 0
								and put(sha256(folderType || direction), $hex64.) eq &_hex.
								and prxmatch("/_TD\d+_T[a-zA-Z0-9]+_|SAS_[a-zA-Z0-9]+_T[a-zA-Z0-9]+/i", fileN) > 0
								and fileD <= &max_date_2_del.
						) as _s1
						left join (
							select
								case
									when prxmatch("/(\w:(\\[\w\s\d]+)+\\SAS_[\w\d]+_T[\w\d]+)(\\)/i", fileP) > 0 then substr(fileP, 1, length(fileP)-1)
									else prxchange("s/(\w:(\\[\w\s\d]+)+\\_TD\d+_T[\w\d]+_)(\\\w*(\\)?)/$1/", 1, fileP)
								end as _k,
								fileSo
							from &data_2_scan.
						) as _tmp
							on compress(_s1.fileP) || compress(_s1.fileN) = _tmp._k
					) as _tf
					group by calculated folder2Flush, _tf.fileD, _tf.fileT
				;
			quit;

			%if %upcase(&auto_flush.) eq YES %then %do;
				data _null_;
					set _s2;
					call execute('x rmdir /S /Q "' || compress(folder2Flush) || '";');
				run;

				%put NOTE:--[APP]-- Les dossiers ont été correctement purgés, merci de rafraichir le scan si nécessaire;
			%end;
			%else %do;
				%put NOTE:--[APP]-- Merci de valider visuellement le résultat avant d%str(%')appeller la macro de purge;
			%end;
		%end;
		%else %if &ctrlHandler. = 'HELP' %then %do;
			%put ERROR:--[HELP]--   • NOM MACRO :;
			%put ERROR:--[HELP]--      %nrstr(%getOldDataFromScan2Flush());
			%put WARNING:--[HELP]-- • DESCRIPTION :;
			%put NOTE:--[HELP]--       Permet de sortir toutes les vieilleries présentes sur le serveur à purger;
			%put WARNING:--[HELP]-- • SYNTAXE :;
			%put NOTE:--[HELP]--       %nrstr(%getOldDataFromScan2Flush(data_2_scan, max_date_2_del <, direction <, autoFlush>>));
			%put WARNING:--[HELP]-- • ARGUMENT(S) :;
			%put NOTE:--[HELP]--       > data_2_scan : table scan issue de la macro %nrstr(%diskScan(...));
			%put NOTE:--[HELP]--       > max_date_2_del : date maximale des données considérées comme trop anciennes, à supprimer;
			%put NOTE:--[HELP]--                          > format attendu : %str('DDMMMAAAA')d;
			%put NOTE:--[HELP]--       > direction (optionnel) : donnée de la direction à focaliser;
			%put NOTE:--[HELP]--                                 > valeur acceptée : DEEP (défaut), FIN ou DR;
			%put NOTE:--[HELP]--       > autoFlush (optionnel) : purger automatiquement les dossiers;
			%put NOTE:--[HELP]--                                 > valeur acceptée : NO (défaut) ou YES;
		%end;
		%else %if &ctrlHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- Vous avez apppelé la macro %nrstr(%getOldDataFromScan2Flush()) sans argument ou avec un argument vide;
			%put ERROR:--[APP]-- Veuillez consulter l%str(%')aide avec l%str(%')instruction %nrstr(%getOldDataFromScan2Flush(?));
		%end;

	%_END:  /** o( ^  ^ )o FO!!! o( ^  ^ )o **/
%MEND getOldDataFromScan2Flush;
/**
%getOldDataFromScan2Flush(?);
**/

%MACRO _main(run_mode=PIPE) /
	des="Point d'entrée du programme =)"
;
	%if %upcase(&run_mode.) eq PIPE or %upcase(&run_mode.) eq XCMD %then %do;
		%goto _CONTROLLER;
	%end;
	%else %do;
		%put ERROR:--[APP]-- Vous avez passé une occurrence non reconnue à la macro;
		%put ERROR:--[APP]-- valeur acceptée : PIPE (par défaut) ou XCMD;
		%goto _END;
	%end;

	%_CONTROLLER:
		%if %upcase(&run_mode.) eq PIPE %then %do;
			%let fileDesc = pipeDir;
			filename
				&fileDesc. pipe
				"@echo off & for /f ""delims="" %a in ('dir G: /s /b') do echo %~fa %~ta %~za"
				lrecl=32767;
		%end;
		%else %do;
			%let fileDesc = xcmdDir;
			%let tmp_piped_file = \\T3f42\ARCHIVAGE_DEEP\_tmp_pipe_%getTimeStamp().txt;
			x "@echo off & for /f ""delims="" %a in ('dir G: /s /b') do echo %~fa %~ta %~za 1>>&tmp_piped_file.";
			filename &fileDesc. "&tmp_piped_file.";
		%end;

		%disk2Scan(&fileDesc.);

		%getOldDataFromScan2Flush(
			_scan_G,
			max_date_2_del = &max_date_2_del.,
			auto_flush = &auto_flush.
		);

	%_END:  /** o( ^  ^ )o FO!!! o( ^  ^ )o **/
		%if %upcase(&run_mode.) eq XCMD %then %do;
			x "del /F /Q &tmp_piped_file.";
		%end;
%MEND _main;
%_main(run_mode = &run_mode.);

%runTime();/**[ FIN ]***********************************************************************************************************************************/
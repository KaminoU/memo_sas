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
%MACRO
	_disk2Scan(fileDesc, diskName=K, sas7only=TRUE) /
	des="Permet de scanner un disque pour lister son utilisation (regex à adapter selon contexte...)"
;
	data _scan_&diskName.(drop=_: fileS where=(
			fileP
			%if %upcase(&sas7only.) eq TRUE %then %do;
				and fileN like '%sas7bdat' and fileP not like '%\SASWORK\%'
			%end;
		));
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

		/*_line = kvct(_line, "UTF-8", "WLATIN1");*/
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
%MEND _disk2Scan;

%MACRO
	getDataTableFromDisk(diskName) /
	des="Listing de toutes les tables SAS"
;
%let ctrlHandler = '';
	%if &diskName. eq %then %do;
		%let ctrlHandler = 'BLANK';
	%end;
	%if %length(&diskName.) > 1 %then %do;
		%let ctrlHandler = 'ERR_DISKNAME';
	%end;

	%_CONTROLLER:
		%if &ctrlHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- Vous avez apppelé la macro %nrstr(%getDataTableFromDisk()) sans argument ou avec un argument vide;
			%put ERROR:--[APP]-- Veuillez indiquer la lettre du disque à scanner;
			%goto _END;
		%end;
		%if &ctrlHandler. = 'ERR_DISKNAME' %then %do;
			%put ERROR:--[APP]-- Vous avez apppelé la macro %nrstr(%getDataTableFromDisk()) avec un argument incorrect;
			%put ERROR:--[APP]-- Veuillez indiquer la lettre du disque à scanner;
			%goto _END;
		%end;

		%let fileDesc = pipeDir;
		filename
			pipeDir pipe
			"@echo off & for /f ""delims="" %a in ('dir &diskName.: /s /b') do echo %~fa %~ta %~za"
			lrecl=32767;
		%_disk2Scan(&fileDesc., diskName = &diskName.);

	%_END:  /** o( ^  ^ )o FO!!! o( ^  ^ )o **/
%MEND getDataTableFromDisk;
/*%getDataTableFromDisk(F);*/

%MACRO
	getDataTableFingerPrint(tableName) /
	des="calculer l'empreinte digitale unique de la table SAS en argument"
;
%let ctrlHandler = '';
	%if &tableName. eq %then %do;
		%let ctrlHandler = 'BLANK';
	%end;

	%_CONTROLLER:
		%if &ctrlHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- Vous avez apppelé la macro %nrstr(%getDataTableFingerPrint()) sans argument ou avec un argument vide;
			%put ERROR:--[APP]-- Veuillez indiquer le nom de la table avec son chemin absolu;
			%goto _END;
		%end;

		%let digitDesc = pipeSHA;
		filename
			&digitDesc. pipe
			"CertUtil -hashfile ""&tableName."" SHA256"
			lrecl=32767;
		data _fingerP;
			infile &digitDesc. truncover;
			input fingerP $128.;
			if _N_ = 2 then do;
				fingerP = compress(upcase(fingerP));
				output;
			end;
		run;

	%_END:  /** o( ^  ^ )o FO!!! o( ^  ^ )o **/
%MEND getDataTableFingerPrint;

%MACRO updateFingerPrint(dataSet) /
	des="calculer l'empreinte digitale sur l'ensemble de la table résultante de %getDataTableFromDisk(<diskName>)"
;
%let ctrlHandler = '';
	%if &dataSet. eq %then %do;
		%let ctrlHandler = 'BLANK';
	%end;

	%_CONTROLLER:
		%if &ctrlHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- Vous avez apppelé la macro %nrstr(%updateFingerPrint()) sans argument ou avec un argument vide;
			%put ERROR:--[APP]-- Veuillez indiquer le nom de la table SAS;
			%goto _END;
		%end;

		options nonotes nosource nosource2 errors=0;

		proc sql noprint;
			select count(1) into: tot_rows
			from &dataSet.
			;
		quit;

		%do i=1 %to &tot_rows.;
			data _sub_1
				 &dataSet.;
				set &dataSet.;

				if _N_ = 1 then do;
					output _sub_1;
				end;
				if _N_ > 1 then do;
					output &dataSet.;
				end;
			run;
			data _null_;
				set _sub_1;
				call execute('%getDataTableFingerPrint('||trim(fileP)||trim(fileN)||');');
			run;
			proc sql noprint;
				create table _fP as
					select _s.*, _f.*
					from _sub_1 as _s, _fingerP as _f
				;
			quit;

			%if &i.=1 %then %do;
				proc sql noprint;
					create table &dataSet._fP as 
						select * from _fP
					;
				quit;
			%end;
			%else %do;
				proc append base=&dataSet._fP data=_fP force; run;
			%end;
		%end;

	%_END:  /** o( ^  ^ )o FO!!! o( ^  ^ )o **/
		%let remainRows = 1;
		proc sql noprint;
			select count(1) into: remainRows
			from &dataSet.
			;
		quit;
		%if &remainRows. = 0 %then %do;
			proc datasets lib=work nolist;
				delete &dataSet.;
			quit;
		%end;

		options notes source source2 errors=20;
%MEND updateFingerPrint;
/*%updateFingerPrint(_scan_f);*/

%MACRO getDupTables(diskName) /
	des="lister les tables en doublon"
;
%let ctrlHandler = '';
	%if &diskName. eq %then %do;
		%let ctrlHandler = 'BLANK';
	%end;

	%_CONTROLLER:
		%if &ctrlHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- Vous avez apppelé la macro %nrstr(%getDupTables()) sans argument ou avec un argument vide;
			%put ERROR:--[APP]-- Veuillez indiquer la lettre du disque à analyser;
			%goto _END;
		%end;

		proc sql;
			create table _scan_&diskName._dup as
				select _s.*
				from (
					select count(1) as NB, fingerP
					from _scan_&diskName._fp
					group by fingerP
					having calculated NB > 1
				) as _d
				left join _scan_&diskName._fp as _s
					on _d.fingerP = _s.fingerP
			;
		quit;

	%_END:  /** o( ^  ^ )o FO!!! o( ^  ^ )o **/
%MEND getDupTables;
/*%getDupTables(F);*/

%MACRO main(diskName) /
	des="Point d'entrée du programme =)"
;
%let ctrlHandler = '';
	%if &diskName. eq %then %do;
		%let ctrlHandler = 'BLANK';
	%end;

	%_CONTROLLER:
		%if &ctrlHandler. = 'BLANK' %then %do;
			%put ERROR:--[APP]-- Vous avez apppelé la macro %nrstr(%main()) sans argument ou avec un argument vide;
			%put ERROR:--[APP]-- Veuillez indiquer la lettre du disque à scanner et analyser;
			%goto _END;
		%end;

		%getDataTableFromDisk(&diskName.);
		%updateFingerPrint(_scan_&diskName.);
		%getDupTables(&diskName.);

	%_END:  /** o( ^  ^ )o FO!!! o( ^  ^ )o **/
%MEND main;
%main(F);
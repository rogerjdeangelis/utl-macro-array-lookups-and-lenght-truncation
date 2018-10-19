Macro array lookups and lenght truncation

This solution has some enhancements

   1. Set length of lookup variable to 3 characters. This eliminates the substring requirement.
   2. Use array statement instead of '%let'
   3. DO_OVER with select statements should be faster.
      (compilers love static code, execute mutiple instruction streams and thow away logical 0s)

github
https://tinyurl.com/ybnanwvp
https://github.com/rogerjdeangelis/utl-macro-array-lookups-and-lenght-truncation

SAS  Forum
https://tinyurl.com/y8u3qaew
https://communities.sas.com/t5/SAS-Programming/Use-scan-to-scan-character-values/m-p/505839

I try to take care with the question because it is the question that is important, not the answer.


INPUT
=====

%array(code, values=711 712 713 714 715 717 718 819);
%array(desc, values=Admin IP AC Diagtherap CommHealth Research Education UndAccnt);

Note these are macro arrays

  code1 = 711      desc1 = Admin
  code2 = 712      desc2 = IP
 ..                .
  code9  = 819     desc9  = UndAccnt

  coden  = 9       descn  = 9

WORK.HAVE total obs=3  | RULES (use the first three characters of FC5(code#)
                       |        to lookup the description(desc#)

    FC5                | FC5    DESC
                       |
  71234                | 712    IP because 712 = code2 so extract desc2 = IP

  71333                | 713    AC because 713 = code3 so extract desc3 = AC
  7149833              | 714


EXAMPLE OUTPUT
--------------

 WORK.WANT total obs=3

    FC5    FC_DESC

    712    IP
    713    AC
    714    Diagtherap


PROCESS
=======

* you can always run my debug macro and retrieve the pretty code;
data want;

  * setting fc5 to length 3 automaticall does the substring;
  length fc5 $3 fc_desc $16;

  set have;
    select (fc5);
      %do_over(code desc,phrase=%str(
         when ( "?code") fc_desc = "?desc";
      ))
      otherwise;
    end;

run;quit;

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

data have;
 input fc5 $;
cards4;
71234
71333
7149833
;;;;
run;quit;

%array(code, values=711 712 713 714 715 717 718 819);
%array(desc, values=Admin IP AC Diagtherap CommHealth Research Education UndAccnt);



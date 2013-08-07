(* 

Module: Ceph
Augeas module for Ceph.   

Author: Stepan Stipl <stepan@stipl.net>

TODO:
- proper Augeas style comments & some basic docs
*)

module Ceph	= autoload xfm

(* Comments starting with # or ; *)
let comment 	= IniFile.comment IniFile.comment_re IniFile.comment_default


let sep		= del /[ \t]*=[ \t]*/ " = "
let indent	= del /[ \t]*/ "\t"

(* Import useful INI File primitives *)
let eol     	= IniFile.eol
let empty    	= IniFile.empty
let sto_to_comment
		= IniFile.sto_to_comment

(* Entry *)
let entry_re 	= /[A-Za-z_][A-Za-z0-9._ -]*[A-Za-z0-9._-]/
let entry    	= let kw = entry_re in
             	[ indent
             	. key kw
             	. sep
             	. sto_to_comment?
             	. (comment|eol) ]
             	| comment

(* Title *)
let title    	= IniFile.title IniFile.record_re
let record    	= IniFile.record title entry

(* Lens *)
let lns      	= IniFile.lns record comment

let filter   	= (incl "/etc/ceph/ceph.conf")
             	. Util.stdexcl

let xfm		= transform lns filter

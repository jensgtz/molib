# -*- coding: UTF-8 -*-



"""
"""

import os
import shutil

from pal import BA_DSN, MOLIB_LIBDIR
from plx16.data.postgresql.pgdb import PgDb
from plx16.misc.p27str import p27Str



LIB_ID = 1
DEST_PATH = MOLIB_LIBDIR



def ascii(s):
    s = p27Str(s)
    repl_list = [(u"Ü","Ue"),(u"Ö","Oe"),(u"Ä","Ae"),
                 (u"ü","ue"),(u"ö","oe"),(u"ä","ae"),
                 (u"ß","sz"),(u"²","2"),(u"³","3"),(u"·","*"),(u"°","deg")]
    for x,y in repl_list:
        x = p27Str(x)
        y = p27Str(y)
        s = s.replace(x,y)
    return s

def make_content(moclass):
    content = ""
    if moclass["doc"]:
        content += "/*\n<DOC>\n%s\n</DOC>\n*/\n\n" % ascii(moclass["doc"])
    if moclass["notes"]:
        content += "/*\n<NOTES>\n%s\n</NOTES>\n*/\n\n" % ascii(moclass["notes"])
    content += ascii(moclass["code"])
    return content

def create_file(dirname, filename, content, within=None):
    f = open(os.path.join(dirname, filename), "wt")
    if within is None:
        pass
    else:
        f.write("within %s;\n\n" % within)
    f.write(content)  
    f.close()
    
def fetch_class(db, class_id, basedir, pre):
    moclass = db.getRow("molib", "class", class_id)
    print moclass["library_path"]
    #
    within = ".".join(pre)
    content = make_content(moclass)
    if moclass["class_type"] == "package":
        #create dir
        dirname = os.path.join(basedir, moclass["library_path"].replace(".", os.path.sep))
        if not(os.path.exists(dirname)):
            os.makedirs(dirname)
        #create package.mo
        create_file(dirname=dirname, filename="package.mo", content=content, within=within)
        #create package.order
        childs = db.exn1t("select name from molib.class where parent_id=%s order by class_type, name", args=(moclass["id"],))
        create_file(dirname=dirname, filename="package.order", content="\n".join(childs))
    else:
        #create dir
        dirname = os.path.join(basedir, os.path.sep.join(moclass["library_path"].split(".")[:-1]))
        if not(os.path.exists(dirname)):
            os.makedirs(dirname)
        #create <class>.mo
        create_file(dirname=dirname, filename="%s.mo" % moclass["name"], content=content, within=within)
    #
    new_pre = pre[:] + [moclass["name"]]
    for child_id in db.exn1t("select id from molib.class where parent_id=%s order by name", args=(class_id,)):
        fetch_class(db, class_id=child_id, basedir=basedir, pre=new_pre)

def main():
    db = PgDb(dsn=BA_DSN)
    shutil.rmtree(DEST_PATH)
    fetch_class(db=db, class_id=LIB_ID, basedir=DEST_PATH, pre=[])
    db.close()

if __name__ == "__main__":
    main()
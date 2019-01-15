import os
import shutil

def GetPathNameExt(filename):
    (filepath,tempfilename) = os.path.split(filename)
    (shotname,extension) = os.path.splitext(tempfilename)
    return filepath,shotname,extension

def GetFileSize(filepath):
    fsize = os.path.getsize(filepath)
    #fsize = fsize/float(1024*1024)
    #print(fsize)
    return round(fsize, 2)

def main():
    print("hello dir %d" % 10)
    os.chdir("F:\\wserver\\info\\2_1\\0")
    lis = os.listdir()
    for ls in lis:
        print("file:%s, size:%d" %(ls, GetFileSize(ls)))
        if  10000 > GetFileSize(ls) > 5000:
            path, name, ext = GetPathNameExt(ls)
            print("path:%s, name:%s, ext:%s" %(path, name, ext))
            shutil.copy(ls, "car/%s" % ls)
            strname = name
            strname += ".jpg"
            if os.path.exists(strname):
                shutil.copy(strname, "car/%s" % strname)
            strname = name
            strname += "_l.jpg"
            if os.path.exists(strname):
                print("file is exists:%s"%strname)
                shutil.copy(strname, "car/%s" % strname)

if __name__ == '__main__':
    main()
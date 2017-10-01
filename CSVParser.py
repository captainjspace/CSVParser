#!/usr/local/bin/python
import re
def scrub_quote(d):
    d = re.sub(r"\"","", d)
    d = re.sub(r"\\r\\n","",d)
    d = re.sub(r"\\n","",d)
    d = "\"" + d + "\""
    return d

file = open("testdata.txt", "r")
data = file.readlines()
file.close()
count=0
header=[]
records=[]

for i in data:
    if (count == 0):
         header = i.split(",")
         next
    else:
        rec = i.split(",")
        m_obj = {}
        index = 0
        for i in header:
            m_obj[i] =rec[index]
            index+=1
        records.append(m_obj)
    count+=1
    #print count
final = []
for i in records:
    fmt=[]
    s=""
    for k in i.keys():
        s = ("%s : %s" % (scrub_quote(k.strip()), scrub_quote(i[k].strip())))
        fmt.append(s)
    recStr= "{" +  ",".join(fmt) + "}"
    final.append(recStr)
print '{\n  "payload":[\n   ' +  ',\n'.join(final) + '\n  ]\n}\n'

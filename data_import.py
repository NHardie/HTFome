############ All you need to modify is below ############
# Full path and name to your csv file
csv_filepathname="/home/nick-work/bioinfo-group-project/bioinfo-group-project/HTF_data.csv"
# Full path to the directory immediately above your django project directory
your_djangoproject_home="/home/nick-work/bioinfo-group-project/bioinfo-group-project/"
############ All you need to modify is above ############


import sys,os
sys.path.append(your_djangoproject_home)
os.environ['DJANGO_SETTINGS_MODULE'] ='.settings'

from sw2.wkw2.models import School, Lawyer

import csv
dataReader = csv.reader(open(csv_filepathname), delimiter=',', quotechar='"')

old_school = None
for row in dataReader:
    if old_school != row[4]:
        old_school = row[4]
        school = School()
        school.name = old_school
        school.save()

dataReader = csv.reader(open(csv_filepathname), delimiter=',', quotechar='"')

for row in dataReader:
    lawyer=Lawyer()
    lawyer.firm_url=row[0]
    lawyer.firm_name=row[1]
    lawyer.first=row[2]
    lawyer.last=row[3]

    lawyer_school=School.objects.get(name=row[4])
    lawyer.school=lawyer_school

    lawyer.year_graduated=row[5]
    lawyer.save()
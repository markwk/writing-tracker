#!/usr/bin/python
# encoding: utf-8
#
# Writing Tracker Simple Data Report
# Requires Matplotlib and pandas
# install with $ pip install matplotlib
# $ pip install pandas
#
# Usage: 
# python report.py DATA_FILE NUM_DAYS TARGET_DIR NAME
# python report.py /Users/my-user-name/path/writing-notes-stats.csv 7 /Users/my-user-name/Desktop/ Writings
#
# Copyright  (c) 2018 Mark Koester mark@int3c.com
#
# MIT Licence. See http://opensource.org/licenses/MIT
#
# Created on 2019-2
#

from __future__ import absolute_import

import subprocess
import sys
import os

# data analysis
import pandas as pd
import matplotlib.pyplot as plt

def trim_date(string):
    return string[5:]

def stats_data_report(data_file, days, target_dir, name):
    # getting and preparing data
    data = pd.read_csv(data_file)
    # trim for short date
    data['short_date'] = data.date.apply(trim_date)
    data =  data.tail(days)
    start_date = data[0:1].date.values[0]
    end_date = data[len(data)-1:].date.values[0]
    total_words_added =  data.words_added.sum()
    dates = data.short_date
    values = data.words_added

    # plotting
    plt.figure(1, figsize=(8, 3))
    plt.title(start_date+' to '+end_date+' '+name+' Stats' + '\nTotal Words Added: '+ str(total_words_added))
    plt.bar(dates, values, color='green')
    #plt.show()

    # Save to a Target Directory
    filename=target_dir+start_date+'_to_'+end_date+'_'+name+'_stats_report.png' 
    print "Creating writing stats report..."+filename
    plt.savefig(filename, bbox_inches='tight')

if __name__ == "__main__":
    arg1 = sys.argv[1]
    arg2 = int(sys.argv[2])
    arg3 = sys.argv[3]
    arg4 = sys.argv[4]
    stats_data_report(arg1, arg2, arg3, arg4)


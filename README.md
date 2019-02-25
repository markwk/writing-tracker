# Writing Tracker
### Tracking and Data Analysis of Your Writings or Plaintext Notes with Git, Bash and Python

The goal of this project is to provide a simple git-based tracking setup for any directory of plaintext files. It can work for your writings, notes or anything else in plaintext files. 

Additionally it includes both a simple data report and a jupyter notebook for more advanced data analysis. 

Project's three components: 

* writing-tracker.sh: script to track daily changes in a directory of plaintext files 
* report.py: simple python script to graphically plot latest stats with pandas and matplot
* writing_data_analysis.ipynb: Jupyter notebook in Python to analysis of writing stats. 

## writing-tracker.sh: Writing Tracker with Bash and Git

Daily bash script that navigates to a directory of plain text files, add files to git repo, calculates key diff stats, store stats to csv and commit to git with message. 

Optional: 
* Send a local mac push notification. 
* Track actual files directory of copy files to a new dirctory for tracking

### Installation, Setup and Usage: Writing Tracker with Bash and Git

##### Step 1: Git Setup of Writings or Notes Directory

* If you haven't already, [install git](https://www.atlassian.com/git/tutorials/install-git). 
* Navigate to your writings or notes directory and [setup a git repository](https://www.atlassian.com/git/tutorials/setting-up-a-repository)

##### Step 2: Installation and Setup

* Clone or download the [repo](https://github.com/markwk/writing-tracker) or just copy [tracking script](https://github.com/markwk/writing-tracker/blob/master/writing-tracker.sh)
* Using terminal, navigate to the directory you copied or cloned the code. 
* [Set permissions on the script](https://bash.cyberciti.biz/guide/Setting_up_permissions_on_a_script): `$chmod +x writing-tracker.sh`
* Edit writing-tracker.sh and set TARGET_DIR and DATA_FILE to local locations. 
* (Optionally, if you want to copy rather than run directory on your files, create a new directory for that target and init a git repo there. Then uncomment that section in the script.) 

##### Step 3: Test

* After editing, test by manully running the script `$ ./writing-tracker.sh`
* Check that relevant output file. Ensure you are getting basic stats there. 
* Add to the first line the following header: `date,current_datetime,total_files,files_changed,files_added,files_modified,files_deleted,files_renamed,words_added,words_deleted,words_duplicated,hashtags_added,hashtags_added,hashtags_deleted,refs_added,refs_deleted`
* If the test was successful, remove the data added in the csv. 
* Uncomment the line `git commit -m "$commit_msg"`

##### Step 4: Automate with Cron

Technically this script can be used manually. But I recommend setting up a crontab process to run daily. 

On Mac you can do this by running `$ crontab -e` and adding a line like: `00  1  *  *  * /user/name/path/to/file//writing-tracker.sh`

In this example, cron will run at 1am each day and log my writing stats! 

## report.py: Graphically plot latest stats with pandas and matplot

This is a simple automation script that allows you to view a graph of your latest statistics. 

In terminal or command line, run:

````
python /Users/path/to/directory/report.py /Users/path/to/notes/writings-notes-stats.csv 7 /Users/username/Desktop/ Writings
````

Arguments are data.csv, days, output directory and name. 

## writing_data_analysis.ipynb: Advanced data analysis and data visualization with Jupyter and Python

[writing_data_analysis.ipynb](https://github.com/markwk/writing-tracker/blob/master/writing-data-analysis/writing_data_analysis.ipynb) provides more advanced data analysis on your writings and notes, including visualziations and comparisions. 

### Why was Writing Tracker created?

This project was created to help track writing and notes plaintext files. 

It was specifically designed to help track writing and notes files in markdown, but it should work with any directory of plain text files. 

### Creator

[Mark Koester](http://www.markwk.com) | [www.markwk.com](http://www.markwk.com) | github.com/markwk | markwkoester@gmail.com 


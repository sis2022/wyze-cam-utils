# wyze-cam-utils

* suitable for scheduled execution via cron: only errors output
* Wyze Cams indiscriminately create directory trees in this format
  'YYYYmmdd/hh/' whether there's data written or not. 'cleanEmptyCamDirs.sh'
  deals with it and removes empty directories recursively.
* When wanting to review recorded data (*mp4) remotely, it is convenient to have
  thumbnails (with configurable resolution/size) for fast download.
  'createCamThumbs.sh' creates a shadow directory tree (currently at '${HOME}/NAS')
  containing those thumbnails.


* Scripts 'createCamThumbs.sh' and 'cleanEmptyCamDirs.sh'
  * assume
    * a (configurable) base dir of "/cams"
    * per cam directory, with cam name like "/cam/wyze01", "/cam/wyze02" etc.
  * Mode of execution:
    * work on all (-a) directories
    * specify date (YYYYmmdd) to work on
    * by default work on todays and yesterdays directories
    * 
* License: GPLv2

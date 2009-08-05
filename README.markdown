Bonsai Video
=====================================

**Project Blog**:  [http://vms.brispace.net](http://vms.brispace.net)   
**Git**:       [http://github.com/bamnet/bonsai-video](http://github.com/bamnet/bonsai-video)  
**Author**:    Brian Michalski  
**License**:   MIT License  

Development on this project was made possible by the [Rensselaer Center for Open Source Software](http://rcos.cs.rpi.edu/) which is
 funded by Sean O'Sullivan '85.

Overview
---------

Bonsai video is a video management system designed to easily make videos accessible to as many possible.
Videos can be uploaded via web browser or imported (presumable after being transfered via FTP or SCP).  Users
can generate thumbnails at specific timecodes for videos, in addition to those automatically generated on upload.
Conversion is accomplished via background jobs using Workling/Starling, that farm out commands to convert videos 
(typically an ffmpeg command).  Video distribution uses a plugin system and provided oEmbed capabilities.

Requirements
____________
*  Ruby on Rails
*  Starling
*  Workling
*  [Mediainfo](http://github.com/greatseth/mediainfo/tree/master)
*  ffmpeg, memcoder, codec, etc

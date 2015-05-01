# snort-thresholds

[![Join the chat at https://gitter.im/shadowbq/snort-thresholds](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/shadowbq/snort-thresholds?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Gem Version](https://badge.fury.io/rb/threshold.png)](http://badge.fury.io/rb/threshold)
[![Gem](https://img.shields.io/gem/dt/threshold.svg)](http://badge.fury.io/rb/threshold)

Threshold is an ORM to map to Snort 2.9.x threshold.conf files.

It currently supports all standalone snort filters generally found in a threshold configuration. These include  suppressions, event_filters, and rate_filters as defined in [Snort README.filters](https://github.com/jasonish/snort/blob/master/doc/README.filters
). 

## Code Status

[![Build Status](https://travis-ci.org/shadowbq/snort-thresholds.svg?branch=master)](https://travis-ci.org/shadowbq/snort-thresholds) 
[![Code Climate](https://codeclimate.com/github/shadowbq/snort-thresholds/badges/gpa.svg)](https://codeclimate.com/github/shadowbq/snort-thresholds) 
[![Test Coverage](https://codeclimate.com/github/shadowbq/snort-thresholds/badges/coverage.svg)](https://codeclimate.com/github/shadowbq/snort-thresholds)
[![GitHub tag](https://img.shields.io/github/tag/shadowbq/snort-thresholds.svg)](http://github.com/shadowbq/snort-thresholds)

Stable (travis-ci passing) **tags** are release as **gems**, but are NOT marked as stable-0.1.0 or the like.

## Installation

`$> gem install threshold`

## Usage

This is an example Threshold accessing `/tmp/threshold.conf` for loading, appending a new suppression, validiating the configuration, and writing the changes back to the file (flush).

```ruby
2.1.2 :001 > require 'threshold'
 => true 
2.1.2 :002 > a = Threshold::Thresholds.new
 => [] 
2.1.2 :003 > a.file = '/tmp/threshold.conf'
 => "/tmp/threshold.conf" 
2.1.2 :004 > a.loadfile
 => [{"SUPPRESSION"=>["suppress gen_id 1, sig_id 2"], "GID"=>["1", nil, nil], "SID"=>["2", nil, nil]}, {"SUPPRESSION"=>["suppress gen_id 444, sig_id 2"], "GID"=>["444", nil, nil], "SID"=>["2", nil, nil]}] 
2.1.2 :005 > a.valid?
 => true 
2.1.2 :006 > b = Threshold::Suppression.new
 => #<Threshold::Suppression:0x00000002a576f0> 
2.1.2 :007 > b.gid=124
 => 124 
2.1.2 :008 > b.sid=45544
 => 45544 
2.1.2 :009 > a << b
 => [#<Threshold::Suppression:0x00000002a87b98 @gid=1, @sid=2>, #<Threshold::Suppression:0x00000002a846c8 @gid=444, @sid=2>, #<Threshold::Suppression:0x00000002a576f0 @gid=124, @sid=45544>] 
2.1.2 :010 > a.flush
 => true 
```

Filtering the Threshold Object can be achieved with common Array like methods. (ex. `reject` )

```ruby
require 'threshold'
a = Threshold::Thresholds.new
a.file = '/tmp/threshold.conf'
a.loadfile
a = a.reject{|t| t.gid==1}
```

## Contibuting

* See [CONTRIBUTING.md](/CONTRIBUTING.md)

## Credits

* [Shadowbq](https://github.com/shadowbq)
* [Yabbo](https://github.com/yabbo)


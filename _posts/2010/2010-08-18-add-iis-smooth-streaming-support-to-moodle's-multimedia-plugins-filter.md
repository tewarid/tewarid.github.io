---
layout: default
title: Add IIS Smooth Streaming support to Moodle's Multimedia Plugins Filter
tags: moodle php
comments: true
---
# Add IIS Smooth Streaming support to Moodle's Multimedia Plugins Filter

We use the Smooth Streaming Player provided by the Silverlight Media Framework project at [https://smf.codeplex.com/](https://smf.codeplex.com/).

Download and unzip the contents of smooth streaming player [binaries](http://smf.codeplex.com/releases/view/50440#DownloadId=141817) to the filter\mediaplugin folder of your Moodle installation.

Modify `filter.php` in the same folder.

Add the following lines to the function called filter, at the appropriate location

```php
if ($CFG->filter_mediaplugin_enable_ism) {
  $search = '/<a.*?href="([^<]+\.ism\/Manifest)"[^>]*>.*?<\/a>/is';
  $newtext = preg_replace_callback($search, 'mediaplugin_filter_ism_callback', $newtext);
}
if ($CFG->filter_mediaplugin_enable_ism) {
  $search = '/<a.*?href="([^<]+\.isml\/Manifest)"[^>]*>.*?<\/a>/is';
  $newtext = preg_replace_callback($search, 'mediaplugin_filter_ism_callback', $newtext);
}
```

To the same file, add the following function

```php
function mediaplugin_filter_ism_callback($link, $autostart=false) {
  global $CFG;
  $url = $link[1];
  if (empty($link[3]) or empty($link[4])) {
    $mpsize = '';
    $size = 'width="600" height="400"';
    $autosize = 'true';
  } else {
    $size = 'width="'.$link[3].'" height="'.$link[4].'"';
    $mpsize = $size;
    $autosize = 'false';
  }
  $mimetype = mimeinfo('type', $url);
  $autostart = $autostart ? 'true' : 'false';
  return $link[0].
'<span>
<object data="data:application/x-silverlight-2," type="application/x-silverlight-2" '.$size.'>
<param name="source" value="'.$CFG->wwwroot.'/filter/mediaplugin/SmoothStreamingPlayer.xap"/>
<param name="background" value="white" />
<param name="minRuntimeVersion" value="4.0.50401.0" />
<param name="autoUpgrade" value="true" />
<param name="InitParams" value="selectedcaptionstream=textstream_eng,mediaurl='.$url.'" />
<a href="http://go.microsoft.com/fwlink/?LinkID=149156&v=4.0.50401.0" style="text-decoration:none">
<img src="http://go.microsoft.com/fwlink/?LinkId=161376" alt="Get Microsoft Silverlight" style="border-style:none"/>
</a>
</object>
</span>';
}
```

Modify `filtersettings.php` in the same folder.

Add the following line at the appropriate location

```php
$settings->add(new admin_setting_configcheckbox('filter_mediaplugin_enable_ism', get_string('mediapluginism','admin'), '', 1));
```

Finally, we need to add a string resource used by the settings page of the plugin.

Edit `lang\en_utf8\admin.php`, or corresponding file in the appropriate language folder, and add the following

[code language="php" light="true"]
$string['mediapluginism'] = 'Enable .ism (IIS Smooth Streaming) filter';
[/code]

Here's a screenshot of the filter in action

![IIS Smooth Streaming filter in action](/assets/img/moodle-iis-smooth-streaming.jpg)

A URL to a smooth stream, live or on demand, does not just end with `.isml` or `.ism`, you have to add a `/Manifest` after that. Without this the filter will not recognize the URL as a smooth stream.

This has been tested with the latest Moodle weekly build 1.9.9+ but should be easy to adapt for version 2.

If you encounter any issue with the Smooth Streaming Player, try to get a newer version from the project site, or report the issue to them.

Happy smooth streaming!

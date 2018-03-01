---
layout: default
title: Integrating C# app with Moodle 2
tags: c# .net moodle 2 web service
---

Moodle 2 exposes the same service methods using several protocols like XML-RPC, AMF and SOAP. In this post, we'll use XML-RPC. The examples below use existing Moodle 2 services. These are very few but I believe the Moodle 2 team will add more as time goes by.

### Configure web services

To expose web service methods for Moodle 2 use the following documentation: [https://docs.moodle.org/dev/Web_services](https://docs.moodle.org/dev/Web_services). Since this documentation is sparse, we'll list the basic steps required to configure a user that can access existing web service methods.

![site admin web services plugin](/assets/img/moodle-2-site-administration.jpg)

1. Add a new Moodle user

    We'll assume this user will only access web service methods. Login as the Moodle admin and go to Site administration, Users, Accounts, Add a new user. Create a user with username `wsuser` and with the password `Wsuser!23`or any other username and password combination you please.

2. Define a role that can be assigned to `wsuser`

    Roles are how capabilities are assigned to users. Go to Site administration, Users, Permissions, Define roles. Add a new role. Call the role `WebService`. Assign the role to the Context type System - just tick the check box System.

    Then, assign the following capabilities to the role

    * webservice/xmlrpc:use
    * moodle/course:view
    * moodle/course:update
    * moodle/course:viewhiddencourses
    * moodle/user:viewdetails

3. Assign the WebService role with all its associated capabilities to `wsuser`

    Go to Site administration, Users, Permissions, Assign system roles. Select the WebService role. Assign `wsuser` to the role.

4. Enable web services

    If they are already enabled skip this step. Go to Site administration, Advanced features. Tick the _Enable web services_ check box. Save changes.

5. Enable the xml-rpc protocol

    At Site administration, Plugins, Web services, Manage protocols.

6. Create a new external service

    Go to  Site administration, Plugins, Web services, External services. Add a new web service. Set the name to test, tick Enabled check box, and tick the _Authorised user only_ check box.

7. Add the following functions to web service test

    * `moodle_course_get_courses`

8. Add user `wsuser` as authorized user of web service test

    If the user has any capabilities missing, you will be prompted about missing capabilities. Add these capabilities as shown in step 2.

### Create C# App

We'll create an interface for the [XMLRPC.net](http://xml-rpc.net/) framework. Here's the interface:

```c#
public interface IMoodle : IXmlRpcProxy
{
    [XmlRpcMethod("moodle_user_get_users_by_id")]
    object[] GetUserById(object[] id);
    [XmlRpcMethod("moodle_course_get_courses")]
    object[] GetCourses();
}
```

Next, we call a method on this interface

```c#
IMoodle moodleProxy;
moodleProxy = XmlRpcProxyGen.Create<IMoodle>();
moodleProxy.Url = "http://host/moodle/webservice/xmlrpc/simpleserver.php?wsusername=wsuser&wspassword=Wsuser!23";
object [] a = moodleProxy.GetCourses(); // returns an array of Hashtable
```

In the example above we recover a list of courses, the method GetCourses returns an array of Hashtable. Each hash table contains attributes of a course object. These are key value pairs that can be printed out using a simple method such as:

```c#
private string ConvertToString(object[] a)
{
  string ret = string.Empty;
  if (a.Count() <= 0 || !(a[0] is XmlRpcStruct) || !(a[0] is Hashtable))
  {
    return ret;
  }
  for (int i = 0; i < a.Count(); i++)
  {
    Hashtable h = (Hashtable)a[i];
    IDictionaryEnumerator e = (IDictionaryEnumerator)h.GetEnumerator();
    while (e.MoveNext())
    {
      ret += e.Key + "=" + e.Value + ",";
    }
    ret += ";";
  }
  return ret;
}
```

Here's a sample output from this method

```text
timecreated=1282062417,summary=This is a test course,showreports=0,shortname=CF101,
format=weeks,id=2,categorysortorder=100,enablecompletion=0,forcetheme=,showgrades=1,
startdate=1282100400,summaryformat=1,newsitems=5,idnumber=,maxbytes=2097152,numsections=10,
groupmodeforce=0,lang=,completionnotify=0,categoryid=1,hiddensections=0,
timemodified=1282062417,completionstartonenrol=0,defaultgroupingid=0,
fullname=Course Fullname 101,visible=1,groupmode=0,;
```

Next, we'll see how we can recover a list of courses where each course is represented by an object.

### Returning objects

Parameters and return values can be of a specific type. A Moodle course object can be represented by a struct such as:

```c#
public struct Course
{
  public int id;
  public string shortname;
  public int categoryid;
  public int categorysortorder;
  public string fullname;
  public string idnumber;
  public string summary;
  public int summaryformat;
  public string format;
  public int showgrades;
  public int newsitems;
  public int startdate;
  public int numsections;
  public int maxbytes;
  public int showreports;
  public int visible;
  public int hiddensections;
  public int groupmode;
  public int groupmodeforce;
  public int defaultgroupingid;
  public int timecreated;
  public int timemodified;
  public int enablecompletion;
  public int completionstartonenrol;
  public int completionnotify;
  public string lang;
  public string forcetheme;
  public override string ToString()
  {
    string ret = string.Empty;
    FieldInfo [] attribs = this.GetType().GetFields();
    foreach (FieldInfo attrib in attribs)
    {
      ret += attrib.Name + "=" + attrib.GetValue(this) + ",";
    }
    return ret;
  }
}
```

To return an array of Course objects, modify the GetCourses method in the IMoodle interface:

```c#
[XmlRpcMethod("moodle_course_get_courses")]
Course[] GetCourses();
```

Now, instead of a generic hash table for each object, we get a proper Course object.

### Authentication using tokens

Tokens are hard to decipher values that can be used for authentication, instead of username and password. Go to Site administration, Plugins, Web services, Manage tokens. Add a token for service test and user `wsuser`.

This token can then be used in the url of the XML-RPC proxy

```c#
moodleProxy.Url = "http://192.168.2.1/moodle/webservice/xmlrpc/server.php?wstoken=7ab3284ee0b534b039728c0e945d9c71";
```

---
layout: default
title: Integrating an LDAP Directory in a Java Application
tags: ldap java
---

[Lightweight Directory Access Protocol](https://tools.ietf.org/html/rfc4511)
(LDAP) is a protocol for accessing directory services over the internet using
TCP/IP. Various commercial directories like Active Directory from Microsoft and
Oracle Internet Directory provide LDAP interfaces.
[OpenLDAP](https://www.openldap.org/) is an open source LDAP directory
distributed with almost every Linux distribution. We will use OpenLDAP in our
examples throughout this article.

### Install OpenLDAP on Linux

Check to see if OpenLDAP is already running on your Linux machine issuing the
command:

```bash
service slapd status
```

If you get the following result, the OpenLDAP daemon slapd is running and you
can skip to the next section:

```text
slapd (pid 11424 11421 11420 11419) is running...
```

To install OpenLDAP get the latest installation package and follow the standard
installation procedure for your distribution.

### Configure OpenLDAP

The daemon slapd reads directory configuration information from the file
`/etc/openldap/slapd.conf`. We will add an ldbm database configuration as shown
below to the end of this file.

```conf
#######################################################################
# ldbm database definitions
#######################################################################
database     ldbm
suffix       "dc=my-domain,dc=com"
rootdn       "cn=Manager,dc=my-domain,dc=com"
rootpw       {SSHA}y2C4/ynzc1IOdFns2jt+nYX7m/ZKZPeP
directory    /var/lib/ldap
index        objectClass,uid,uidNumber,gidNumber,memberUid   eq
index        cn,mail,surname,givenname                       eq,subinitial
```

OpenLDAP can use various databases to store directory information. We will use
ldbm which uses a small footprint embedded database like Berkeley DB or GNU DB.
The data files are located in the folder `/var/lib/ldap` specified using the
directory attribute. The suffix attribute specifies the suffix of queries
executed against the database. The rootdn attribute specifies the root
distinguished name (like a root user in Unix). The rootpw attribute specifies
the password for the root user which in our case is secret and can be generated
by issuing the following command:

```bash
slappasswd -s secret
```

Restart the slapd daemon executing the following command:

```bash
service slapd restart
```

### Add Directory Information

We will now add information to the LDAP directory. The easiest way to do this is
to create a Lightweight Directory Interchange Format (LDIF) file and use the
ldapadd command, passing the file as an argument. Let us create an LDIF file
called `data.ldif` with the content shown below.

```conf
dn: cn=dkt,dc=my-domain,dc=com
objectclass: inetOrgPerson
cn: dkt
sn: Devendra Tewari
mail: tewarid@msn.com
userPassword: {SSHA}6YCHeWvWKrJh58jTEJZo7BHm1RiIChef
```

Let us now execute ldapadd to add the contents of `data.ldif` to the directory
by issuing the following command:

```bash
ldapadd -x -D "cn=Manager,dc=my-domain,dc=com" -W -f data.ldif
```

On execution, ldapadd should prompt you for a password, specify secret. For
details about ldapadd, see man ldapadd.

If you get the following output on executing the above command:

```text
adding new entry "cn=dkt,dc=my-domain,dc=com"
ldap_add: No such object
        additional info: parent does not exist
```

You will first have to add the parent directory, which you can do by
adding the following information to the LDAP directory:

```conf
dn: dc=my-domain,dc=com
objectClass: domain
dc: my-domain
```

To remove contents from the directory you can use the ldapremove command as
follows:

```bash
ldapdelete -x -v -n -D "cn=Manager,dc=my-domain,dc=com" -W "cn=dkt,dc=my-domain,dc=com"
```

To query the contents of the directory you can use the ldapsearch command. The
following command lists all the entries in the directory under the base DN
`dc=my-domain,dc=com`:

```bash
ldapsearch -x -b 'dc=my-domain,dc=com' '(sn=*)'
```

Softerra offers a free windows-based browser called
[LDAPBrowser](http://www.ldapbrowser.com/info_softerra-ldap-browser.htm) that
can be used to explore an LDAP directory. Another option is the open source Java
LDAP browser called [JXplorer](http://jxplorer.org/). JXplorer also lets you
create new entries in an LDAP directory.

### Access the LDAP Directory from Java

Java provides inbuilt support to access information from LDAP directories. We
will create a class called LDAPUtil whose primary purpose is to access an LDAP
directory and retrieve user information (id or login, name and email). The
source code of the class LDAPUtil is reproduced below.

```java
package util;

import java.io.*;
import java.util.*;

import javax.naming.*;
import javax.naming.directory.*;

public class LDAPUtil {
    public static final String DEFAULT_FILENAME = "ldap.properties";

    public static final String AUTH_NONE = "none";

    public static final String AUTH_SIMPLE = "simple";

    private String ldapServer;

    private String ldapContextFactory;

    private String authenticationType;

    private String securityPrincipal;

    private String password = "";

    private String userSearchContext;

    private String userIdAttribute;

    private String userNameAttribute;

    private String userEmailAttribute;

    private boolean secure = false;

    private DirContext context;

    public DirContext getContext() {
        return context;
    }

    public String getAuthenticationType() {
        return authenticationType;
    }

    public void setAuthenticationType(String authenticationType) {
        this.authenticationType = authenticationType;
    }

    public String getLdapContextFactory() {
        return ldapContextFactory;
    }

    public void setLdapContextFactory(String ldapContextFactory) {
        this.ldapContextFactory = ldapContextFactory;
    }

    public String getLdapServer() {
        return ldapServer;
    }

    public void setLdapServer(String ldapServer) {
        this.ldapServer = ldapServer;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isSecure() {
        return secure;
    }

    public void setSecure(boolean secure) {
        this.secure = secure;
    }

    public String getSecurityPrincipal() {
        return securityPrincipal;
    }

    public void setSecurityPrincipal(String securityPrincipal) {
        this.securityPrincipal = securityPrincipal;
    }

    public String getUserEmailAttribute() {
        return userEmailAttribute;
    }

    public void setUserEmailAttribute(String userEmailAttribute) {
        this.userEmailAttribute = userEmailAttribute;
    }

    public String getUserIdAttribute() {
        return userIdAttribute;
    }

    public void setUserIdAttribute(String userIdAttribute) {
        this.userIdAttribute = userIdAttribute;
    }

    public String getUserNameAttribute() {
        return userNameAttribute;
    }

    public void setUserNameAttribute(String userNameAttribute) {
        this.userNameAttribute = userNameAttribute;
    }

    public String getUserSearchContext() {
        return userSearchContext;
    }

    public void setUserSearchContext(String userSearchContext) {
        this.userSearchContext = userSearchContext;
    }

    public void initializeContext() throws IOException, NamingException {
        Hashtable env = new Hashtable();
        if (secure) {
            env.put(Context.SECURITY_PROTOCOL, "ssl");
        }
        env.put(Context.INITIAL_CONTEXT_FACTORY, ldapContextFactory);
        env.put(Context.PROVIDER_URL, ldapServer);

        env.put(Context.SECURITY_AUTHENTICATION, authenticationType);
        if (authenticationType.equals(AUTH_SIMPLE)) {
            env.put(Context.SECURITY_PRINCIPAL, securityPrincipal);

            if (password == null || password.equals("")) {
                BufferedReader in = new BufferedReader(new InputStreamReader(
                        System.in));
                System.out.print("Password: ");
                password = in.readLine();
                in.close();
            }
            env.put(Context.SECURITY_CREDENTIALS, password);
        }

        context = new InitialDirContext(env);
    }

    public void loadConfiguration() throws IOException {
        loadConfiguration(DEFAULT_FILENAME);
    }

    public void loadConfiguration(String filename) throws IOException {
        String value;
        Properties properties = new Properties();
        InputStream in;
        in = ClassLoader.getSystemClassLoader().getResourceAsStream(filename);
        if (in == null) {
            throw new RuntimeException(
                    "Failed to load LDAP configuration file " + filename + ".");
        }
        properties.load(in);
        ldapServer = properties.getProperty("ldapServer");
        ldapContextFactory = properties.getProperty("ldapContextFactory");
        authenticationType = properties.getProperty("authenticationType");
        securityPrincipal = properties.getProperty("securityPrincipal");
        password = properties.getProperty("password");
        userSearchContext = properties.getProperty("userSearchContext");
        userIdAttribute = properties.getProperty("userIdAttribute");
        userNameAttribute = properties.getProperty("userNameAttribute");
        userEmailAttribute = properties.getProperty("userEmailAttribute");
        value = properties.getProperty("secure");
        if (value == null || value.equals("false")) {
            secure = false;
        } else {
            secure = true;
        }
    }

    private Map extractData(NamingEnumeration attributes)
            throws NamingException {
        Map map;
        Attribute attribute;

        map = new HashMap();
        map.put("id", "");
        map.put("name", "");
        map.put("email", "");

        while (attributes.hasMore()) {
            attribute = (Attribute) attributes.next();
            if (attribute.getID().equals(userIdAttribute)) {
                map.put("id", attribute.get());
            } else if (attribute.getID().equals(userNameAttribute)) {
                map.put("name", attribute.get());
            } else if (attribute.getID().equals(userEmailAttribute)) {
                map.put("email", attribute.get());
            }
        }

        return map;
    }

    /**
     * List all users managed by an LDAP server.
     * 
     * @return Sorted list of users. Each element of the list is a map
     *         containing the attributes id, name, and email. The list is sorted
     *         by the name attribute.
     */
    public List findAllUsers() throws NamingException {
        NamingEnumeration users;
        Attributes match;
        SearchResult result;
        List list = new LinkedList();

        match = new BasicAttributes(true);
        match.put(new BasicAttribute(userNameAttribute));

        users = context.search(userSearchContext, match);

        while (users.hasMore()) {
            result = (SearchResult) users.next();
            list.add(extractData(result.getAttributes().getAll()));
        }

        // Sort List by attribute name
        Collections.sort(list, new Comparator() {
            public int compare(Object arg1, Object arg2) {
                Map map1 = (Map) arg1;
                Map map2 = (Map) arg2;
                return ((String) map1.get("name")).compareTo((String) map2
                        .get("name"));
            }
        });

        return list;
    }

    /**
     * Return attributes of a single user managed by an LDAP server.
     * 
     * @return Map containing the attributes id, name, and email. Null if user
     *         was not found.
     */
    public Map findUser(String id) throws NamingException {
        Attributes attributes;
        String name = "";
        String lastName = null;
        Map map = null;

        try {
            String search = userIdAttribute + "=" + id + "," + userSearchContext;
            attributes = context.getAttributes(search);
            map = extractData(attributes.getAll());
        } catch (NamingException e) {
            e.printStackTrace();
        }

        return map;
    }

    public static void main(String[] args) {
        LDAPUtil util = new LDAPUtil();
        try {
            util.loadConfiguration();
            util.setSecurityPrincipal("cn=Manager,dc=my-domain,dc=com");
            util.setPassword("embraer");
            util.initializeContext();
            List list = util.findAllUsers();
            Iterator iterator = list.iterator();
            while (iterator.hasNext()) {
                System.out.println(iterator.next());
            }
            System.out.println(util.findUser("dkt"));

            Attributes matchAttrs = new BasicAttributes(true);
            Attributes pwdAttrs = new BasicAttributes();
            matchAttrs.put(new BasicAttribute("userPassword",
                    "{SSHA}6YCHeWvWKrJh58jTEJZo7BHm1RiIChef"));
            util.getContext().modifyAttributes("cn=dkt,dc=my-domain,dc=com",
                    DirContext.REPLACE_ATTRIBUTE, matchAttrs);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

The class LDAPUtil has the following methods:

- loadConfiguration

    Loads attributes from a properties file.

- initializeContext

    Initializes the directory context with the authentication information
    supplied. Raises `AuthenticationException` or
    `AuthenticationNotSupportedException` if the authentication information
    (username or password) is wrong.

- findAllUsers

    Lists all users below the search context specified by
    setting the attribute `userSearchContext`.

- findUser

    Retrieve the full name and email of the user whose id is specified.

The find methods should be called only after the directory context has been
initialized by calling initializeContext. Before calling initializeContext the
class must be configured properly by calling loadConfiguration or the
appropriate getters and setters.

A sample properties file used by loadConfiguration to configure LDAPUtil
is shown below.

```conf
# LDAP server URL e.g. ldap://localhost:389
ldapServer = ldap://andromeda.cesar.org.br:389
# Whether secure access must be used
secure = false
# LDAP Initial Context Factory
ldapContextFactory = com.sun.jndi.ldap.LdapCtxFactory
# LDAP authentication type - use "simple" or "none"
authenticationType = simple
# User to bind to the directory
securityPrincipal = 
# Password of securityPrincipal
password = 
# Base DN for querying users
userSearchContext = dc=my-domain,dc=com
# Attribute for unique user id
userIdAttribute = cn
# Attribute for user name
userNameAttribute = sn
# Attribute for user mail address
userEmailAttribute = mail
```

We can also retrieve the `DirContext` using the getter method `getContext` and
use it to do other advanced stuff like update user passwords, as shown in the
example below.

```java
// Obtain user information using LDAP
NamingEnumeration answer =
    (ctx.getAttributes("cn=dkt,dc=my-domain,dc=com")).getAll();
while (answer.hasMore()) {
    Attribute attr = (Attribute)answer.next();
    System.out.println(attr.getID() + ": " + attr.get());
}

// List all users belonging to a particular group
Attributes matchAttrs = new BasicAttributes(true);
// ignore attribute name case
matchAttrs.put(new BasicAttribute("memberOf",
    "cn=administrators,dc=my-domain,dc=com"));
// Search for objects that have those matching attributes
answer = ctx.search("cn=dkt,dc=my-domain,dc=com", matchAttrs);
while (answer.hasMore()) {
    SearchResult res = (SearchResult)answer.next();
    System.out.println(res.getName());
}

// Change user password
// Note - need SSL to get this working with Windows 2000 Active Directory
Attributes pwdAttrs = new BasicAttributes();
matchAttrs.put(new BasicAttribute("userPassword", "test123"));
ctx.modifyAttributes("cn=dkt,dc=my-domain,dc=com",
    DirContext.REPLACE_ATTRIBUTE, pwdAttrs);
```

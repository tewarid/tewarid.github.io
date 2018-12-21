---
layout: default
title: Packaging source code using Grunt
tags: grunt nodejs
comments: true
---
# Packaging source code using Grunt

I have this very specific need to package source code of an Atmel Studio 6.2 project. For those not in the know, Atmel Studio 6.2 is based on Visual Studio Isolated Shell, and retains many of the features that make Visual Studio itself a neat IDE.

I had several choices for packaging the source code

1. Do it manually - that would have worked once or twice. Since I have to keep some files out of the source package, it would make repeated packaging an error-prone and time-consuming affair.

2. Use msbuild - I didn't find a convenient task native to msbuild for creating a zip file. Maybe I didn't look hard enough.

3. Use Apache Ant - I didn't want to include a Java dependency into my build and decided to let Ant go.

4. Use Grunt - I always seem to have Node.js installed, and find JSON for writing build instructions an interesting alternative to writing XML (verbose). Grunt is also quite portable. Grunt won.

The only files Grunt requires is a package.json file with the project configuration, and a Gruntfile.js with the build instructions.

You can create package.json by invoking `npm init` and providing some details about your project. Gruntfile.js can be hand-coded in any text editor. Here's my own script to get you started.

```javascript
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({

    pkg: grunt.file.readJSON('package.json'),

    compress: {
      main: {
        options: {
          archive: 'demo.zip'
        },
        files: [
          {
            expand: true,
            cwd: './',
            src: ['**', '!*/Debug/**', '!*/Release/**', '!node_modules/**', '!*.atsuo', '!**/file.h', '!demo.zip']
          }
        ]
      }
    }
  });

  // Load tasks
  grunt.loadNpmTasks('grunt-contrib-compress');

  // Default task(s).
  grunt.registerTask('default', ['compress']);

};
```

To invoke Grunt, you need to have grunt and its plugins installed. Use npm to download and install a project-local copy of these packages, and include them in your package.json as dependencies. In my case

```sudo
npm install grunt --save-dev
npm install grunt-contrib-compress --save-dev
```

That results in creation of of a node_modules folder in the root folder of the project. I don't add node_modules to version control. If you use git, add it to your `.gitignore`. Other developers can obtain dependencies listed in package.json by invoking `npm install` within the root folder.

You are now ready to invoke Grunt and execute the relevant tasks. In my case, invoking `grunt` results in creation of a demo.zip file containing all the files under the project root folder, minus whatever files and folders I choose to leave out.

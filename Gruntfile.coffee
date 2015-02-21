module.exports = (grunt) ->
  # Project configuration.
  PROJECT_FILES = 'src/**/*.coffee'
  COMPILED = 'build/pkg.js'
  COMPILED_LIB = 'build/lib.js'
  MINIFIED = 'build/pkg.min.js'
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    uglify:
      options:
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      main:
        src:  COMPILED
        dest: MINIFIED
    watch:
      main:
        files: [ PROJECT_FILES ]
        tasks: [ 'coffee', 'uglify' ]
        options: {}
    coffee:
      main:
        options:
          sourceMap: true
          join: true
        files: [
          src: [ PROJECT_FILES ], dest: COMPILED
        ]
    bower_concat:
      main:
        dest: COMPILED_LIB

  grunt.loadNpmTasks 'grunt-bower-concat'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'

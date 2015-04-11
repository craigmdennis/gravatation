"use strict"

# Include gulp
gulp            = require 'gulp'

# Include Our Plugins
del             = require 'del'
concat          = require 'gulp-concat'
uglify          = require 'gulp-uglify'
coffee          = require 'gulp-coffee'
rename          = require 'gulp-rename'
coffeelint      = require 'gulp-coffeelint'
gutil           = require 'gulp-util'
header          = require 'gulp-header'
bower           = require 'main-bower-files'
strip           = require 'gulp-strip-debug'

pkg             = require './package.json'

# Add a banner to the top of the file
banner = ['/**',
  ' * <%= pkg.name %> - <%= pkg.description %>',
  ' * @version v<%= pkg.version %>',
  ' * @link <%= pkg.homepage %>',
  ' * @license <%= pkg.license %>',
  ' */',
  ''].join('\n');


# Compile our CoffeeScript
gulp.task 'coffee', ['clean'], ->
  stream = gulp.src ['src/*.coffee']
    .pipe coffeelint()
    .pipe coffeelint.reporter()
    .pipe coffee()
    .on 'error', (err) ->
      console.error 'Error!', err.message
    .pipe header banner,
      pkg: pkg
    .pipe gulp.dest '.tmp'
    .pipe rename 'jquery.gravatation.js'
    .pipe gulp.dest 'dist'
    .pipe uglify()
    .pipe rename 'jquery.gravatation.min.js'
    .pipe strip()
    .pipe gulp.dest 'dist'


# Move our dependencies to the tmp folder
gulp.task 'dependencies', ['clean'], ->
  stream = gulp.src bower()
    .pipe gulp.dest '.tmp'


# Bundle our files up for production
gulp.task 'bundle', ['coffee', 'dependencies'], ->
  gulp.src ['.tmp/*.js']
    .pipe concat 'jquery.gravatation.bundled.js'
    .pipe gulp.dest 'dist'
    .pipe uglify()
    .pipe rename 'jquery.gravatation.bundled.min.js'
    .pipe strip()
    .pipe gulp.dest 'dist'


# Clean our output directory
gulp.task 'clean', (cb) ->
  del ['dist/*', '.tmp/*'], cb

gulp.task 'default', ['bundle']


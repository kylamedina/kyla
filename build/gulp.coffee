# REQUIREMENTS
gulp = require('gulp')
$ = require('gulp-load-plugins')(lazy: true)
browserSync = require('browser-sync')
runSequence = require('run-sequence').use(gulp)

onError = (error) ->
	$.notify.onError('ERROR: <%- error.plugin %>') error
	$.util.beep()
	$.util.log '======= ERROR. ========\n'
	$.util.log error
	
	
requireDir = require('require-dir')

# Require all tasks in gulp/tasks, including subfolders
requireDir './tasks',
  recurse: true

gulp.task 'watch', ['browser-sync'], ->
	# gulp.task 'watch', ->
	gulp.watch [ 'src/static/**/*' ], ['static']
	gulp.watch [ 'src/img/**/*' ], ['img']
	gulp.watch [ 'src/svg/**/*.svg' ], ['svg']
	gulp.watch [ 'src/styl/**/*.styl' ], ['styl']
	gulp.watch [ 'src/css/**/*.css' ], ['css']
	gulp.watch [ 'src/pug/**/*' ], ['pug']
	gulp.watch [ 'src/js/**/*' ], ['js']
	gulp.watch [ 'src/font/**/*' ], ['font']
	gulp.watch [ 'src/coffee/**/**/*.coffee' ], ['coffee']
	# gulp.watch [ 'src/pug/views/**/*.pug' ], ['templates']
	# gulp.watch [ 
	# 	'./build/styleguide/**/*', 
	# 	'./README.md',
	# 	'./app/css/**/*.css' 
	# ], ['styleguide']
	, {
			interval: 1000, # default 100
			debounceDelay: 1000, # default 500
			mode: 'poll'
		}
	

gulp.task 'default', (cb) ->
	runSequence 'install',
		'coffee',
		'styl',
		'pug',
		'css',
		'js',
		# 'font',
		'static', 
		'img', 
		'svg',
		# 'templates',
		# 'watch',
		# 'styleguide'
		->

gulp.task 'browser-sync', ->
	browserSync 
		# proxy: 'localhost:3000'
		port: 8080
		# server: false
		open: false
		tunnel: false
		online: true
		logConnections: true
		injectChanges: true
		ghostMode: false
		snippetOptions:
			rule:
				match: /<browsersync>/i,
				fn: (snippet, match) ->
					return snippet + match;
		files: [ 
			'app/**/*'
			# 'docs/styleguide/**/*'
		]
		server: {
			baseDir: [
				'app'
				# 'docs'
			]
		}

gulp.task 'clear', (done) ->
  $.cache.clearAll done

gulp.task 'static', ->
	gulp.src(['src/static/**/*'], { base: 'src/static/'})
		.pipe $.plumber(errorHandler: onError)
		.pipe gulp.dest('app/static/')

gulp.task 'install', ->
	return gulp.src(['./package.json'])
		.pipe $.install()


gulp.task 'js', ->
	return gulp.src(['./src/js/*.js'])
		.pipe($.order([
			'**/jquery-2.1.4.min.js'
			'**/jquery.pace.js'
			'**/jquery.easing.1.3.js'
			'**/jquery.easing.compatibility.js'
			'**/tweenMax.js'
			'**/jquery.owl.carousel.js'
			'**/jquery.wolf.min.js'
		]))
		.pipe($.accord('uglify-js', {
			beautify: false
			mangle: false
		}))
		.pipe $.concat 'app.js'
		.pipe gulp.dest 'app/js'
gulp = require('gulp')
$ = require('gulp-load-plugins')(lazy: true)
browserSync = require('browser-sync')

onError = (error) ->
	$.notify.onError('ERROR: <%- error.plugin %>') error
	$.util.beep()
	$.util.log '======= ERROR. ========\n'
	$.util.log error

# Stylus Plugins
# nib = require('nib')	
del = require('del')
axis = require('axis')
rupture = require('rupture')
jeet = require('jeet')
autoprefixer = require('autoprefixer-stylus')

gulp.task('styl', ['styl-watch']);

gulp.task 'css', ->
	return gulp.src('src/css/*.css')
		.pipe $.plumber(errorHandler: onError)
		.pipe $.concat 'vendor.css'
		.pipe($.cleanCss({debug: true}, (details) ->
			console.log(details.name + ': ' + (100 - (details.stats.minifiedSize/details.stats.originalSize)*100) + '% Saved');
			# console.log(details.name + ': ' + details.stats.minifiedSize);
		))
		.pipe gulp.dest 'app/css'

gulp.task 'styl-watch', ->
	return gulp.src('src/styl/index.styl')
		.pipe $.plumber(errorHandler: onError)
		.pipe $.accord('stylus', {
			use: [
				axis()
				jeet()
				rupture()
				# nib()
				autoprefixer()
			]
			include: ['src/styl']
			compress: true
			url:
				name: 'embedurl'
		})
		.pipe $.rename('style.css')
		# .pipe $.csscomb()
		# .pipe $.bless()
		.pipe gulp.dest('app/css')
		# .pipe browserSync.reload({stream:true})


gulp.task 'styleguide', ->
	StyleGuide = require('styleguidejs')
	sg = new StyleGuide
	sg.addFile 'app/css/main.css'
	sg.render
		extraCss: [ 
			'app/css/font.css'
		]
		extraJs: [ 
			'app/js/vendor.js', 
			'app/js/app.js', 
		]
		outputFile: 'docs/styleguide/index.html'

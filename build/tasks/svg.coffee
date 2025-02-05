gulp = require('gulp')
$ = require('gulp-load-plugins')(lazy: true)

onError = (error) ->
	$.notify.onError('ERROR: <%- error.plugin %>') error
	$.util.beep()
	$.util.log '======= ERROR. ========\n'
	$.util.log error
	
gulp.task 'svgmin', ['clean:svg'], ->
	gulp.src([
			'src/svg/**/*.svg'
		])
		.pipe $.plumber(errorHandler: onError)
		.pipe $.svgmin
			plugins: [
				{ cleanupIDs: false }
			]
		.pipe gulp.dest 'app/svg/'
		.pipe gulp.dest 'docs/styleguide/svg'

gulp.task 'svg', ['svgmin'], ->
	return gulp.src('src/svg/symbols/*.svg')
		.pipe $.plumber(errorHandler: onError)
		.pipe $.svgmin()
		.pipe $.svgstore(
			fileName: 'symbols.svg'
			inlineSvg: true
		)
		.pipe $.cheerio(
			run: (jQuery) ->
				jQuery('[fill]').attr 'fill', 'currentColor'
				# jQuery('[stroke]').attr 'stroke', 'currentColor'
			parserOptions:
				xmlMode: true
		)
		.pipe gulp.dest 'docs/styleguide/includes' 
		.pipe gulp.dest 'src/jade/layouts' 
		.pipe gulp.dest 'src/jade' 
		
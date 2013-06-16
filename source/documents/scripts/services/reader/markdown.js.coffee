angular.module("sideBySide").factory("markdownReader", () ->
	# Read markdown poem
	#
	# For sample input, see:
	# source/documents/tests/services/reader/markdown.js.coffee
	#
	# @param source [String] Markdown poem
	# @return [Object] Poem object
	return (source) ->
		# Read meta information from markdown block
		#
		# @param block [string] Meta block
		# @param inlineLexer [Object] Inline markdown lexer
		# @return [Object] Meta properties
		readMeta = (text, inlineLexer) ->
			meta = {}
			lexed = inlineLexer.output(text)
			for line in lexed.split("\n")
				match = /([^:]*):(.*)/.exec(line)
				meta[match[1].trim()] = match[2].trim()
			return meta

		# Read and remove one section from start of lexed blocks
		#
		# @param lexed [Array] Lexed blocks
		# @return [Array] Section
		readSection = (lexed) ->
			items = []
			while lexed.length > 0
				if lexed[0]["type"] == "heading"
					break
				items.push(lexed.shift())
			return items

		# Read content from lexed blocks
		#
		# @param lexed [Array] Lexed blocks
		# @return [Array] Content
		readContent = (lexed) ->
			content = []

			while lexed.length > 0
				if lexed[0]["type"] == "heading"
					heading = lexed.shift().text
				else
					heading = ''

				text = readSection(lexed)
				text.links = lexed.links
				content.push({
					section: heading
					text: marked.parser(text)
				})

			return content

		lexed = marked.lexer(source)
		meta = lexed.shift()
		inlineLexer = new marked.InlineLexer(lexed.links)

		return {
			meta: readMeta(meta.text, inlineLexer)
			content: readContent(lexed)
		}
)

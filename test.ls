require! {
	'expect.js'
	body: './index.js'
	σ: highland
}

Stream = σ!constructor # sigh
err = (e)-> σ (<| e)

export
	"Body parser":
		"returns a stream": ->
			expect (body.raw σ ["hello"]) .to.be.a Stream
		"resolves to the body": (done)->
			body.raw σ ["hello"]
			.to-array (xs)->
				expect xs .to.eql <[hello]>
				done!
		"resolves to the parsed body": (done)->
			body.json σ [JSON.stringify a:1]
			.to-array (xs)->
				expect xs.0 .to.have.property \a 1
				done!
		"passes stream errors to the stream": (done)->
			body.json err new Error "hello"
			.stop-on-error (err)->
				expect err.message .to.be "hello"
				done!
			.each ->
		"passes parse errors to the stream": (done)->
			(body.json σ ["not json"])
			.stop-on-error (err)->
				expect err .to.be.a SyntaxError
				done!
			.each ->

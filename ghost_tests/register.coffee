phantom.test.root = "http://localhost:3333" # you must specify your root.

phantom.test.add "Register", ->         # this adds a test
  @get '/', ->                              # this will get your a path relative to your root
    @body.input '#user_firstname', 'Tester'
    @body.input '#user_lastname', 'McTesty'
    @body.input '#user_email', 'test@example.com'
    @body.input '#user_password', 'secret'
    @body.input '#user_password_confirmation', 'secret'
    @body.click '.sign_up_button'
    #@body.assertFirst 'p', (p) ->           # this asserts the first paragraph's inner text
      #p.innerHTML == 'This is my paragraph' # is 'This is my paragraph'
    #@body.assertAll 'ul li', (li, idx) ->
      #li.innerHTML == "List item #{idx + 1}"
    @succeed()

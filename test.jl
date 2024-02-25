using Genie

# Define the form page
route("/") do
    html"""
    <html>
    <head>
        <title>Genie Hello World</title>
    </head>
    <body>
        <h1>Welcome to Genie!</h1>
        <form action="/process_text" method="post">
            <textarea name="user_text" rows="4" cols="50"></textarea><br>
            <input type="submit" value="Submit">
        </form>
    </body>
    </html>
    """
end

# Handle the form submission
route("/process_text", method=POST) do
    user_text = String(body(request))
    
    # Render a new page displaying the input contents
    html"""
    <html>
    <head>
        <title>Genie Hello World - Submitted Text</title>
    </head>
    <body>
        <h1>Submitted Text</h1>
        <p>You entered: $user_text</p>
    </body>
    </html>
    """
end

up(8888)

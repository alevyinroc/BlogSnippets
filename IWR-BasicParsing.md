#An Unexepected Side Effect of Invoke-WebRequest
Recently I was working on a bit of PowerShell to download the *awesome* First Responder Kit from Brent Ozar Unlimited. The canonical URL for the FRK is http://firstresponderkit.org/ *but* that's a redirect to the GitHub repository where all the magic happens. I thought to myself:

> Self! Rather than take a chance on that GitHub URL changing, use the "main" URL and `Invoke-WebRequest` will take care of the redirect for you.

So off to the PowerShell prompt I went and ran `Invoke-WebRequest -Uri  http://firstresponderkit.org/` to start looking at the object returned so I could see what I needed to parse out to find my way to the *true* download URL.

And then Firefox (my default browser) opened, and I was staring at `https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/tree/master`.

![Alt text](http://vignette2.wikia.nocookie.net/gta-myths/images/6/6d/Lol_wut.jpg/revision/latest?cb=20140121172907 "What?")

I was *expecting* an [`HTTP 30X` redirect status code](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#3xx_Redirection) which, based upon previous experience, `Invoke-WebRequest` would honor. Instead, I got a `200 OK` which is the web server saying "yep, here's your stuff, [HAND](http://acronyms.thefreedictionary.com/Have+a+nice+day)!"
[code language="powershell"]
```
Invoke-WebRequest -Uri http://firstresponderkit.org | Select-Object -ExpandProperty Headers


Key              Value
---              -----
x-amz-id-2       {QtTLMVw5QobGd/xlueEIY44Ech2va1ZKALhaMrY9f/yI0fBHvAoA6KwGUa5jTQxPF5fF85tuYws=}
x-amz-request-id {86A4E2A10548CA53}
Date             {Sat, 03 Jun 2017 16:14:47 GMT}
ETag             {"4ff7c8b410c399d5b18e2ab05bbfce22"}
Server           {AmazonS3}
```
[/code]
Hmmm...nope, nothing there. OK, in a past life I did some non-redirect redirects through page contents. Let's look at the content of the page itself (if any):

[code language="powershell"]

    Invoke-WebRequest -Uri http://firstresponderkit.org | Select-Object -ExpandProperty Content
[/code]
[code language="html"]
    
    <!DOCTYPE HTML>
    <html lang="en-US">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="refresh" content="1;url=https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/tree/master">
        <script type="text/javascript">
            window.location.href = "https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/tree/master"
        </script>
        <title>Page Redirection</title>
    </head>
    <body>
        If you are not redirected automatically, <a href="https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/tree/master">head over here.</a>
    </body>
    </html>
[/code]

Now we've got something. The web page itself has both a `meta` tag-based refresh/redirect and a JavaScript redirect, and that JavaScript redirect is being executed! How do we prevent the browser from opening and send the script to the right place?

Answer: the `-UseBasicParsing` switch for `Invoke-WebRequest`. From [the docs](https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.utility/invoke-webrequest):

>Indicates that the cmdlet uses the response object for HTML content without Document Object Model (DOM) parsing.

>This parameter is required when Internet Explorer is not installed on the computers, such as on a Server Core installation of a Windows Server operating system.

Note that this doesn't eliminate *all* parsing of the content. But what it *will* do is prevent the parsing/execution of the JavaScript that's embedded in the web page, which is what caused the browser to open in this case.

Looking closer at the output of `Invoke-WebRequest`, there's a `Links` collection that looks pretty good.

[code language="powershell"]

    (Invoke-WebRequest -Uri http://firstresponderkit.org).Links |Format-List

    outerHTML : <a href="https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/tree/master">head over here.</a>
    tagName   : A
    href      : https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/tree/master

[/code]

So now I can dig a little deeper and send my script to the URL that Brent & Co. want me to go to, and continue my search for the one true First Responder Kit download link by crawling subsequent pages.

[code language="powershell"]
    
    Invoke-WebRequest -UseBasicParsing -uri $((Invoke-WebRequest -Uri http://firstresponderkit.org).Links[0].href)
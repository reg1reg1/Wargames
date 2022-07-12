# Overview

![img](https://miro.medium.com/max/298/1*N6IwTg2eJS7wATQ4jWpeiA.png)

These set of challenges on the Wargames are focussed on Web Application Security Testing and Scanning. Each machine stores the credentials for the next machine. **All passwords are also stored in /etc/natas_webpass/**. 

These challenges start out easy, but some of these really took me some time before I figured out the solution to them, sometimes days as I am a beginner at these. Here are the solutions/approaches I used for tackling these challenges. I have not been overly elaborate, and these serve as push in the right direction, and I have avoided providing direct solutions or screenshots. This is so I can visit them later for

# Natas 1

To move to Natas1, we just need to view the source code.

# Natas 2

To get to the next level open up the browser console.

# Natas 3

Inspection of source reveals the files directory which seems to be not a MVC route We see that images is being served from the URL **/files/{imgName}**. If we try to access the files directory we realize, that it can be accessed and traversed. We can then view the file **users.txt** to get the credentials for the next level.

# Natas 4

In web applications , **robots.txt** is a file which instructs web-crawlers and web-spiders. In many web-applications , they can reveal useful information for URL’s. Here the a disallowed directory is revealed. On traversing the directory , the secret file is revealed containing the next set of credentials required for Natas4.

# Natas 5

The referer header can be spoofed to have access to Natas5.

# Natas 6

The request header has a value called **loggedin**, this can be spoofed and the access is granted revealing the credentials for the next challenge.

# Natas 7

The source code can be viewed. The secret is being imported from a file as revealed in the PHP source code. This file can be accessed from the URL. When we input the secret in the file, we get the credentials to Natas 7.

# Natas 8

Simple directory traversal, the hint hidden in source code here too. Interesting fact is that the natas site itself has a Web Application Firewall,which detects the malicious URL’s and blocks them. The request parameter **page** is injectable, and a directory traversal with

```bash
../../../../../../../../../etc/natas_webpass/natas8
```

helps reveal the credentials to Natas8

# Natas 9

The source code reveals the process of encoding the secret. It is a mix of hex, base64, and reversing. We have to just reverse it, and we all know **Encoding is not encryption**

# Natas 10

This is a plain and simple command injection. No filters, No WAF, No encoding , and you can cat the file from the /etc/natas_webpass/natas10 to get to the actual file.

# Natas 11

To get to natas11, we need to bypass the blacklisting and fetch the password Any exception will reveal the source code. The grep commands needs to be bypassed

This basically reduces to a grep injection. Originally the command is supposed to function as:

```bash
grep -i $key fileName
```

What we are doing is appending a widlcard in the $Key (to be able to search) all patterns and we inject so that we can replace then filename with a name of our choosing which is the password file. The input needed here to accomplish this is

```bash
^ /etc/natas_webpass/natas11
```

# Natas 12

Here we need to inspect the cookie being used, and understand how we can modify it, by using a cookie tamper tool or BurpSuite to get credentials for natas12. We know that the cookie’s encryption mechanism which is XOR. This challenge is more of a crypto challenge , than a web challenge. To those of you who are unaware of XOR, it is a mathematical operator with truth table that adheres to the following rule.

```yacas
A XOR B is True only if exactly 1 bit is set. (Exclusive OR)
```

Xor has an interesting property, and many studying elemental cryptogtraphy, know about it the first thing in the process. It is it’s own inversion function. XOR(XOR(A,B),B) = A.

Inspecting the cookie closely, we see there are two values.

1. **showpassword**
2. **bgcolor**

The cookie is being sent and then decrypted, and we are not able to supply the plaintext value of showpassword (alter showpassword in the clear), just the bgcolor value.

So , the goal really here is to get the cookie to decrypt as the desired Plaintext. The thing with XOR here, is that the **key** is being reused. If the key is randomly changing, it is OTP, and strongest encryption scheme (Perfect Secrecy).

Let’s use this convention : PText-> X, Key->y, and Cookie Z So, X xor Y = Z

If we choose a certain color, and we know the showpassword is false. So we know X. We can see the cookie once it has been set, so we know Z

We know from the property of XOR,
X xor Y xor X = Z xor X , which is Y = Z xor X. Now if we get Y, we can get a desired cookie of our choice. How? We can create our own cookie with showpassword as true. Some helper code has been written below , this is to calculate the key. You can obtain the cookie value by using tamperCookie tool on Chrome/ tamper Monkey on firefox or use BurpSuite.

```php
echo json_encode($defaultdata);//encrypt it to obtain the key, we are calculating z xor x
function xor_encrypt($in) {
    $key = base64_decode('ClVLIh4ASCsCBE8lAxMacFMZV2hdVVotEhhUJQNVAmhSEV4sFxFeaAw');
    $text = $in; 
    $outText = ''; // initialization of the outtext
    // Iterate through each character
    for($i=0;$i<strlen($text);$i++) {
    $outText .= $text[$i] ^ $key[$i % strlen($key)]; // looks like key us smaller than the message length
    }
    return $outText; //encrypted outtext
}
echo xor_encrypt(json_encode($defaultdata)); // this will print the key as qw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8Jq
```

Now , we will get the key after the above, we can create our cookie and set it using the aforementioned tools. Cookie generating helper code has been shown below.

```php
//Fetching the cookie is easy we want the cookie for this modified default data
//We have y , now for a desired input x' as shown below we calculate z' as y+x'=z'
$defaultdata = array( "showpassword"=>"yes", "bgcolor"=>"#ffffff");function get_cookie($in){
//Made the key equal to cookie length(Which makes this Vignere Cipher)
$key="qw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8";
$text = $in; 
    $outText = ''; // initialization of the outtext
    // Iterate through each character
    for($i=0;$i<strlen($text);$i++) {
    $outText .= $text[$i] ^ $key[$i % strlen($key)]; // looks like key us smaller than the message length
    }
    return base64_encode($outText);}
echo "\n\n\n\n";
//Solved
echo get_cookie(json_encode($defaultdata));
```

This was my favorite challenge so far.

# Natas 13

This one requires a file upload, and basically the option to upload what we term as a web shell or a php backdoor. The file name is randomly chosen on the front end, but we can modify by using web proxy like BurpSuite and accessed to bypass the frontend file check. The php backdoor can be found online, or generated by metasploit.

# Natas 14

This one uses a function called exif-imagetype. There are multiple ways to bypass this One way is to embed php code in a valid image file. There is a check on the file name on the server side, and the header is how the type verification is being done.The other way is to bypass the file check by adding few headers, which fool the file type check. The headers are \xFF\xD8\xFF\xE0 (python way of writing hex) which are correspond to imagetype jpg and fool the exif_imagetype functions. Once these headers are in place, you can upload the file as before (in natas13)and proceed as usual.

# Natas 15

This is a simple SQL injection. No filters, no encoding, no web application firewalls. Go with

```
a" or 1=1 #
```

as both username and password.
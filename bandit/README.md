# Bandit
These are the easiest problems of the wargame prepping us for the reverse engineering and tougher challenges that lie ahead. We have a series of 34 machines to ssh into, and each machine holds the password to the next machine. It is highly recommended to solve the challenges on your own before proceeding to look for the solution. The solutions provided are for educational purposes only. The flags are in the file , bandit_flags.txt.

Useful  Resources are(not exhaustive in any sense).
<ul>
	<li>
		<a href="https://www.gnu.org/software/sed/manual/sed.html">SED Manual</a>
	</li>
	<li>
		<a href="https://linuxize.com/post/how-to-use-linux-screen/#detach-from-linux-screen-session">Using screen, a terminal multiplexer</a>
	</li>
	<li>
		<a href="https://linux.die.net/man/">Linux Man pages</a>
	</li>
</ul>
<ul>
	<li>
		<h3>Bandit0</h3>
		Simply cat of the file, which reveals the flag. 
	</li>
	<li>
		<h3>Bandit1</h3>
		The filename has hyphen. So "cat" has to be told the filename is not a aprameter, so it was fed from the stdin using the following command.
		<pre>
			cat &lt -
		</pre>
		The flag is then revealed.
	</li>
	<li>
		<h3>Bandit2</h3>
		There are spaces in the filename. Easier than the last one, use cat "spaces in the filename".
	</li>
	<li><h3>Bandit3</h3>
		The file is hidden, and seeing the hidden files via 
		<pre>
			ls -al 
		</pre>
		will reveal the name of the file which can be then read
	</li>
	<li>
		<h3>Bandit4</h3>
		Familiarity with the usage of the <b>find</b> command in UNIX.
		More information can be found on the man page of the find command.
		which can be used to even chain executing commands on the results of the find like below
		The file command gives details about the files in the directory. So? We can pipe the results of the find command to the file command and voila.
		<pre>
			man file
		</pre>
		For finding executable one can use this, (is certainly one of the cleaner ways to do this)
		<pre>
			find -type f | xargs file | grep text
		</pre>
		We use the find command to restrict the file size, and specify that we are looking for a file
		and then pipe it to xargs file (Argument of file command), then using gre[]
	</li>
	<li>
		<h3>
			Bandit5
		</h3>
		Simple modification of the challenge 4. Only catch is implemented in the size command which cna be used by -size option. The command to be used here is as follows.
		<pre>
			find -type f | xargs file | grep text
		</pre>
	<li>
		<h3>
			Bandit6
		</h3>
		We can use the find command to locate the necessary group and username owner of the file.
		<pre>
			find / -user bandit7 -group bandit6 -size 33c 2&gt/dev/null
		</pre>
	</li>
	<li>
		<h3>
			Bandit7
		</h3>
		No find command required, since it is already given to us. We can use awk, or sed to search for strings within the fiel, but in this case simple grep can do the job. 
		<pre>
			sed -n '10,$ { /millionth/ { =; p; } }' data.txt
		</pre>
	</li>
	<li>
		<h3>
			Bandit8
		</h3>
		We have to find a non unique line. We can use <i>uniq</i> command, but it only works on adjacent lines so we need to sort. Hence the following chain.
		<pre>
			sort data.txt | uniq -u
		</pre>
	</li>
	<li>
		<h3>Bandit9</h3>
		Find a human readable line within a file (ASCII Text), which begins with "==". Here we can use the <i>strings</i> command, followed by a grep.
		<pre>
			strings data.txt | grep ^==
		</pre>
	</li>
	<li>
		<h3>Bandit10</h3>
		Simple base64 decode of the data present in data.txt
		<pre>
base64 -d data.txt 
		</pre>
	</li>
	<li>
		<h3>Bandit11</h3>
		Using sed, which is a beast of a tool. One may use <i>tr</i> tool as well
		<pre>
sed -e "y/${alpha}/${alpha:$rot}${alpha::$rot}/" -e "y/${beta}/${beta:$rot}${beta::$rot}/" data.txt
		</pre>
		What sed is basically a stream editor
		First of all there are 2 stream editor  expressions in place.
	</li>
	<li>
		<h3>Bandit12</h3>
		The challenge basically involves uncompressing a file which has been compressed multiple times, using different forms of compression. One could write a program to uncompress the file automatically based on the compression types. 
		The whole idea is to identify the file compression type , and then uncompress accordingly.
		Since it is in the hexdump representation of a file, the first step would be to get the file back from the hex representation.</br>
		<b>Steps</b>
		<ul>
		<li>
		Create a copy of the file and move it to a created directory in /tmp. This is because the directory in which the file is located in does not have write access for the user. 
		</li>
		<li>
			<p> xxd is an utility that helps reverse and generate hexdumps of files.</p>
			<pre>
			xxd -revert data &gt datahex
			</pre>
		</li>
		<li>
		These are the sequence of commands that were performed to uncompress a file. Each one is preceded by checking the file type of the output using the <i>file</i> command.
		<pre>
        zcat revhex &gt data_zcatted
        bzip2 -d data_zcatted
        zcat data_zcatted.out &gt data_zcatted_again
        tar -xvf data_zcatted_again
        tar -xvf data5.bin
        bzip2 -d data6.bin
        tar -xvf data6.bin.out
        zcat data8.bin &gt data8_zcatted
	</pre>
	</li>
	</ul>
	</li>
	<li>
	<h3>Bandit13</h3>
	Simple ssh using an already present and generated private RSA key for the next user.
	<pre>
		ssh -i sshkey.private bandit14@localhost
	</pre>
	</li>
	<li>
		<h3>Bandit14</h3>
		This was done by viewing the password of the users contained in the folder /etc/bandit_pass
		for the current user and submitting it via telnet
	</li>
	<li>
		<h3>Bandit15</h3>
		The ssh version of the above challenge. The only challenge is to incorporate a new line character after the banner is sent by the server. 
		<pre>
		openssl s_client -ign_eof -connect localhost:30001
		</pre>
		The flag <i>"ign_eof"</i> is used to allow for end of line to be entered to terminate the condition. 
	</li>
	<li>
		<h3>Bandit16</h3>
		Using nmap we can find out a range of open ports that support ssh
		<pre>
		nmap  -A -T4 -p 31000-32000 localhost
		</pre>
		After we get to know the port on which ssl is running, the tmp directory gets the sshkey.private being returned by the server, which is the private key of user <i>bandit17</i>
		The server will be running on some port which is not an echo server. Use openssl to connect to this ssh server in the eof mode as described in Bandit15. On entering the correct password, the server will reply back with an RSA private key for bandit user 17.
		<p>
		Copy the contents, create a file in the <i>tmp</i> directory.
		<b>Note: Change the permissions of the newly created file to be restrictive of read and write privilleges to only the current user or the ssh will reject the file as being too "unprotected". I set the permission to file to <i>700</i>.</b> 
		</p>
	</li>
	<li>
		<h3>Bandit17</h3>
		Simple diff command of the 2 files will pop out the answer.
	</li>
	<li>
		<h3>Bandit18</h3>
		The machine logs you out as mentioned in the description due to changes in .bashrc which happens when user profile is loaded after a successful login. This can be overcome by chaining a command to ssh to be executed after successful login.
		<pre>
			ssh bandit18@localhost "cat readme"
		</pre>
	</li>
	<li>
		<h3>Bandit19</h3>
		The knowledge of <i>setuid</i> and <i>getuid</i> is useful. The commands basically allows users to execute certain executables as other users or groups and the command is used to set the appropriate bit on  the executable. For next level, the executable will allow us to read the bandit20's pass. Anyone executing the executable will run it as if it were bandit20 user running the executable. 
		<pre>
		./&gtexecutable name&lt cat /etc/bandit_pass/bandit20
		</pre>
	</li>
	<li>
		<h3>Bandit20</h3>
		 	Using the same principles as above, except setup a netcat background process or use 2 parallel terminals. However since parallel terminals will lead to 2 different sessions and we want the output back from a process, I used a terminal multiplexer, like <i>screen</i>.
		 	Firstly we create a session using one ssh login. Then we setup a separate instance of screen, by using the tool <i>screen</i>. Once done, we setup a netcat listen as under.
		 	<pre>
nc -l -p 44444
		 	</pre>
		 	Detach from this screen by pressing <kbd>CTRL</kbd>+<kbd>a</kbd>,<kbd>d</kbd>.
		 	Then start another screen, and run the executable to connect to the running netcat shell which will return the pass of user <i>bandit20</i> to the ssh connection. The need of the multiplexer here is because, if we create a separate ssh session, the sessions will be sperate terminal wise and hence we cannot see any data or information from the other terminal. 
		 	It will occur not immediately but after a while that we need to have the terminal to somehow split or multiplex but for the same session. This made me look up terminal multiplexers, and also they had hinted the tool in the challenge as well which pushed me in the right direction.
		 	<pre>
		 	./suconnect &ltportnumber&gt 	
		 	</pre>
		 	Reattach to the netcat screen using
		 	<pre>
		 		screen -r &ltscreenid&gt
		 	</pre>
		 	Doing this will give you the output on the screen which is pass of <i>bandit21</i>
		</li>
		<li>
			<h3>Bandit21</h3>
			Examining the cronjob we know it is run every minute and , simply we need to examine the script being executed and then we know the directory/filename of the stored password. 
		</li>
		<li>
			<h3>Bandit22</h3>
			Simple variation in which the value of the directory is not hardcoded, we need to run the code with the variable as "bandit23" instead of the current user.
			The file cannot be executed by any user other than cron and bandit23, so when we can do a line by line execute on the bash shell and recover the directory.		
		</li>
		<li>
			<h3>Bandit23</h3>
			The cron is calling a script (cannot be editied), which is deleting all the scripts in <i>/var/spool</i> after executing them. The trick is to place a script there which fetches the bandit24 password (since cron is of bandit24 it can do so), and place it in <i>"/tmp"</i> in some file. The important thing is that even though cron is executing a script under bandit24, the file created in /tmp will be accessible.
			The script can be found at <a href="Insert link here">bandit23.sh</a>.
		</li>
		<li>
			<h3>Bandit24</h3>
			Easy as before, instead of a simple script , we need to bruteforce the pins which ranges from 0000 to 9999. We need to write a simple bash or python script to bruteforce a netcat connection. A further improvement which is desired, is to utilize a single instance of netcat. 
			Refer to the code for reference which is in bash. <a href="">bandit24.sh</a>
		</li>
		<li>
			<h3>Bandit25</h3>
			By far the most creative challenge of the lot, the problem is we get logged out as soon as we use the ssh key to login. Unlike one of the previous challenges, this is not a <i>.bashrc</i> or a <i>.bash_profile</i> issue. The issue is the shell of the user which is logging us out. We can see the shell of the user by: <br>
			<pre>
cat /etc/passwd
			</pre>
			This reveals that the shell of the user is a custom script and its location as well. On reading the custom script, we find that it is a simple <i>more</i> command calling a file.When the more command terminates, exit 0 is called logging us out.
			Now, <i>more</i> somewhat like less is a scrolling command which loads a page bit by bit on a small window. Once we have this, we have to find a way to halt at <i>more</i>, so that "exit 0" is not hit. We can do this by minimizing our terminal, and then more will proceed step by step. Once it is done, we can break "more" by using "v".
			<p>On pressing <kbd>v</kbd>, we are in Vim, we can edit a file by typing <kbd>:e</kbd>
			   Then we can simply read the pass by specifying the file path of the password.
			</p>
		</li>
		<li>
			<h3>Bandit26</h3>
			This is a continuation of the previous challenge. We can get the password of bandit26, but for getting password of bandit27 , we need to break out of the shell. 
			If we do a simple,<i><b>:shell</b></i>, then we get back the original shell with <i>more</i>, making us go back to square one. So , to do this we have to set the shell variable to <i>/usr/bin/bash></i>. We can do so by doing by <pre>
set shell=/usr/bin/bash
			</pre>
			Once this is done we can break out of the shell, do a simple <i>ls</i> and get the password of the next user.
		</li>
		<li>
			<h3>Bandit27</h3>
			The challenges from <i>Bandit27-Bandit31</i>, require the basic know how of how version control systems work, especially git. If you don't know, then there is no point wasting time to solve these challenges. A basic knowhow will atleast enable one to understand what is happening and why.
			A simple git cloning will reveal the username and password of the next user. The command is as under.
			<pre>
git clone &ltURL&gt /tmp/&ltsomedirectory&gt
			</pre>
		</li>
		<li>
			<h3>Bandit28</h3>
			Similar to above but here, this was comitted previously. Using the command <i>git log</i>(inside the directory cloned) after cloning the directory will reveal us the commit history.
			Select the tag in which the password was removed from the Readme.md file and use the command <i>git show &lttagname&gt</i>.
		</li>
		<li>
			<h3>Bandit29</h3>
			In this case doing <i>git log</i> will show the commit history but will not show any intersting commits. The hint lies in the <i>Readme.md</i> file itself which says no passwords in production. This hints that we are seeing a different "branch". Doing a <pre>
			git show-ref
			</pre>
			Then we get to know the commits and references across branches. Again using git show as described above we can get the required commit under "dev" branch which is short for development, revealing to us the password.
		</li>
		<li>
			<h3>
				Bandit30
			</h3>
			This involves a tag with a broken commit, which prevents checkout or cloning. This tag can be viewed by using our friend the git-show command as well as before.
		</li>
		<li>
			<h3>Bandit31</h3>
			This is a simple add, commit and push. Add the file, commit it then push it. The verbose message from the remote will contain the password
		</li>
		<li>
			<h3>Bandit32</h3>
			This final challenge is a bit tricky, and there are multiple approaches to solving this which may be far more creative than what I did. Basically we are in a custom shell, which converts everything that we type to upper-case rendering every command useless. We can't do "ls" or "cd". Intuitively, this script or shell must have been called by some parent process or script. Using $0 will call the parent script from within. Since "0" and 
			"$" are not alphabets, the shell will let us drop back in to the parent "sh" shell.
		</li>
	</li>
	</li>
	</ul>

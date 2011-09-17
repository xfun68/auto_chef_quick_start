Auto Chef Quick Start
=====================
Automaticlly replay the process of [Quick Start][chef_quick_start] on Chef wiki.

How do I play with it?
----------------------
If you really want to give it a try, please follow the steps shown as below:

1. Get your chef files, please follow [this][how_to_get_chef_files] if you do not have them yet.
2. cd /some/path/where/you/want/to/play/in/it
3. git clone git@github.com:xfun68/auto_chef_quick_start.git
4. cd auto_chef_quick_start
5. cp ~/Downloads/CHEF_USERNAME.pem ~/Downloads/CHEF_ORGANIZATION-validator.pem ~/Downloads/knife.rb config/
6. ./go.sh
7. Go for a cup of tea or coffee, remember to get back after 10 minutes. :)

FYI, you must have these tools installed correctly on your system, they are:

  * build-essential(for Ubuntu) or xcode(for Mac OS X)
  * RVM
  * git-core
  * ree or other versions of ruby(1.8.7+)
  * gem(1.3.7+)
  * VirtualBox(4.1.0+)


[chef_quick_start]: http://wiki.opscode.com/display/chef/Quick+Start "Chef Quick Start"
[how_to_get_chef_files]: http://wiki.opscode.com/display/chef/Setup+Opscode+User+and+Organization "How to get chef files?"


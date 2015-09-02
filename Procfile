thin:    bundle exec thin start -p $PORT
worker:  bundle exec rake resque:work TERM_CHILD=1 QUEUE=directory

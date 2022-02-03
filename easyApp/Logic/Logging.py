__author__ = "github.com/AndrewSazonov"
__version__ = "0.0.1"

import os
import sys
import tempfile
import logging


class StreamToLogger(object):
   """
   Fake file-like stream object that redirects writes to a logger instance.
   """
   def __init__(self, logger, log_level):
      self.logger = logger
      self.log_level = log_level
      self.linebuf = ''

   def flush(self):
      pass

   def write(self, buf):
      for line in buf.rstrip().splitlines():
         self.logger.log(self.log_level, line.rstrip())

# Remove old log
log_filepath = os.path.join(tempfile.gettempdir(), 'easydiffraction.log')
print(f'Log file: {log_filepath}')
if os.path.exists(log_filepath):
    os.remove(log_filepath)

# Logging config
logging.basicConfig(
    level=logging.WARNING,
    format='%(asctime)s %(levelname)8s %(name)-10s %(filename)-15s %(funcName)-20s %(lineno)4d %(message)s',
    filename=log_filepath,
    filemode="w"
)

# Stdout -> logging
stdout_logger = logging.getLogger('stdout')
sl = StreamToLogger(stdout_logger, logging.WARNING)
sys.stdout = sl

# Stderr -> logging
stderr_logger = logging.getLogger('stderr')
sl = StreamToLogger(stderr_logger, logging.ERROR)
sys.stderr = sl

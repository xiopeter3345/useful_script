#!/usr/bin/python

import xml.etree.ElementTree
from xml.etree.ElementTree import Element, ElementTree
import os

def get_hdp_version():
	hdp_dir = [f for f in os.listdir('/usr/hdp') if os.path.isdir(os.path.join('/usr/hdp',f)) and f[:1].isdigit()]
	return hdp_dir[0]

if __name__ == '__main__':
	hdp_version = get_hdp_version()
	config_path = '/usr/hdp/' + hdp_version + '/storm/log4j2/worker.xml'
	tree = xml.etree.ElementTree.parse(config_path)
	loggers = tree.getroot().findall('loggers')[0]
	logger_collection = loggers.findall('Logger')
	
	# change LoggingMetricsConsumer logging level

	for logger  in logger_collection:
		if logger.attrib['name'] == 'org.apache.storm.metric.LoggingMetricsConsumer':
			logger.set('level', 'warn')

	# add property to change ScpNetBolt

	appender=Element('appender-ref', {'ref':'A1'})
	scp_net_bolt_logger = Element('Logger', {'name':'microsoft.scp.storm.bolt.ScpNetBolt', 'level':'warn', 'additivity':'false'})
	scp_net_bolt_logger.append(appender)
	loggers.append(scp_net_bolt_logger)
	tree.write(config_path)
	
	

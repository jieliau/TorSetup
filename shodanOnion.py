from shodan import Shodan
import re
import configparser

### Load secret info ###
config = configparser.ConfigParser()
config.read('secret.ini')
apiKey = config['Secret']['apiKey']

api = Shodan(apiKey)

for res in api.search_cursor('.onion'):
    
    try:
        result = re.search(r'([^\s]+\.onion)', res['data']).groups()[0]
        print(res['ip_str'], result)
    except:
        continue


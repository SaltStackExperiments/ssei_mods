import salt.utils.http as http


def get_pub_ip():
    resultats = http.query('http://checkip.amazonaws.com')
    return {'pub_ip': resultats['body']}

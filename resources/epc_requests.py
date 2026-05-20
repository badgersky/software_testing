import requests


class epc_requests:

    def __init__(self, base_url):
        self.base_url = base_url

    def get_ues(self):
        resp = requests.get(self.base_url)
        return resp.json()

    def get_ue(self, id):
        resp = requests.get(f'{self.base_url}/{id}')
        return resp.json()

    def attach_ue(self, id):
        payload = {'ue_id': id}
        resp = requests.post(self.base_url, json=payload)
        return resp.json()

    def reset_simulator(self):
        resp = requests.post(self.base_url.replace('/ues', '/reset'))
        return resp.status_code == 200
    
    def get_ues_stats(self):
        resp = requests.get(f'{self.base_url}/stats')
        return resp.json()
    
    def detach_ue(self, id):
        payload = {'ue_id': id}
        resp = requests.delete(f'{self.base_url}/{id}', json=payload)
        return resp.json()
    

if __name__ == '__main__':
    req = epc_requests('http://localhost:8000/ues')
    print('attach_ue:')
    print(req.attach_ue(2))
    print(req.attach_ue(3))
    print(req.attach_ue(5))
    print(req.attach_ue(150))
    print('get_ue:')
    print(req.get_ue(2))
    print(req.get_ue(3))
    print(req.get_ue(150))
    print('get_ues:')
    print(req.get_ues())
    print('get_ues_stats:')
    print(req.get_ues_stats())
    print('detach_ue:')
    print(req.detach_ue(2))
    print(req.detach_ue(14))
    req.reset_simulator()

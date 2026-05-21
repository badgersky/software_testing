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
    
    def add_bearer(self, id, b_id):
        payload = {'bearer_id': b_id}
        resp = requests.post(f'{self.base_url}/{id}/bearers', json=payload)
        return resp.json()
    
    def delete_bearer(self, id, b_id):
        payload = {'ue_id': id, 'bearer_id': b_id}
        resp = requests.delete(f'{self.base_url}/{id}/bearers/{b_id}', json=payload)
        return resp.json()
    
    def start_traffic(self, id, b_id, prot, Mbps, kbps, bps):
        payload = {
            "protocol": prot,
            "ue_id": id,
            "bearer_id": b_id
        }
        if Mbps:
            payload['Mbps'] = Mbps
        if kbps:
            payload['kbps'] = kbps
        if bps:
            payload['bps'] = bps

        resp = requests.post(f'{self.base_url}/{id}/bearers/{b_id}/traffic', json=payload)
        return resp.json()

if __name__ == '__main__':
    req = epc_requests('http://localhost:8000/ues')
    print('\nattach_ue:')
    print(req.attach_ue(2))
    print(req.attach_ue(3))
    print(req.attach_ue(5))
    print(req.attach_ue(150))
    print('\nget_ue:')
    print(req.get_ue(2))
    print(req.get_ue(3))
    print(req.get_ue(150))
    print('\nget_ues:')
    print(req.get_ues())
    print('\nget_ues_stats:')
    print(req.get_ues_stats())
    print('\ndetach_ue:')
    print(req.detach_ue(2))
    print(req.detach_ue(14))
    print('\nadd_bearer:')
    print(req.add_bearer(3, 2))
    print(req.add_bearer(3, 3))
    print(req.add_bearer(3, 1))
    print(req.add_bearer(3, 4))
    print(req.add_bearer(14, 2))
    print('\ndelete_bearer:')
    print(req.delete_bearer(3, 2))
    print(req.delete_bearer(14, 1))
    print(req.delete_bearer(3, 1))
    print(req.delete_bearer(3, 10))
    print('\nstart_traffic:')
    print(req.start_traffic(3, 3, "udp", 10, 0, 0))
    print(req.start_traffic(3, 10, "udp", 10, 0, 0))
    print(req.start_traffic(14, 3, "udp", 10, 0, 0))
    print(req.start_traffic(3, 3, "udp", 0, 0, 0))
    print(req.start_traffic(3, 3, "lol", 0, 0, 0))
    print(req.start_traffic(3, 4, "tcp", 2, 2, 0))
    req.reset_simulator()

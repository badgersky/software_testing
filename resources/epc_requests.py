import requests


class epc_requests:

    def __init__(self, base_url):
        self.base_url = base_url

    def get_ues(self):
        resp = requests.get(self.base_url)
        if resp.status_code == 200:
            return resp.json()['ues']
        return

    def get_ue(self, id):
        resp = requests.get(f'{self.base_url}/{id}')
        if resp.status_code == 200:
            return resp.json()
        return

    def attach_ue(self, id):
        payload = {"ue_id": id}
        resp = requests.post(self.base_url, json=payload)
        if resp.status_code == 200:
            return True
        return False

    def reset_simulator(self):
        resp = requests.post(self.base_url.replace('/ues', '/reset'))
        return resp.status_code == 200
import requests

def get_ues(url):
    resp = requests.get(url)
    if resp.status_code == 200:
        data = resp.json()
        return data['ues']
    return

def get_ue_by_id(url, id):
    resp = requests.get(f'{url}/{id}')
    if resp.status_code == 200:
        data = resp.json()
        return data
    return

def attach_ue(url, id):
    payload = {"ue_id": id}
    resp = requests.post(url, json=payload)
    if resp.status_code == 200:
        data = resp.json()
        return True
    return False

if __name__ == '__main__':
    url = 'http://10.0.40.5:8000/ues'
    print(get_ues(url))
    print(get_ue_by_id(url, 1))
    # print(attach_ue(url, 4))
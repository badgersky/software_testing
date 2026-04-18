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

if __name__ == '__main__':
    ues_url = 'http://10.0.40.5:8000/ues'
    signle_ue_url = 'http://10.0.40.5:8000/ues'
    print(get_ues(ues_url))
    print(get_ue_by_id(signle_ue_url, 1))
# EPC Simulator – testy automatyczne

Repozytorium zawiera automatyczne testy API dla aplikacji **Evolved Packet Core (EPC) Simulator**. Symulator odwzorowuje podstawowe operacje sieci rdzeniowej 4G LTE, m.in. podłączanie i odłączanie UE, zarządzanie bearerami oraz uruchamianie, zatrzymywanie i sprawdzanie transferu.

Testy są przygotowane w **Robot Framework** i korzystają z biblioteki pomocniczej w Pythonie opartej o `requests`.

## Cel repozytorium

Celem repozytorium jest weryfikacja zgodności symulatora z dokumentacją oraz wykrywanie defektów w API.

Zakres testów obejmuje m.in.:

- podłączenie UE do sieci,
- odłączenie UE od sieci,
- rozpoczęcie przesyłania danych,
- sprawdzenie aktualnego transferu,
- zakończenie przesyłania danych,
- dodanie dedykowanego bearera,
- sprawdzenie aktywnych bearerów UE,
- usunięcie dedykowanego bearera,
- reset symulatora.

## Założenia funkcjonalne

Najważniejsze założenia testowanego symulatora:

- zakres dostępnych UE: `0–100`,
- zakres bearerów dla UE: `1–9`,
- bearer `9` jest domyślnie ustanawiany po podłączeniu UE,
- maksymalny transfer DL dla UE wynosi `100 Mbps`

## Struktura repozytorium

```text
.
├── resources/
│   ├── common_keywords.robot
│   ├── config.py
│   └── epc_requests.py
├── tests/
│   ├── 01_attach.robot
│   ├── 02_detach.robot
│   ├── 03_traffic_start.robot
│   ├── 04_traffic_check.robot
│   ├── 05_traffic_stop.robot
│   ├── 06_bearers_add.robot
│   ├── 07_bearers_check.robot
│   ├── 08_bearers_remove.robot
│   └── 09_reset.robot
└── .gitignore
```

### `resources/config.py`

Plik konfiguracyjny z adresem bazowym API:

```python
BASE_URL = 'http://localhost:8000/ues'
```

Jeżeli symulator działa pod innym adresem lub portem, należy zmienić tę wartość.

### `resources/epc_requests.py`

Biblioteka pomocnicza w Pythonie. Zawiera metody, które wykonują żądania HTTP do API symulatora, m.in.:

- `attach_ue`,
- `detach_ue`,
- `get_ue`,
- `get_ues`,
- `add_bearer`,
- `delete_bearer`,
- `start_traffic`,
- `stop_traffic`,
- `get_traffic_stats`,
- `get_ues_stats`,
- `reset_simulator`.

### `resources/common_keywords.robot`

Wspólne keywordy Robot Framework używane w wielu plikach testowych, np. podłączenie UE, dodawanie bearera, start trafficu, reset symulatora albo podstawowa walidacja odpowiedzi.

### `tests/`

Katalog z testami podzielonymi według funkcjonalności symulatora:

| Plik                      | Zakres                            |
| ------------------------- | --------------------------------- |
| `01_attach.robot`         | Podłączenie UE do sieci           |
| `02_detach.robot`         | Odłączenie UE od sieci            |
| `03_traffic_start.robot`  | Rozpoczęcie przesyłania danych    |
| `04_traffic_check.robot`  | Sprawdzenie aktualnego transferu  |
| `05_traffic_stop.robot`   | Zakończenie przesyłania danych    |
| `06_bearers_add.robot`    | Dodanie bearera                   |
| `07_bearers_check.robot`  | Sprawdzenie podłączonych bearerów |
| `08_bearers_remove.robot` | Usunięcie bearera                 |
| `09_reset.robot`          | Reset symulatora                  |

## Wymagania

Do uruchomienia testów potrzebne są:

- Docker,
- Python 3.12+,
- Robot Framework,
- requests.

Instalacja zależności:

```bash
pip install robotframework requests
```

## Uruchomienie symulatora w Dockerze

Obraz symulatora został dostarczony jako plik `epc-simulator.tar`, najpierw należy go załadować:

```bash
docker load -i epc-simulator.tar
```

Następnie uruchomić kontener:

```bash
docker run -p 8000:8000 epc-simulator:1.0.0
```

Po uruchomieniu API powinno być dostępne pod adresem:

```text
http://localhost:8000
```

Dokumentacja Swagger, jeżeli jest włączona w aplikacji, powinna być dostępna pod adresem:

```text
http://localhost:8000/docs
```

## Sprawdzenie, czy API działa

Po uruchomieniu kontenera można sprawdzić dostępność API:

```bash
curl http://localhost:8000/ues
```

Przykładowa odpowiedź dla pustego symulatora:

```json
{
  "ues": []
}
```

## Uruchamianie testów

Wszystkie testy:

```bash
robot tests
```

Zapis wyników do osobnego katalogu:

```bash
robot -d results tests
```

Pojedynczy plik testowy:

```bash
robot -d results tests/01_attach.robot
```

## Wyniki testów

Po uruchomieniu Robot Framework generuje standardowe pliki wynikowe:

```text
output.xml
log.html
report.html
```

Jeżeli użyto opcji `-d results`, pliki znajdą się w katalogu:

```text
results/
```

Najważniejsze pliki:

- `report.html` – ogólne podsumowanie testów,
- `log.html` – szczegółowy log kroków i odpowiedzi API,
- `output.xml` – surowy wynik testów w formacie XML.

## Szybka ścieżka uruchomienia

```bash
docker load -i epc-simulator.tar
docker run --rm -p 8000:8000 epc-simulator:1.0.0
pip install robotframework requests
robot -d results tests
```

Po zakończeniu testów otwórz:

```text
results/report.html
results/log.html
```

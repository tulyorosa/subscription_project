import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import os
import random

# CONFIG

NUM_CUSTOMERS = 500
START_DATE = datetime(2022, 1, 1)
END_DATE = datetime(2024, 12, 31)

PLANS = [
    {"plan_id": 1, "plan_name": "Basic Monthly", "price": 29.90, "cycle_days": 30},
    {"plan_id": 2, "plan_name": "Premium Monthly", "price": 49.90, "cycle_days": 30},
    {"plan_id": 3, "plan_name": "Quarterly", "price": 129.90, "cycle_days": 90},
    {"plan_id": 4, "plan_name": "Annual", "price": 399.90, "cycle_days": 365},
]

OUTPUT_DIR = os.path.join("data", "raw")
os.makedirs(OUTPUT_DIR, exist_ok=True)

# AUX

def random_date(start, end):
    """Gera uma data aleatória entre start e end."""
    delta = end - start
    return start + timedelta(days=random.randint(0, delta.days))

# NAMES

FIRST_NAMES = [
    "Ana", "Bruno", "Carla", "Diego", "Eduarda", "Felipe", "Gabriel",
    "Helena", "Igor", "João", "Karina", "Luiz", "Mariana", "Nathalia",
    "Otávio", "Paula", "Rafael", "Sabrina", "Thiago", "Vitória"
]

LAST_NAMES = [
    "Silva", "Souza", "Oliveira", "Costa", "Santos", "Rodrigues",
    "Almeida", "Lima", "Gomes", "Ribeiro", "Carvalho", "Pereira",
    "Ferreira", "Araújo", "Rocha", "Martins"
]

# LOCATE

REGIONS = [
    {"state": "SP", "city": "São Paulo", "region": "Sudeste"},
    {"state": "RJ", "city": "Rio de Janeiro", "region": "Sudeste"},
    {"state": "MG", "city": "Belo Horizonte", "region": "Sudeste"},
    {"state": "ES", "city": "Vitória", "region": "Sudeste"},
    {"state": "PR", "city": "Curitiba", "region": "Sul"},
    {"state": "SC", "city": "Florianópolis", "region": "Sul"},
    {"state": "RS", "city": "Porto Alegre", "region": "Sul"},
    {"state": "BA", "city": "Salvador", "region": "Nordeste"},
    {"state": "PE", "city": "Recife", "region": "Nordeste"},
    {"state": "CE", "city": "Fortaleza", "region": "Nordeste"},
    {"state": "DF", "city": "Brasília", "region": "Centro-Oeste"},
    {"state": "GO", "city": "Goiânia", "region": "Centro-Oeste"},
    {"state": "PA", "city": "Belém", "region": "Norte"},
    {"state": "AM", "city": "Manaus", "region": "Norte"},
]


def random_cpf():
    """Gera um CPF fake (somente 11 dígitos, sem validação de dígito verificador)."""
    return "".join(str(random.randint(0, 9)) for _ in range(11))


def random_monthly_income():
    """Retorna uma renda mensal aproximada, em faixas."""
    faixa = random.random()
    if faixa < 0.4:
        return round(random.uniform(1500, 3000), 2)
    elif faixa < 0.75:
        return round(random.uniform(3000, 6000), 2)
    elif faixa < 0.95:
        return round(random.uniform(6000, 12000), 2)
    else:
        return round(random.uniform(12000, 25000), 2)

# CUSTOMERS

customers = []

birth_start = datetime(1965, 1, 1)
birth_end = datetime(2023, 12, 31)
signup_start = datetime(2020, 1, 1)

for user_id in range(1, NUM_CUSTOMERS + 1):
    first_name = random.choice(FIRST_NAMES)
    last_name = random.choice(LAST_NAMES)
    full_name = f"{first_name} {last_name}"

    cpf = random_cpf()
    birth_date = random_date(birth_start, birth_end).date()

    loc = random.choice(REGIONS)

    signup_date = random_date(signup_start, START_DATE)

    gender = random.choice(["M", "F"])

    income = random_monthly_income()

    customers.append({
        "user_id": user_id,
        "full_name": full_name,
        "cpf": cpf,
        "gender": gender,
        "birth_date": birth_date,
        "state": loc["state"],
        "city": loc["city"],
        "region": loc["region"],
        "signup_date": signup_date.date(),
        "monthly_income": income
    })

df_customers = pd.DataFrame(customers)

# SUBSCRIPTIONS + EVENTS + PAYMENTS

subscriptions = []
payments = []
events = []

for cust in customers:
    user_id = cust["user_id"]
    signup_date = datetime.combine(cust["signup_date"], datetime.min.time())

    # FIRST SUBSCRIPTION
    earliest_start = max(signup_date, START_DATE)
    if earliest_start > END_DATE - timedelta(days=90):
        continue

    first_sub_date = random_date(earliest_start, END_DATE - timedelta(days=90))

    # PLAN
    plan = random.choice(PLANS)

    subscription_id = f"S{user_id:04d}"

    subscriptions.append({
        "subscription_id": subscription_id,
        "user_id": user_id,
        "plan_id": plan["plan_id"],
        "start_date": first_sub_date.date(),
        "status": "active"
    })

    # START
    events.append({
        "subscription_id": subscription_id,
        "event_type": "started",
        "event_date": first_sub_date.date()
    })

    # PAYMENTS
    next_payment = first_sub_date
    subs_index = len(subscriptions) - 1 

    while next_payment < END_DATE:
        payments.append({
            "subscription_id": subscription_id,
            "payment_date": next_payment.date(),
            "amount": plan["price"],
            "plan_id": plan["plan_id"]
        })

        # CANCELL %
        cancel_event = random.random()
        if cancel_event < 0.05:
            cancel_date = next_payment + timedelta(days=random.randint(5, 20))

            events.append({
                "subscription_id": subscription_id,
                "event_type": "cancelled",
                "event_date": cancel_date.date()
            })

            # STATUS
            subscriptions[subs_index]["status"] = "cancelled"
            break

        next_payment = next_payment + timedelta(days=plan["cycle_days"])


# SAVE

df_subs = pd.DataFrame(subscriptions)
df_pay = pd.DataFrame(payments)
df_events = pd.DataFrame(events)

customers_path = os.path.join(OUTPUT_DIR, "customers.csv")
subs_path = os.path.join(OUTPUT_DIR, "subscriptions.csv")
pay_path = os.path.join(OUTPUT_DIR, "payments.csv")
events_path = os.path.join(OUTPUT_DIR, "subscription_events.csv")

df_customers.to_csv(customers_path, index=False)
df_subs.to_csv(subs_path, index=False)
df_pay.to_csv(pay_path, index=False)
df_events.to_csv(events_path, index=False)

print("✔ Dados gerados com sucesso!")
print(f"- {customers_path}")
print(f"- {subs_path}")
print(f"- {pay_path}")
print(f"- {events_path}")

from faker import Faker
import random
from datetime import datetime, timedelta
from random import randint
from dateutil.relativedelta import relativedelta

_current_date = None
_past_date = None
def get_next_date():
    global _current_date
    global _past_date
    if _current_date is None:
        _current_date = datetime.today().date()
        _past_date = _current_date - timedelta(days=1)
    else:
        _current_date += timedelta(days=1)
        _past_date -= timedelta(days=1)
    end_date = _current_date + timedelta(days=1)
    result_date = end_date + timedelta(days=1)
    return {
        "_current_date": _current_date.strftime("%m/%d/%Y"),
        "end_date": end_date.strftime("%m/%d/%Y"),
        "result_date": result_date.strftime("%m/%d/%Y"),
        "past_date": _past_date.strftime("%m/%d/%Y")
    }

def get_past_date():
    global _past_date
    if _current_date is None:
        _current_date = datetime.today().date()
    else:
        _current_date += timedelta(days=1)

relationships = [
    "Father", "Mother", "Son", "Daughter", "Brother", "Sister", "Uncle", "Aunt",
    "Grandfather", "Grandmother", "Cousin", "Nephew", "Niece", "Husband", "Wife"
]

def generate_data():
    data = {
        "full_name": f"{Faker().first_name()} {Faker().last_name()}",
        "first_name": f"{Faker().first_name()}",
        "last_name": f"{Faker().last_name()}",
        "email": Faker().email(),
        "address": Faker().address().replace("\n", " "),
        "sentence": Faker().sentence(),
        "MRN": f"{Faker().random_int(min=1000000, max=9999999)}",
        "SSN":    f"{Faker().random_int(min=100, max=999)}" + "-" +
                    f"{Faker().random_int(min=10, max=99)}" + "-" +
                    f"{Faker().random_int(min=1000, max=9999)}",
        "credit_num":    f"{Faker().random_int(min=1000, max=9999)}" + " " +
            f"{Faker().random_int(min=1000, max=9999)}" + " " +
            f"{Faker().random_int(min=1000, max=9999)}" + " " +
            f"{Faker().random_int(min=1000, max=9999)}",
        "phone":    f"({Faker().random_int(min=100, max=999)})" + " " +
            f"{Faker().random_int(min=100, max=999)}" + "-" +
            f"{Faker().random_int(min=1000, max=9999)}" + "-" +
            f"{Faker().random_int(min=10000, max=99999)}",        
        "DOB": Faker().date_of_birth(minimum_age=1, maximum_age=99).strftime("%m/%d/%Y"),
        "Height": f"{Faker().random_int(min=10, max=99)}" + ".1",
        "Weight": f"{Faker().random_int(min=10, max=100)}"+ ".12",
        "zip_code": f"{Faker().random_int(min=100, max=999)}",
        "country": Faker().country(),
        "job": Faker().job(),
        "num_rand": f"{Faker().random_int(min=10, max=99)}",
        "relationship": random.choice(relationships),
        "long_text": Faker().paragraph(nb_sentences=50),
        "demical_3d": f"{Faker().random_int(min=100, max=999)}",
        "demical_2d": f"{Faker().random_int(min=10, max=99)}",
        "decimal_3d_2f": f"{Faker().pyfloat(left_digits=3, right_digits=2, positive=True)}",
        "decimal_2d_2f": f"{Faker().pyfloat(left_digits=2, right_digits=2, positive=True)}",
        "integer_decimal_ratio":    f"{Faker().random_int(min=100, max=999)}" + "/" + f"{Faker().random_int(min=100, max=999)}",
        "exp_date": (datetime.today() + timedelta(days=30*randint(1, 36))).strftime("%m/%y"),
        "non_exp_date": (datetime.today() - relativedelta(years=1)).strftime("%m/%y"),

    }
    return data

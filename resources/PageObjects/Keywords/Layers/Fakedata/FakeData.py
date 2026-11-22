from faker import Faker
from datetime import datetime, timedelta, timezone
from dateutil.relativedelta import relativedelta
from random import randint, choice
import random
import re

_current_date = None
_past_date = None
def get_incremental_dates():
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
        "current_date": _current_date.strftime("%m/%d/%Y"),
        "end_date": end_date.strftime("%m/%d/%Y"),
        "result_date": result_date.strftime("%m/%d/%Y"),
        "past_date": _past_date.strftime("%m/%d/%Y")
    }

relationships = [
    "Father", "Mother", "Son", "Daughter", "Brother", "Sister", "Uncle", "Aunt",
    "Grandfather", "Grandmother", "Cousin", "Nephew", "Niece", "Husband", "Wife"
]

faker = Faker()

def generate_fake_data(*fields):
    full_data = {
        "full_name": f"{faker.first_name()} {faker.last_name()}",
        "first_name": faker.first_name(),
        "middle_name": faker.first_name(),
        "last_name": faker.last_name(),
        "email": faker.email(),
        "address": faker.address().replace("\n", " "),
        "sentence": faker.sentence(),
        "mrn": f"{faker.random_int(min=1000000, max=9999999)}",
        "ssn": f"{faker.random_int(min=100, max=999)}-{faker.random_int(min=10, max=99)}-{faker.random_int(min=1000, max=9999)}",
        "credit_num": " ".join(str(faker.random_int(min=1000, max=9999)) for _ in range(4)),
        "phone": f"({faker.random_int(min=100, max=999)}) {faker.random_int(min=100, max=999)}-{faker.random_int(min=1000, max=9999)}",
        "dob": faker.date_of_birth(minimum_age=1, maximum_age=99).strftime("%m/%d/%Y"),
        "height": f"{faker.random_int(min=10, max=99)}.0",
        "weight": f"{faker.random_int(min=10, max=100)}",
        "postal_code": f"{faker.random_int(min=100, max=999)}",
        "country": faker.country(),
        "job": faker.job(),
        "num_rand": f"{faker.random_int(min=10, max=99)}",
        "6_integers": f"{faker.random_int(min=100000, max=999999)}",
        "relationship": choice(relationships),
        "long_text": faker.paragraph(nb_sentences=50),
        "demical_3d": f"{faker.random_int(min=100, max=999)}",
        "demical_2d": f"{faker.random_int(min=10, max=99)}",
        "decimal_3d_2f": f"{faker.pyfloat(left_digits=3, right_digits=2, positive=True)}",
        "decimal_2d_2f": f"{faker.pyfloat(left_digits=2, right_digits=2, positive=True):.2f}",
        "integer_decimal_ratio": f"{faker.random_int(min=100, max=999)}/{faker.random_int(min=100, max=999)}",
        "exp_date": (datetime.today() + timedelta(days=30*randint(1, 36))).strftime("%m/%y"),
        "non_exp_date": (datetime.today() - relativedelta(years=1)).strftime("%m/%y"),
    }

    if not fields:
        return full_data

    parsed_fields = []
    for f in fields:
        parsed_fields.extend(f.split())

    return {k: full_data[k] for k in parsed_fields if k in full_data}


def format_date_no_padding(dt, fmt):
    """
    dt: datetime
    fmt: "{m}/{d}/{y}" or "{d}-{m}-{y}"
    """
    return fmt.format(
        m=dt.month,
        d=dt.day,
        y=dt.year
    )

def handle_datetime_format(
    fmt,
    utc=None,
    dt=None,
    add_minutes=0,
    add_hours=0,
    add_days=0,
):
    if dt is None:
        dt = datetime.now(timezone(timedelta(hours=float(utc)))) if utc else datetime.now()

    elif isinstance(dt, str):
        tokens = {
            "y": r"(?P<y>\d{4})",
            "mm": r"(?P<m>\d{2})",
            "m": r"(?P<m>\d{1,2})",
            "dd": r"(?P<d>\d{2})",
            "d": r"(?P<d>\d{1,2})",
            "hh": r"(?P<hh>\d{1,2})",
            "h": r"(?P<h>\d{1,2})",
            "mi": r"(?P<mi>\d{2})",
            "s": r"(?P<s>\d{2})",
            "ampm": r"(?P<ampm>AM|PM)",
        }

        regex = re.escape(fmt)
        for k, v in tokens.items():
            regex = regex.replace(r"\{" + k + r"\}", v)

        m = re.fullmatch(regex, dt)
        if not m:
            raise ValueError(f"'{dt}' does not match '{fmt}'")

        g = m.groupdict()

        now = datetime.now()
        year = int(g.get("y") or now.year)
        month = int(g.get("m") or now.month)
        day = int(g.get("d") or now.day)

        h = int(g.get("hh") or g.get("h") or 0)
        if g.get("ampm"):
            h = h % 12 + (12 if g["ampm"] == "PM" else 0)

        dt = datetime(
            year,
            month,
            day,
            h,
            int(g.get("mi", 0)),
            int(g.get("s", 0)),
        )

    dt += timedelta(
        minutes=int(add_minutes),
        hours=int(add_hours),
        days=int(add_days),
    )

    return fmt.format(
        y=dt.year,
        m=dt.month,
        mm=f"{dt.month:02d}",
        d=dt.day,
        dd=f"{dt.day:02d}",
        h=dt.hour % 12 or 12,
        hh=f"{dt.hour:02d}",
        mi=f"{dt.minute:02d}",
        s=f"{dt.second:02d}",
        ampm="AM" if dt.hour < 12 else "PM",
    )
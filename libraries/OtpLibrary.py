import pyotp

class OtpLibrary:

    def generate_otp(self, secret):
        totp = pyotp.TOTP(secret)
        return totp.now()
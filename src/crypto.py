import os
import sys
from pathlib import Path 
from cryptography.hazmat.primitives.ciphers.aead  import AESGCM

if sys.platform == "win32":
    config_dir = Path(
        os.environ.get("APPDATA")
        or Path.home() / "AppData" / "Roaming"
    )
    KEY_PATH = config_dir / "DeadFrequency" / "key"

elif sys.platform == "darwin":
    KEY_PATH = (
        Path.home()
        / "Library"
        / "Application Support"
        / "DeadFrequency"
        / "key"
    )

else:
    config_dir = Path(
        os.environ.get("XDG_CONFIG_HOME")
        or Path.home() / ".config"
    )
    KEY_PATH = config_dir / "dead-frequency" / "key"

def load_key():
    KEY_PATH.parent.mkdir(
        mode=0o700,
        parents=True,
        exist_ok=True
    )

    try: 
        fd = os.open(
            KEY_PATH,
            os.O_WRONLY | os.O_CREAT | os.O_EXCL,
            0o600
        ) 
    except FileExistsError:
        key = KEY_PATH.read_bytes()
    else:
        key = AESGCM.generate_key(bit_length=256)

        with os.fdopen(fd, 'wb') as key_file:
            key_file.write(key)
            key_file.flush()
            os.fsync(key_file.fileno())

    os.chmod(KEY_PATH, 0o600)

    if len(key) != 32:
        raise ValueError("Invalid save encryption key")

    return key

def read_key():
    if not KEY_PATH.is_file():
        raise FileNotFoundError("Save encryption is missing")

    key = KEY_PATH.read_bytes()

    if len(key) != 32:
        raise ValueError("Invalid save encryption key")

    return key

def encrypt(data):
    key =  load_key()
    nonce = os.urandom(12)

    encrypted  = AESGCM(key).encrypt(
        nonce,
        data.encode("utf-8"),
        None
    )
    
    return nonce + encrypted


def decrypt(data):
    key =  read_key()

    nonce = data[:12]
    encrypted = data[12:]

    decrypted = AESGCM(key).decrypt(
        nonce,
        encrypted,
        None
    )

    return decrypted.decode("utf-8")

if __name__ == "__main__":
    operation = sys.argv[1]
    data = sys.stdin.buffer.read()

    if operation == "encrypt":
        result = encrypt(data.decode("utf-8"))
    elif operation == "decrypt":
        result = decrypt(data)
    else: 
        sys.exit("Unknown operation")

    sys.stdout.buffer.write(
        result if isinstance(result, bytes) else result.encode("utf-8")
        )
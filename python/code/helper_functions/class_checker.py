def class_checker(class_instance: object) -> None:
    """Takes an instance of a class. Returns a list of Methods
    and attributes (excluding dunder)"""
    for name in dir(class_instance):
        if name.startswith("__"):
            continue

        value = getattr(class_instance, name)
        kind = "METHOD" if callable(value) else "ATTRIBUTE"
        print(f"{name:30} → {kind}")

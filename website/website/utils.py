# Function to convert arg into a bool.
def str2bool(arg):
    if isinstance(arg, bool):
        return arg
    else:
        if arg.lower() == 'true':
            return True
        elif arg.lower() == 'false':
            return False
        else:
            raise ValueError("Cannot covert {} to a bool".format(arg))

#!/usr/bin/python3

import os
import sys
from importlib.machinery import SourceFileLoader

usage_text = "Usage: TODO: USAGE"

# runner code
if __name__ == "__main__":
    # If not enough arguments
    if len(sys.argv) == 1:
        print(usage_text + "\n")
        exit()

    module_path = os.path.abspath(sys.argv[1])

    # Check file exists and is valid

    if not os.path.exists(module_path):
        print("File " + module_path + " not found" + "\n")
        exit()

    if not os.path.isfile(module_path):
        print(module_path + " is a directory" + "\n")
        exit()

    print("Importing: " + module_path + "\n")

    # Catching errors here appears to be impossible, as the inner engine throws it ignoring a try/catch
    # So let it throw them, as it spits useful information to the user anyway
    sketch = SourceFileLoader("sketch", sys.argv[1]).load_module()

    # Try to execute setup function if it doesn't exist no one cares, just run the loop.
    try:
        sketch.setup(sys.argv[2:])
    except AttributeError:
        pass
    # Any other error must be sent to the user.
    except:
        raise

    print("Running sketch" + "\n")
    while True:
        try:
            sketch.loop()

        # catch manual break.
        except KeyboardInterrupt:
            print("Keyboard Interrupt: Exiting")

        # If function doesn't exist catch interpreter gibbering and print meaningful error message
        except AttributeError:
            print("No \"loop()\" Function found. Exiting")

        # Any other error must be sent to the user.
        except:
            raise

        finally:
            # Try to call cleanup. If it doesn't exist mode along.
            try:
                sketch.cleanup()
            except AttributeError:
                pass

            # Any other error must be sent to the user.
            except:
                raise
            break
        # endtry
    # endwhile
# end

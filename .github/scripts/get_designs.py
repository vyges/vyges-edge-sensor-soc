import argparse, json

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--design", help="Path to the design.")
    args = parser.parse_args()
    config_file = f"{args.design}/lvs/user_project_wrapper/lvs_config.json"
    data = json.load(open(config_file))["LVS_VERILOG_FILES"]
    f = open("harden_sequence.txt", "w")
    for d in data:
        macro_name = d.split("/")[-1].split(".v")[0]
        if macro_name.startswith("$"):
            macro_name = "user_project_wrapper"
        f.write(f"{macro_name} ")
    f.close()

if __name__ == "__main__":
    main()

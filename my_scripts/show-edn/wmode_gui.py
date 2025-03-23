#!/usr/bin/env python3
import os
import subprocess
import tkinter as tk
from tkinter import messagebox, ttk

import edn_format

CONFIG_FILE = os.path.expanduser("~/.config/goku_config/karabiner.edn")


def load_edn_config():
    """读取并解析整个 goku.edn 文件"""
    if not os.path.exists(CONFIG_FILE):
        return None, f"Error: Config file not found at {CONFIG_FILE}"

    try:
        with open(CONFIG_FILE, "r") as f:
            content = f.read()
            print("\n=== EDN File Content ===")
            print(content[:1000])  # 打印前1000个字符
            
            print("\n=== Parsing EDN ===")
            data = edn_format.loads(content)
            print(f"Data type: {type(data)}")
            
            # 将 ImmutableDict 转换为普通字典
            if hasattr(data, 'items'):
                data = dict(data.items())
            
            print("\n=== Data Structure ===")
            print("Keys in data:", list(data.keys()))
            
            # 尝试所有可能的 main 键
            main_data = None
            if edn_format.Keyword("main") in data:
                print("Found main as Keyword")
                main_data = data[edn_format.Keyword("main")]
            elif ":main" in data:
                print("Found main as :main")
                main_data = data[":main"]
            elif "main" in data:
                print("Found main as string")
                main_data = data["main"]
                
            if main_data:
                print("\n=== Main Section ===")
                print(f"Main data type: {type(main_data)}")
                print("Main data content:")
                for i, rule in enumerate(main_data):
                    print(f"\nRule {i+1}:")
                    print(f"Rule type: {type(rule)}")
                    print(f"Rule content: {rule}")
                    if isinstance(rule, dict):
                        print(f"Rule keys: {list(rule.keys())}")
                        for key, value in rule.items():
                            print(f"  {key}: {value}")
            else:
                print("No main section found!")
                
            return data, None
    except Exception as e:
        print(f"Error details: {str(e)}")
        import traceback
        traceback.print_exc()
        return None, f"Error parsing EDN file: {str(e)}"


def open_path(path):
    """执行 open-path 操作"""
    try:
        subprocess.run(["open", path], check=True)
        print(f"Launched: {path}")
    except subprocess.CalledProcessError as e:
        messagebox.showerror("Error", f"Failed to open {path}: {str(e)}")


def format_value(value, depth=0):
    """将 EDN 值格式化为可读字符串"""
    if isinstance(value, edn_format.Keyword):
        key_str = str(value).lstrip(":")
        return key_str
    elif isinstance(value, (list, tuple)):
        # 处理键位映射规则
        if len(value) >= 2:
            # 处理 rules 数组中的键位映射
            if isinstance(value[0], edn_format.Keyword) and isinstance(value[1], edn_format.Keyword):
                from_key = str(value[0]).lstrip(":")
                to_key = str(value[1]).lstrip(":")
                conditions = ""
                if len(value) > 2:
                    if isinstance(value[2], dict) and 'alone' in value[2]:
                        alone_key = format_value(value[2]['alone'])
                        conditions = f" (单击: {alone_key})"
                    else:
                        conditions = f" (条件: {format_value(value[2])})"
                return f"按键映射: {from_key} ➔ {to_key}{conditions}"
            # 处理带条件的规则
            elif isinstance(value[0], str) and value[0] in ["w-mode", "o-mode", "hyper-mode"]:
                # 处理模式规则
                if len(value) > 1 and isinstance(value[1], (list, tuple)):
                    from_key = format_value(value[1][0])
                    if isinstance(value[1][1], (list, tuple)) and len(value[1][1]) > 0:
                        if value[1][1][0] == "open-path":
                            return f"[{value[0]}] {from_key} ➔ 打开 {value[1][1][1]}"
                        elif value[1][1][0] == "open":
                            return f"[{value[0]}] {from_key} ➔ 激活 {value[1][1][1]}"
                    else:
                        to_key = format_value(value[1][1])
                        return f"[{value[0]}] {from_key} ➔ {to_key}"
            elif isinstance(value[0], edn_format.Keyword):
                key = str(value[0]).lstrip(":")
                if key == "rules":
                    if isinstance(value[1], (list, tuple)):
                        rules = []
                        for rule in value[1]:
                            if isinstance(rule, (list, tuple)) and len(rule) >= 2:
                                from_key = format_value(rule[0])
                                to_key = format_value(rule[1])
                                conditions = ""
                                if len(rule) > 2:
                                    if isinstance(rule[2], dict) and 'alone' in rule[2]:
                                        alone_key = format_value(rule[2]['alone'])
                                        conditions = f" (单击: {alone_key})"
                                    else:
                                        conditions = f" (条件: {format_value(rule[2])})"
                                rules.append(f"按键映射: {from_key} ➔ {to_key}{conditions}")
                        return "\n".join(rules)
                    return format_value(value[1])
                elif key == "des":
                    return f"描述: {str(value[1])}"
            # 处理 open-path 和 open 命令
            elif isinstance(value[0], str):
                if value[0] == "open-path":
                    return f"打开: {value[1]}"
                elif value[0] == "open":
                    return f"激活: {value[1]}"
        return "[" + ", ".join(format_value(v, depth + 1) for v in value) + "]"
    elif isinstance(value, (dict, edn_format.immutable_dict.ImmutableDict)):
        items = []
        # 特殊处理规则字典
        if "des" in value and "rules" in value:
            desc = value["des"]
            rules = value["rules"]
            if isinstance(rules, (list, tuple)):
                formatted_rules = []
                if isinstance(rules[0], str):  # 处理模式规则
                    mode = rules[0]
                    mode_rules = rules[1:]
                    for rule in mode_rules:
                        if isinstance(rule, (list, tuple)) and len(rule) >= 2:
                            from_key = format_value(rule[0])
                            if isinstance(rule[1], (list, tuple)) and len(rule[1]) > 0:
                                if rule[1][0] == "open-path":
                                    formatted_rules.append(f"[{mode}] {from_key} ➔ 打开 {rule[1][1]}")
                                elif rule[1][0] == "open":
                                    formatted_rules.append(f"[{mode}] {from_key} ➔ 激活 {rule[1][1]}")
                            else:
                                to_key = format_value(rule[1])
                                formatted_rules.append(f"[{mode}] {from_key} ➔ {to_key}")
                else:  # 处理普通规则
                    for rule in rules:
                        if isinstance(rule, (list, tuple)) and len(rule) >= 2:
                            from_key = format_value(rule[0])
                            to_key = format_value(rule[1])
                            conditions = ""
                            if len(rule) > 2:
                                if isinstance(rule[2], dict) and 'alone' in rule[2]:
                                    alone_key = format_value(rule[2]['alone'])
                                    conditions = f" (单击: {alone_key})"
                                else:
                                    conditions = f" (条件: {format_value(rule[2])})"
                            formatted_rules.append(f"按键映射: {from_key} ➔ {to_key}{conditions}")
                return f"描述: {desc}\n" + "\n".join(formatted_rules)
        # 处理其他字典
        for k, v in sorted(value.items(), key=lambda x: str(x[0])):
            formatted_key = format_value(k, depth + 1)
            formatted_value = format_value(v, depth + 1)
            items.append(f"{formatted_key}: {formatted_value}")
        return "\n".join(items) if depth > 0 else "{" + ", ".join(items) + "}"
    return str(value)


def format_main_rule(rule):
    """格式化 :main 部分的规则"""
    print("Formatting rule:", rule)  # 添加调试信息
    if not isinstance(rule, dict) or "des" not in rule or "rules" not in rule:
        print("Invalid rule format:", rule)  # 添加调试信息
        return str(rule)
    
    desc = rule["des"]
    rules = rule["rules"]
    print("Rule description:", desc)  # 添加调试信息
    print("Rule content:", rules)  # 添加调试信息
    
    if isinstance(rules, list) and len(rules) > 0:
        if isinstance(rules[0], str) and rules[0] in ["w-mode", "o-mode", "hyper-mode"]:
            # 处理模式规则
            mode = rules[0]
            formatted_rules = []
            for r in rules[1:]:
                if isinstance(r, list) and len(r) >= 2:
                    from_key = str(r[0]).lstrip(":") if isinstance(r[0], edn_format.Keyword) else str(r[0])
                    if isinstance(r[1], list) and len(r[1]) > 0:
                        if isinstance(r[1][0], edn_format.Keyword) and str(r[1][0]).lstrip(":") == "open-path":
                            formatted_rules.append(f"[{mode}] {from_key} ➔ 打开 {r[1][1]}")
                        elif isinstance(r[1][0], edn_format.Keyword) and str(r[1][0]).lstrip(":") == "open":
                            formatted_rules.append(f"[{mode}] {from_key} ➔ 激活 {r[1][1]}")
                    else:
                        to_key = str(r[1]).lstrip(":") if isinstance(r[1], edn_format.Keyword) else str(r[1])
                        formatted_rules.append(f"[{mode}] {from_key} ➔ {to_key}")
            return f"描述: {desc}\n" + "\n".join(formatted_rules)
        else:
            # 处理普通规则
            formatted_rules = []
            for r in rules:
                if isinstance(r, list) and len(r) >= 2:
                    from_key = str(r[0]).lstrip(":") if isinstance(r[0], edn_format.Keyword) else str(r[0])
                    to_key = str(r[1]).lstrip(":") if isinstance(r[1], edn_format.Keyword) else str(r[1])
                    conditions = ""
                    if len(r) > 2:
                        if isinstance(r[2], dict) and 'alone' in r[2]:
                            alone_key = str(r[2]['alone']).lstrip(":") if isinstance(r[2]['alone'], edn_format.Keyword) else str(r[2]['alone'])
                            conditions = f" (单击: {alone_key})"
                        else:
                            conditions = f" (条件: {str(r[2]).lstrip(':')})"
                    formatted_rules.append(f"按键映射: {from_key} ➔ {to_key}{conditions}")
            return f"描述: {desc}\n" + "\n".join(formatted_rules)
    
    return f"描述: {desc}\n规则: {str(rules)}"


def populate_tree(tree, parent, data, parent_key=""):
    """递归填充表格"""
    print("\n=== Populating Tree ===")
    print("Data type:", type(data))
    
    if not isinstance(data, (dict, edn_format.immutable_dict.ImmutableDict)):
        print("Data is not a dictionary")
        return
        
    # 检查 main 键（可能是字符串或 Keyword 类型）
    main_data = None
    if edn_format.Keyword("main") in data:
        print("Found main as Keyword")
        main_data = data[edn_format.Keyword("main")]
    elif ":main" in data:
        print("Found main as :main")
        main_data = data[":main"]
    elif "main" in data:
        print("Found main as string")
        main_data = data["main"]
        
    if main_data is None:
        print("No main data found")
        return
        
    print("\nMain data type:", type(main_data))
    print("Main data length:", len(main_data))
    
    # 遍历 main 中的每个规则
    for i, rule in enumerate(main_data):
        print(f"\nProcessing rule {i+1}:")
        print("Rule type:", type(rule))
        print("Rule content:", rule)
        
        # 检查是否是字典类型（包括 ImmutableDict）
        if not isinstance(rule, (dict, edn_format.immutable_dict.ImmutableDict)):
            print("Rule is not a dictionary, skipping")
            continue
            
        # 获取描述和规则（处理可能的 Keyword 键）
        des = None
        rules = None
        
        # 尝试不同的键格式
        for des_key in [edn_format.Keyword("des"), ":des", "des"]:
            if des_key in rule:
                des = rule[des_key]
                print(f"Found description with key {des_key}: {des}")
                break
                
        for rules_key in [edn_format.Keyword("rules"), ":rules", "rules"]:
            if rules_key in rule:
                rules = rule[rules_key]
                print(f"Found rules with key {rules_key}")
                print("Rules content:", rules)
                break
                
        if des is None or rules is None:
            print("Missing description or rules, skipping")
            continue
            
        # 创建规则节点
        rule_node = tree.insert("", "end", text=str(des), values=("", ""))
        print(f"Created rule node: {des}")
        
        # 处理规则内容
        if not isinstance(rules, (list, tuple, edn_format.immutable_list.ImmutableList)):
            print("Rules is not a list or tuple, skipping")
            continue
            
        # 检查是否是模式规则
        if rules and isinstance(rules[0], (str, edn_format.Keyword)) and str(rules[0]).lstrip(":") in ["w-mode", "o-mode", "hyper-mode"]:
            mode = str(rules[0]).lstrip(":")
            print(f"Processing mode rule: {mode}")
            for r in rules[1:]:
                if not isinstance(r, (list, tuple, edn_format.immutable_list.ImmutableList)) or len(r) < 2:
                    print("Invalid rule format, skipping")
                    continue
                    
                # 获取源键和目标键
                from_key = str(r[0]).lstrip(":") if isinstance(r[0], edn_format.Keyword) else str(r[0])
                print(f"Processing key mapping: {from_key}")
                
                if isinstance(r[1], (list, tuple, edn_format.immutable_list.ImmutableList)) and len(r[1]) >= 2:
                    cmd = str(r[1][0]).lstrip(":") if isinstance(r[1][0], edn_format.Keyword) else str(r[1][0])
                    path = r[1][1]
                    if cmd == "open-path":
                        tree.insert(rule_node, "end", text=from_key, values=(f"[{mode}] 打开 {path}", f"启动 {path}"))
                    elif cmd == "open":
                        tree.insert(rule_node, "end", text=from_key, values=(f"[{mode}] 激活 {path}", f"启动 {path}"))
                else:
                    to_key = str(r[1]).lstrip(":") if isinstance(r[1], edn_format.Keyword) else str(r[1])
                    tree.insert(rule_node, "end", text=from_key, values=(f"[{mode}] ➔ {to_key}", ""))
        else:
            # 处理普通规则
            print("Processing regular rules")
            for r in rules:
                if not isinstance(r, (list, tuple, edn_format.immutable_list.ImmutableList)) or len(r) < 2:
                    print("Invalid rule format, skipping")
                    continue
                    
                from_key = str(r[0]).lstrip(":") if isinstance(r[0], edn_format.Keyword) else str(r[0])
                to_key = str(r[1]).lstrip(":") if isinstance(r[1], edn_format.Keyword) else str(r[1])
                print(f"Processing key mapping: {from_key} -> {to_key}")
                
                conditions = ""
                if len(r) > 2 and r[2] is not None:
                    if isinstance(r[2], (dict, edn_format.immutable_dict.ImmutableDict)):
                        alone_key = None
                        for k in [edn_format.Keyword("alone"), ":alone", "alone"]:
                            if k in r[2]:
                                alone_key = r[2][k]
                                break
                        if alone_key:
                            alone_str = str(alone_key).lstrip(":") if isinstance(alone_key, edn_format.Keyword) else str(alone_key)
                            conditions = f" (单击: {alone_str})"
                    else:
                        conditions = f" (条件: {str(r[2]).lstrip(':') if isinstance(r[2], edn_format.Keyword) else str(r[2])})"
                
                tree.insert(rule_node, "end", text=from_key, values=(f"➔ {to_key}{conditions}", ""))


def create_gui(config):
    """创建表格形式的 GUI"""
    root = tk.Tk()
    root.title("Goku EDN Config Viewer")
    
    # 设置全屏
    screen_width = root.winfo_screenwidth()
    screen_height = root.winfo_screenheight()
    root.geometry(f"{screen_width}x{screen_height}+0+0")
    
    # 设置主题样式
    style = ttk.Style()
    style.theme_use('clam')
    
    # 配置树形视图样式
    style.configure("Treeview", 
                   background="#ffffff",
                   foreground="#333333",
                   fieldbackground="#ffffff",
                   rowheight=30)  # 增加行高
    style.configure("Treeview.Heading",
                   background="#f0f0f0",
                   foreground="#333333",
                   relief="flat",
                   font=('Helvetica', 12, 'bold'))  # 增加字体大小
    
    # 创建主框架
    main_frame = ttk.Frame(root, padding="20")  # 增加内边距
    main_frame.pack(fill=tk.BOTH, expand=True)
    
    # 标题
    title_frame = ttk.Frame(main_frame)
    title_frame.pack(fill=tk.X, pady=(0, 20))  # 增加下边距
    
    title_label = ttk.Label(
        title_frame,
        text="Goku EDN Configuration",
        font=("Helvetica", 24, "bold"),  # 增加字体大小
        foreground="#2c3e50"
    )
    title_label.pack(side=tk.LEFT)
    
    # 创建搜索框
    search_frame = ttk.Frame(main_frame)
    search_frame.pack(fill=tk.X, pady=(0, 20))  # 增加下边距
    
    search_var = tk.StringVar()
    search_var.trace('w', lambda *args: filter_tree(tree, search_var.get()))
    
    search_entry = ttk.Entry(
        search_frame,
        textvariable=search_var,
        font=("Helvetica", 14)  # 增加字体大小
    )
    search_entry.pack(side=tk.LEFT, fill=tk.X, expand=True)
    
    # 创建树形视图框架
    tree_frame = ttk.Frame(main_frame)
    tree_frame.pack(fill=tk.BOTH, expand=True)
    
    # 创建树形视图
    tree = ttk.Treeview(
        tree_frame,
        columns=("Value", "Action"),
        show="tree headings",
        height=35
    )
    
    # 配置列
    tree.heading("#0", text="Key", anchor=tk.W)
    tree.heading("Value", text="Value", anchor=tk.W)
    tree.heading("Action", text="Action", anchor=tk.W)
    
    # 调整列宽以适应全屏
    tree.column("#0", width=800, minwidth=300)  # Key 列
    tree.column("Value", width=1000, minwidth=400)  # Value 列
    tree.column("Action", width=200, minwidth=100)  # Action 列
    
    # 添加滚动条
    vsb = ttk.Scrollbar(tree_frame, orient="vertical", command=tree.yview)
    hsb = ttk.Scrollbar(tree_frame, orient="horizontal", command=tree.xview)
    tree.configure(yscrollcommand=vsb.set, xscrollcommand=hsb.set)
    
    # 布局
    tree.grid(row=0, column=0, sticky="nsew")
    vsb.grid(row=0, column=1, sticky="ns")
    hsb.grid(row=1, column=0, sticky="ew")
    
    # 配置网格权重
    tree_frame.grid_columnconfigure(0, weight=1)
    tree_frame.grid_rowconfigure(0, weight=1)
    
    # 填充数据
    print("Populating tree with config")
    populate_tree(tree, "", config)
    
    # 展开所有节点
    def expand_all():
        for item in tree.get_children():
            tree.item(item, open=True)
            expand_children(item)
    
    def expand_children(item):
        for child in tree.get_children(item):
            tree.item(child, open=True)
            expand_children(child)
    
    # 初始展开所有节点
    expand_all()
    
    def on_double_click(event):
        item = tree.selection()
        if not item:
            return
        item = item[0]
        action = tree.item(item, "values")[1]
        if action.startswith("启动 "):
            path = action.replace("启动 ", "")
            open_path(path)
    
    tree.bind("<Double-1>", on_double_click)
    
    # 添加状态栏
    status_frame = ttk.Frame(main_frame)
    status_frame.pack(fill=tk.X, pady=(20, 0))  # 增加上边距
    
    status_label = ttk.Label(
        status_frame,
        text="Double click on items with '启动' action to open",
        font=("Helvetica", 12),  # 增加字体大小
        foreground="#666666"
    )
    status_label.pack(side=tk.LEFT)
    
    # 设置窗口背景色
    root.configure(bg='#f5f6fa')  # 设置浅灰色背景
    
    # 设置主框架背景色
    main_frame.configure(style='Main.TFrame')
    style.configure('Main.TFrame', background='#f5f6fa')
    
    # 设置树形视图选中项的背景色
    style.map('Treeview',
              background=[('selected', '#0078d7')],  # 设置选中项的背景色
              foreground=[('selected', '#ffffff')])  # 设置选中项的前景色
    
    root.mainloop()


def filter_tree(tree, search_text):
    """根据搜索文本过滤树形视图"""
    search_text = search_text.lower()
    
    def should_show(item):
        values = tree.item(item)['values']
        text = tree.item(item)['text']
        return (search_text in text.lower() or
                (values and search_text in str(values[0]).lower()))
    
    def show_children(item):
        for child in tree.get_children(item):
            if should_show(child):
                tree.reattach(child, item, 'end')
                show_children(child)
            else:
                tree.detach(child)
    
    for item in tree.get_children():
        if should_show(item):
            tree.reattach(item, '', 'end')
            show_children(item)
        else:
            tree.detach(item)


def generate_markdown(config):
    """将 EDN 配置生成 Markdown 文档"""
    if not config:
        return
        
    # 获取 main 数据
    main_data = None
    if edn_format.Keyword("main") in config:
        main_data = config[edn_format.Keyword("main")]
    elif ":main" in config:
        main_data = config[":main"]
    elif "main" in config:
        main_data = config["main"]
        
    if not main_data:
        return
        
    # 生成 Markdown 内容
    markdown_content = ["# Launch Mode Configuration\n"]
    
    # 遍历 main 中的每个规则
    for rule in main_data:
        if not isinstance(rule, (dict, edn_format.immutable_dict.ImmutableDict)):
            continue
            
        # 获取描述和规则
        des = None
        rules = None
        
        for des_key in [edn_format.Keyword("des"), ":des", "des"]:
            if des_key in rule:
                des = rule[des_key]
                break
                
        for rules_key in [edn_format.Keyword("rules"), ":rules", "rules"]:
            if rules_key in rule:
                rules = rule[rules_key]
                break
                
        if des is None or rules is None:
            continue
            
        # 只处理包含 launch mode 的规则
        if not any(mode in str(des).lower() for mode in ["w - launch mode", "o-launch mode", "hyper-launch mode"]):
            continue
            
        # 添加规则描述
        markdown_content.append(f"\n## {des}\n")
        
        # 处理规则内容
        if not isinstance(rules, (list, tuple, edn_format.immutable_list.ImmutableList)):
            continue
            
        # 检查是否是模式规则
        if rules and isinstance(rules[0], (str, edn_format.Keyword)) and str(rules[0]).lstrip(":") in ["w-mode", "o-mode", "hyper-mode"]:
            mode = str(rules[0]).lstrip(":")
            markdown_content.append(f"\n### {mode} 模式\n")
            
            for r in rules[1:]:
                if not isinstance(r, (list, tuple, edn_format.immutable_list.ImmutableList)) or len(r) < 2:
                    continue
                    
                from_key = str(r[0]).lstrip(":") if isinstance(r[0], edn_format.Keyword) else str(r[0])
                
                if isinstance(r[1], (list, tuple, edn_format.immutable_list.ImmutableList)) and len(r[1]) >= 2:
                    cmd = str(r[1][0]).lstrip(":") if isinstance(r[1][0], edn_format.Keyword) else str(r[1][0])
                    path = r[1][1]
                    if cmd == "open-path":
                        markdown_content.append(f"- `{from_key}` ➔ 打开 `{path}`")
                    elif cmd == "open":
                        markdown_content.append(f"- `{from_key}` ➔ 激活 `{path}`")
                else:
                    to_key = str(r[1]).lstrip(":") if isinstance(r[1], edn_format.Keyword) else str(r[1])
                    markdown_content.append(f"- `{from_key}` ➔ `{to_key}`")
    
    # 写入 Markdown 文件
    markdown_file = os.path.join(os.path.dirname(CONFIG_FILE), "launch_mode.md")
    with open(markdown_file, "w", encoding="utf-8") as f:
        f.write("\n".join(markdown_content))
    
    print(f"Launch mode Markdown file generated at: {markdown_file}")


def main():
    config, error = load_edn_config()
    if error:
        print(error)
        messagebox.showerror("Error", error)
        return
    if config:
        create_gui(config)
        generate_markdown(config)  # 生成 Markdown 文件
    else:
        messagebox.showinfo("Info", "No configuration loaded")


if __name__ == "__main__":
    main()

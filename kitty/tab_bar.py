from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    TabBarData,
    ExtraData,
    draw_tab_with_powerline,
    as_rgb,
)
from kitty.boss import get_boss

# Directory-to-color mapping (medium depth, white text readable in both modes)
DIR_COLORS = {
    "Documents/GitHub": 0x2563eb,
    "Desktop":          0xdc2626,
    "Downloads":        0xd97706,
    "Documents":        0x16a34a,
    ".config":          0x7c3aed,
    "development":      0x0d9488,
    "notes":            0xca8a04,
}

TAB_FG = 0xffffff


def _get_cwd(tab):
    try:
        boss = get_boss()
        if boss:
            for tm in boss.os_window_map.values():
                for t in tm.tabs:
                    if t.id == tab.tab_id:
                        w = t.active_window
                        if w and hasattr(w, 'cwd_of_child'):
                            return w.cwd_of_child or ""
    except Exception:
        pass
    return ""


def _get_dir_color(cwd: str):
    best_match = ""
    best_len = 0
    for pattern, color in DIR_COLORS.items():
        if pattern in cwd and len(pattern) > best_len:
            best_len = len(pattern)
            best_match = pattern
    if best_match:
        return DIR_COLORS[best_match]
    return None


def draw_tab(
    draw_data: DrawData, screen: Screen, tab: TabBarData,
    before: int, max_title_length: int, index: int, is_last: bool,
    extra_data: ExtraData,
) -> int:
    layout_icons = {
        "splits": "󰯌",
        "stack": "",
        "tall": "",
        "fat": "",
        "horizontal": "",
        "vertical": "",
        "grid": "",
    }
    layout_icon = layout_icons.get(tab.layout_name, "?")

    cwd = _get_cwd(tab)
    dir_name = cwd.rsplit("/", 1)[-1] if cwd else ""
    dir_color = _get_dir_color(cwd)

    # Override screen cursor colors before draw_tab_with_powerline reads them
    if tab.is_active and dir_color is not None:
        screen.cursor.bg = as_rgb(dir_color)
        screen.cursor.fg = as_rgb(TAB_FG)

    draw_data = draw_data._replace(
        title_template=(
            "{bell_symbol}{activity_symbol}"
            " {index} "
            + layout_icon
            + " 󰉋 " + (dir_name or "/")
            + " ❯ {title} "
        ),
    )

    return draw_tab_with_powerline(
        draw_data, screen, tab,
        before, max_title_length, index, is_last,
        extra_data,
    )

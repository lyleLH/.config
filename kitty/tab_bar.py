from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    TabBarData,
    ExtraData,
    draw_tab_with_powerline,
)


def draw_tab(
    draw_data: DrawData, screen: Screen, tab: TabBarData,
    before: int, max_title_length: int, index: int, is_last: bool,
    extra_data: ExtraData,
) -> int:
    # Layout icons
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

    # Show: index + layout icon + directory + process
    new_draw_data = draw_data._replace(
        title_template=(
            "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}"
            " {index} "
            + layout_icon
            + " 󰉋 {tab.active_wd.rsplit('/', 1)[-1] or '/'}"
            " ❯ {title} "
        ),
    )

    return draw_tab_with_powerline(
        new_draw_data, screen, tab,
        before, max_title_length, index, is_last,
        extra_data,
    )

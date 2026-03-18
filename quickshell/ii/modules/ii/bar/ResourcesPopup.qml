import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

StyledPopup {
    id: root

    // Helper function to format KB to GB
    function formatKB(kb) {
        return (kb / (1024 * 1024)).toFixed(1) + " GB";
    }

    function formatMB(mb) {
        if (mb >= 1024) return (mb / 1024).toFixed(1) + " GB";
        return mb + " MB";
    }

    Column {
        anchors.centerIn: parent
        spacing: 12

        Row {
            spacing: 12

            Column {
                anchors.top: parent.top
                spacing: 8

                StyledPopupHeaderRow {
                    icon: "memory"
                    label: "RAM"
                }
                Column {
                    spacing: 4
                    StyledPopupValueRow {
                        icon: "clock_loader_60"
                        label: Translation.tr("Used:")
                        value: root.formatKB(ResourceUsage.memoryUsed)
                    }
                    StyledPopupValueRow {
                        icon: "check_circle"
                        label: Translation.tr("Free:")
                        value: root.formatKB(ResourceUsage.memoryFree)
                    }
                    StyledPopupValueRow {
                        icon: "empty_dashboard"
                        label: Translation.tr("Total:")
                        value: root.formatKB(ResourceUsage.memoryTotal)
                    }
                }
            }

            Column {
                visible: ResourceUsage.swapTotal > 0
                anchors.top: parent.top
                spacing: 8

                StyledPopupHeaderRow {
                    icon: "swap_horiz"
                    label: "Swap"
                }
                Column {
                    spacing: 4
                    StyledPopupValueRow {
                        icon: "clock_loader_60"
                        label: Translation.tr("Used:")
                        value: root.formatKB(ResourceUsage.swapUsed)
                    }
                    StyledPopupValueRow {
                        icon: "check_circle"
                        label: Translation.tr("Free:")
                        value: root.formatKB(ResourceUsage.swapFree)
                    }
                    StyledPopupValueRow {
                        icon: "empty_dashboard"
                        label: Translation.tr("Total:")
                        value: root.formatKB(ResourceUsage.swapTotal)
                    }
                }
            }

            Column {
                anchors.top: parent.top
                spacing: 8

                StyledPopupHeaderRow {
                    icon: "planner_review"
                    label: "CPU"
                }
                Column {
                    spacing: 4
                    StyledPopupValueRow {
                        icon: "bolt"
                        label: Translation.tr("Load:")
                        value: `${Math.round(ResourceUsage.cpuUsage * 100)}%`
                    }
                }
            }
        }

        // Separator
        Rectangle {
            width: parent.width
            height: 1
            color: Appearance.colors.colLayer0Border
        }

        // Top processes by memory
        Column {
            spacing: 4

            StyledPopupHeaderRow {
                icon: "apps"
                label: Translation.tr("Top Processes")
            }

            Repeater {
                model: ProcessMemory.topProcesses

                StyledPopupValueRow {
                    required property var modelData
                    icon: "circle"
                    label: modelData.name
                    value: root.formatMB(modelData.mb)
                }
            }
        }
    }
}

## Nim Learning GUI demonstration built with nimx.
##
## The module creates a small window that showcases common desktop widgets
## such as buttons, labels, text inputs, combo boxes, and a table-backed
## activity log. Each widget is paired with an event handler so that
## interacting with the control immediately updates the on-screen activity
## log and status area.
##
## The code is wrapped in a `launchDemo` procedure that can be safely
## imported from other modules. Use the `when isMainModule` block at the
## bottom to run the demo directly.

import std/[intsets, strformat, strutils]
import nimx/[window, layout, button, text_field, popup_button,
             scroll_view, table_view, table_view_cell]

proc launchDemo*() =
  ## Launch the interactive nimx demonstration window.
  ##
  ## The procedure builds the window, wires up every widget with a callback,
  ## and enters the application loop. Call it from `when isMainModule` or from a
  ## custom Nimble task to explore the GUI on any platform supported by nimx.
  runApplication:
    let window = newWindow(newRect(80, 80, 760, 640))

    let baseTitle = "Nim Learning nimx Demo"
    window.title = baseTitle

    const readyStatus = "Ready to explore the nimx demo."
    const topics = ["Buttons", "Text Controls", "Lists", "Status Bars"]

    let margin = 12.Coord
    let spacing = 8.Coord

    var clickCount = 0
    var logEntries: seq[string] = @[]

    window.makeLayout:
      - Label as heading:
        leading == super + margin
        trailing == super - margin
        top == super + margin
        height == 26
        text: "nimx Widget Showcase"
        editable: false
        selectable: false
      - Label as description:
        leading == super + margin
        trailing == super - margin
        top == prev.bottom + spacing
        height == 22
        text: "Interact with the controls to populate the activity log."
        editable: false
        selectable: false
      - Label as infoLabel:
        leading == super + margin
        trailing == super - margin
        top == prev.bottom + spacing
        height == 22
        text: "Press the button to begin tracking clicks."
        editable: false
        selectable: false
      - Button as actionButton:
        leading == super + margin
        top == prev.bottom + spacing
        width == 160
        height == 32
        title: "Count Click"
      - Button as resetButton:
        leading == super + margin
        top == prev.bottom + spacing
        width == 160
        height == 32
        title: "Reset Form"
      - Label as inputLabel:
        leading == super + margin
        trailing == super - margin
        top == prev.bottom + spacing
        height == 22
        text: "Type something to mirror it below:"
        editable: false
        selectable: false
      - TextField as inputField:
        leading == super + margin
        trailing == super - margin
        top == prev.bottom + spacing
        height == 28
        text: ""
        continuous: true
      - Label as nameLabel:
        leading == super + margin
        trailing == super - margin
        top == prev.bottom + spacing
        height == 22
        text: "Your input will appear here."
        editable: false
        selectable: false
      - Checkbox as agreeCheck:
        leading == super + margin
        top == prev.bottom + spacing
        height == 24
        width == 320
        title: "Enable detailed button messages"
      - Label as choiceLabel:
        leading == super + margin
        trailing == super - margin
        top == prev.bottom + spacing
        height == 22
        text: "Choose a focus area:"
        editable: false
        selectable: false
      - PopupButton as topicPopup:
        leading == super + margin
        trailing == super - margin
        top == prev.bottom + spacing
        height == 28
        items: topics
      - Label as statusMirror:
        leading == super + margin
        trailing == super - margin
        top == prev.bottom + spacing
        height == 22
        text: "Status: " & readyStatus
        editable: false
        selectable: false
      - Label as listCaption:
        leading == super + margin
        trailing == super - margin
        top == prev.bottom + spacing
        height == 22
        text: "Activity Log"
        editable: false
        selectable: false
      - ScrollView as logScroll:
        leading == super + margin
        trailing == super - margin
        top == prev.bottom + spacing
        bottom == super - margin
        - TableView as logTable:
          width == super
          selectionMode: smSingleSelection
          defaultRowHeight: 24

    proc updateStatus(message: string) =
      let statusText = "Status: " & message
      statusMirror.text = statusText
      window.title = baseTitle & " — " & message

    proc logActivity(message: string) =
      logEntries.add(message)
      logTable.reloadData()
      logScroll.scrollToBottom()
      updateStatus(message)

    logTable.numberOfRows = proc (): int {.closure, gcsafe.} =
      logEntries.len

    logTable.createCell = proc (column: int): TableViewCell {.closure, gcsafe.} =
      result = newTableViewCell()
      result.makeLayout:
        - Label as cellLabel:
          leading == super + 8
          trailing == super - 8
          top == super
          bottom == super
          editable: false
          selectable: false

    logTable.configureCell = proc(cell: TableViewCell) {.closure, gcsafe.} =
      if cell.subviews.len > 0:
        let cellLabel = Label(cell.subviews[0])
        cellLabel.text = logEntries[cell.row]

    logTable.onSelectionChange = proc () {.closure, gcsafe.} =
      var selectedIndex = -1
      for idx in logTable.selectedRows.items:
        selectedIndex = idx
        break
      if selectedIndex >= 0:
        updateStatus(fmt"Selected log entry #{selectedIndex + 1}.")

    actionButton.onAction do():
      inc clickCount
      let message =
        if agreeCheck.boolValue:
          fmt"Button clicked {clickCount} time(s) with detailed logging."
        else:
          fmt"Button clicked {clickCount} time(s)."
      infoLabel.text = message
      logActivity(message)

    resetButton.onAction do():
      clickCount = 0
      inputField.text = ""
      infoLabel.text = "Press the button to begin tracking clicks."
      nameLabel.text = "Your input will appear here."
      agreeCheck.value = 0
      logActivity("Form reset. Activity log entries remain until you restart the demo.")

    inputField.onAction do():
      let sanitized = inputField.text.strip
      if sanitized.len > 0:
        nameLabel.text = "Live input: " & sanitized
        logActivity("Text updated to " & sanitized & ".")
      else:
        nameLabel.text = "Your input will appear here."
        logActivity("Text input cleared.")

    agreeCheck.onAction do():
      if agreeCheck.boolValue:
        logActivity("Detailed button messages enabled.")
      else:
        logActivity("Detailed button messages disabled.")

    topicPopup.onAction do():
      if topicPopup.selectedIndex >= 0:
        logActivity(fmt"Focus changed to {topicPopup.selectedItem} examples.")

    updateStatus(readyStatus)
    logTable.reloadData()

when isMainModule:
  launchDemo()

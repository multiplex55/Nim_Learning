## Nim Learning GUI demonstration built with wNim.
##
## The module creates a small window that showcases common desktop widgets
## such as buttons, labels, text inputs, list boxes, and combo boxes. Each
## widget is paired with an event handler so that interacting with the
## control immediately updates the on-screen activity log and status bar.
##
## The code is wrapped in a `launchDemo` procedure that can be safely
## imported from other modules. Use the `when isMainModule` block at the
## bottom to run the demo directly.

import std/[strformat, strutils]

when defined(windows):
  import wNim

  const
    ## Identifier used to clear the log from the menu bar.
    idClearLog = wIdUser + 1

  proc launchDemo*() =
    ## Launch the interactive wNim demonstration window.
    ##
    ## The procedure builds the window, wires up every widget with a callback,
    ## and enters the message loop. Call it from `when isMainModule` or from a
    ## custom Nimble task to explore the GUI on Windows.
    let app = App(wSystemDpiAware)

    # The main frame collects all widgets and shows a status bar and menu.
    let frame = Frame(title = "Nim Learning wNim Demo", size = (760, 640))
    frame.minSize = (640, 520)

    # Display short hints about the most recent interaction.
    let statusBar = StatusBar(frame)
    statusBar.setStatusText("Ready to explore the wNim demo.")

    # Menu bar with an Exit item and a command for clearing the activity log.
    let menuBar = MenuBar(frame)
    let fileMenu = Menu(menuBar, "&File")
    discard fileMenu.append(wIdExit, "E&xit\tAlt+F4")
    let viewMenu = Menu(menuBar, "&View")
    discard viewMenu.append(idClearLog, "&Clear Activity Log\tCtrl+L")

    # Container panel used by the autolayout DSL to place the widgets.
    let panel = Panel(frame)

    # Labels introduce the sample and provide running feedback.
    let heading = StaticText(panel, label = "wNim Widget Showcase")
    let description = StaticText(panel, label =
      "Interact with the controls to populate the activity log.")
    let infoLabel = StaticText(panel, label = "Press the button to begin tracking clicks.")
    let inputLabel = StaticText(panel, label = "Type something to mirror it below:")
    let nameLabel = StaticText(panel, label = "Your input will appear here.")

    # Buttons demonstrate click events and how to modify other widgets.
    let actionButton = Button(panel, label = "Count Click")
    let resetButton = Button(panel, label = "Reset Form")

    # Text box captures free-form user input and raises change notifications.
    let inputField = TextCtrl(panel, value = "", style = wBorderSunken)

    # Checkbox toggles how the click counter message is phrased.
    let agreeCheck = CheckBox(panel, label = "Enable detailed button messages")

    # Combo box presents a small set of topics that update the status text.
    let choiceLabel = StaticText(panel, label = "Choose a focus area:")
    let topics = ["Buttons", "Text Controls", "Lists", "Status Bars"]
    let combo = ComboBox(panel, value = topics[0], choices = topics, style = wCbReadOnly)

    # Secondary status label mirrors the text shown in the status bar.
    let statusMirror = StaticText(panel, label = "Status: Ready to explore the wNim demo.")

    # List box works as an on-screen activity log for every interaction.
    let listCaption = StaticText(panel, label = "Activity Log")
    let activityLog = ListBox(panel, style = wLbNeededScroll or wBorderSimple)
    activityLog.minSize = (200, 220)

    var clickCount = 0

    proc logActivity(message: string) =
      ## Append an entry to the list box and update the status areas.
      let newIndex = activityLog.append(message)
      activityLog.ensureVisible(newIndex)
      statusMirror.label = "Status: " & message
      statusBar.setStatusText(message)

    actionButton.wEvent_Button do ():
      ## Count button clicks and show the running total.
      inc clickCount
      let message =
        if agreeCheck.value:
          fmt"Button clicked {clickCount} time(s) with detailed logging."
        else:
          fmt"Button clicked {clickCount} time(s)."
      infoLabel.label = message
      logActivity(message)

    resetButton.wEvent_Button do ():
      ## Restore the controls to their default state without clearing the log.
      clickCount = 0
      inputField.value = ""
      infoLabel.label = "Press the button to begin tracking clicks."
      nameLabel.label = "Your input will appear here."
      agreeCheck.value = false
      logActivity("Form reset. Use View → Clear Activity Log to empty the list.")

    inputField.wEvent_Text do ():
      ## Reflect live text updates and record the most recent value.
      let sanitized = inputField.value.strip
      if sanitized.len > 0:
        nameLabel.label = "Live input: " & sanitized
        logActivity(fmt"Text updated to \"{sanitized}\".")
      else:
        nameLabel.label = "Your input will appear here."
        logActivity("Text input cleared.")

    agreeCheck.wEvent_CheckBox do ():
      ## Toggle whether click messages include additional wording.
      if agreeCheck.value:
        logActivity("Detailed button messages enabled.")
      else:
        logActivity("Detailed button messages disabled.")

    combo.wEvent_ComboBox do ():
      ## React to selection changes in the combo box.
      logActivity(fmt"Focus changed to {combo.value} examples.")

    activityLog.wEvent_ListBox do ():
      ## Show the index of the selected log entry in the status bar.
      let idx = activityLog.selection
      if idx >= 0:
        statusMirror.label = fmt"Status: Selected log entry #{idx + 1}."
        statusBar.setStatusText(fmt"Selected log entry #{idx + 1}.")

    frame.wEvent_Menu do (event: wEvent):
      ## Handle menu commands such as clearing the log or exiting.
      case event.id
      of wIdExit:
        frame.close()
      of idClearLog:
        activityLog.clear()
        statusMirror.label = "Status: Activity log cleared."
        statusBar.setStatusText("Activity log cleared.")
      else:
        discard

    panel.autolayout """
      spacing: 8
      V:|-12-[heading]-[description]-[infoLabel]-[actionButton]-[resetButton]-[inputLabel]-[inputField]-[nameLabel]-[agreeCheck]-[choiceLabel]-[combo]-[statusMirror]-[listCaption]-[activityLog]-12-|
      H:|-12-[heading]-12-|
      H:|-12-[description]-12-|
      H:|-12-[infoLabel]-12-|
      H:|-12-[actionButton]-12-|
      H:|-12-[resetButton]-12-|
      H:|-12-[inputLabel]-12-|
      H:|-12-[inputField]-12-|
      H:|-12-[nameLabel]-12-|
      H:|-12-[agreeCheck]-12-|
      H:|-12-[choiceLabel]-12-|
      H:|-12-[combo]-12-|
      H:|-12-[statusMirror]-12-|
      H:|-12-[listCaption]-12-|
      H:|-12-[activityLog]-12-|
    """

    frame.center()
    frame.show()
    app.mainLoop()

else:
  proc launchDemo*() =
    ## Stub invoked on non-Windows targets where wNim is unavailable.
    raise newException(OSError, "The wNim GUI demo requires Windows and the wNim package.")

when isMainModule:
  launchDemo()

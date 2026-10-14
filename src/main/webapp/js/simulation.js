/* =========================================================
   TRAFFICIQ SIMULATION
   STABLE SERVER CONTROLLED VERSION
========================================================= */

let signals = [];

let refreshTimer = null;

let requestInProgress = false;
let lastEmergencyActive = false;
let emergencyClearanceInProgress = false;
let lastEmergencySignalId = -1;


/* =========================================================
   PAGE LOAD
========================================================= */

document.addEventListener(
    "DOMContentLoaded",
    function () {

        loadSignalData();

        startWatchClock();

        arrangeSignalsRadially();

        bindButtons();

        refreshState();

        startStateRefresh();
    }
);


/* =========================================================
   LOAD SIGNAL DATA
========================================================= */

function loadSignalData() {

    signals = [];


    const elements =
        document.querySelectorAll(
            ".signal-data"
        );


    elements.forEach(
        function (element) {

            signals.push({

                id:
                    element.dataset.id,

                direction:
                    element.dataset.direction
                        .trim()
                        .toUpperCase(),

                greenTime:
                    parseInt(
                        element.dataset.green
                    ) || 1,

                yellowTime:
                    parseInt(
                        element.dataset.yellow
                    ) || 1,

                redTime:
                    parseInt(
                        element.dataset.red
                    ) || 1,

                order:
                    parseInt(
                        element.dataset.order
                    ) || 0
            });
        }
    );


    signals.sort(
        function (a, b) {

            return a.order - b.order;
        }
    );
}


/* =========================================================
   BUTTON BINDING
========================================================= */

function bindButtons() {

    const startButton =
        document.getElementById(
            "startAllButton"
        );


    const stopButton =
        document.getElementById(
            "stopAllButton"
        );


    const pauseButton =
        document.getElementById(
            "pauseJunctionButton"
        );


    const resumeButton =
        document.getElementById(
            "resumeJunctionButton"
        );

    const emergencyOnButton =
        document.getElementById("emergencyOnButton");

    const emergencyOffButton =
        document.getElementById("emergencyOffButton");

    populateEmergencySignalOptions();

    if (emergencyOnButton) {
        emergencyOnButton.addEventListener("click", activateEmergency);
    }

    if (emergencyOffButton) {
        emergencyOffButton.addEventListener("click", clearEmergency);
    }


    if (startButton) {

        startButton.addEventListener(
            "click",
            startAllSimulations
        );
    }


    if (stopButton) {

        stopButton.addEventListener(
            "click",
            stopAllSimulations
        );
    }


    if (pauseButton) {

        pauseButton.addEventListener(
            "click",
            pauseCurrentJunction
        );
    }


    if (resumeButton) {

        resumeButton.addEventListener(
            "click",
            resumeCurrentJunction
        );
    }
}


/* =========================================================
   SERVER REQUEST
========================================================= */

function sendControl(
    action,
    junctionId,
    signalId
) {

    let body =
        "action=" +
        encodeURIComponent(action);


    if (junctionId) {

        body +=
            "&junctionId=" +
            encodeURIComponent(
                junctionId
            );
    }

    if (signalId !== undefined && signalId !== null && signalId !== "") {
        body +=
            "&signalId=" +
            encodeURIComponent(signalId);
    }


    return fetch(
        CONTEXT_PATH +
        "/simulationControl",
        {
            method: "POST",

            headers: {
                "Content-Type":
                    "application/x-www-form-urlencoded"
            },

            body: body,

            cache: "no-store"
        }
    )
    .then(
        function (response) {

            if (!response.ok) {

                throw new Error(
                    "HTTP " +
                    response.status
                );
            }


            return response.json();
        }
    );
}


/* =========================================================
   START ALL
========================================================= */

function startAllSimulations() {

    sendControl(
        "START_ALL"
    )
    .then(
        function () {

            refreshState();
        }
    )
    .catch(
        function (error) {

            console.error(
                "Start failed:",
                error
            );
        }
    );
}


/* =========================================================
   STOP ALL
========================================================= */

function stopAllSimulations() {

    sendControl(
        "STOP_ALL"
    )
    .then(
        function () {

            refreshState();
        }
    )
    .catch(
        function (error) {

            console.error(
                "Stop failed:",
                error
            );
        }
    );
}


/* =========================================================
   PAUSE CURRENT JUNCTION
========================================================= */

function pauseCurrentJunction() {

    if (!CURRENT_JUNCTION_ID) {
        return;
    }


    sendControl(
        "PAUSE_JUNCTION",
        CURRENT_JUNCTION_ID
    )
    .then(
        function () {

            refreshState();
        }
    )
    .catch(
        function (error) {

            console.error(
                "Pause failed:",
                error
            );
        }
    );
}


/* =========================================================
   RESUME CURRENT JUNCTION
========================================================= */

function resumeCurrentJunction() {

    if (!CURRENT_JUNCTION_ID) {
        return;
    }


    sendControl(
        "RESUME_JUNCTION",
        CURRENT_JUNCTION_ID
    )
    .then(
        function () {

            refreshState();
        }
    )
    .catch(
        function (error) {

            console.error(
                "Resume failed:",
                error
            );
        }
    );
}


/* =========================================================
   EMERGENCY PRIORITY
========================================================= */

function populateEmergencySignalOptions() {
    const selector = document.getElementById("emergencySignalSelect");
    if (!selector) return;

    selector.innerHTML = '<option value="">Select emergency approach</option>';

    signals.forEach(function (signal) {
        const option = document.createElement("option");
        option.value = signal.id;
        option.textContent = signal.direction + " (Signal " + signal.id + ")";
        selector.appendChild(option);
    });
}

function activateEmergency() {
    if (!CURRENT_JUNCTION_ID) return;

    const selector = document.getElementById("emergencySignalSelect");
    if (!selector || !selector.value) {
        setEmergencyMessage("Select the emergency vehicle approach first.", "warning");
        return;
    }

    sendControl("EMERGENCY_ON", CURRENT_JUNCTION_ID, selector.value)
        .then(function () {
            setEmergencyMessage("Emergency priority requested.", "success");
            refreshState();
        })
        .catch(function (error) {
            console.error("Emergency activation failed:", error);
            setEmergencyMessage("Could not activate emergency priority. Check the server log.", "danger");
        });
}

function clearEmergency() {
    if (!CURRENT_JUNCTION_ID) return;

    sendControl("EMERGENCY_OFF", CURRENT_JUNCTION_ID)
        .then(function () {
            setEmergencyMessage("Emergency priority cleared.", "secondary");
            refreshState();
        })
        .catch(function (error) {
            console.error("Emergency clear failed:", error);
            setEmergencyMessage("Could not clear emergency priority.", "danger");
        });
}

function setEmergencyMessage(message, style) {
    const element = document.getElementById("emergencyMessage");
    if (!element) return;

    element.textContent = message;
    element.className = "small mt-2 text-" + style;
}

function updateAdaptiveStatus(state) {
    const timing = document.getElementById("adaptiveGreenDuration");
    const period = document.getElementById("trafficPeriod");
    const emergencyStatus = document.getElementById("emergencyStatus");
    const emergencySelect = document.getElementById("emergencySignalSelect");

    if (timing) {
        timing.textContent = String(state.currentPhase || "").toUpperCase() === "NIGHT_FLASH"
            ? "PAUSED — NIGHT FLASH"
            : Number(state.adaptiveGreenDuration || 0) + " s";
    }

    if (period) {
        period.textContent = String(state.trafficPeriod || "—").replace(/_/g, " ");
    }

    if (emergencyStatus) {
        if (state.emergencyActive) {
            emergencyStatus.textContent = "ACTIVE";
            emergencyStatus.className = "badge bg-danger";
            if (emergencySelect && state.emergencySignalId !== undefined &&
                state.emergencySignalId !== null && Number(state.emergencySignalId) >= 0) {
                emergencySelect.value = String(state.emergencySignalId);
            }
        } else {
            emergencyStatus.textContent = "INACTIVE";
            emergencyStatus.className = "badge bg-secondary";
        }
    }
}


/* =========================================================
   EMERGENCY ALERT BANNER AND APPROACH MESSAGES
========================================================= */

function updateEmergencyAlert(state) {
    const banner = document.getElementById("emergencyAlertBanner");
    const title = document.getElementById("emergencyAlertTitle");
    const message = document.getElementById("emergencyAlertMessage");
    const emergencyActive = Boolean(state.emergencyActive);
    const emergencySignalId = Number(state.emergencySignalId);
    const phase = String(state.currentPhase || "").toUpperCase();

    if (phase === "NIGHT_FLASH") {
        if (banner) {
            banner.classList.remove("d-none", "alert-danger", "alert-success", "alert-warning");
            banner.classList.add("alert-warning");
        }
        if (title) title.textContent = "NIGHT FLASH MODE";
        if (message) message.textContent = "All approaches are blinking yellow from 12:00 AM to 6:00 AM. Normal adaptive timing is paused.";
        signals.forEach(function (signal) {
            const laneMessage = document.getElementById("emergency-lane-message-" + signal.id);
            if (laneMessage) laneMessage.classList.add("d-none");
        });
        return;
    }

    if (banner && title && message && title.textContent === "NIGHT FLASH MODE") {
        banner.classList.add("d-none");
    }

    if (emergencyActive) {
        lastEmergencyActive = true;
        lastEmergencySignalId = emergencySignalId;
        emergencyClearanceInProgress = false;

        const emergencySignal = signals.find(function (signal) {
            return Number(signal.id) === emergencySignalId;
        });
        const direction = emergencySignal ? emergencySignal.direction : "selected";

        if (banner) {
            banner.classList.remove("d-none", "alert-success", "alert-warning");
            banner.classList.add("alert-danger");
        }
        if (title) title.textContent = "EMERGENCY PRIORITY ACTIVE";
        if (message) {
            message.textContent = "Emergency vehicle on the " + direction +
                " approach. All other approaches: remain stopped and wait.";
        }
    } else {
        if (lastEmergencyActive) {
            emergencyClearanceInProgress = true;
            lastEmergencyActive = false;
        }

        const currentSignalId = Number(state.currentSignalId);
        if (emergencyClearanceInProgress &&
            ((phase === "GREEN" && currentSignalId !== lastEmergencySignalId)
                || phase === "READY" || phase === "CLOSED")) {
            emergencyClearanceInProgress = false;
            lastEmergencySignalId = -1;
        }

        if (banner) {
            if (emergencyClearanceInProgress) {
                banner.classList.remove("d-none", "alert-danger", "alert-success");
                banner.classList.add("alert-warning");
                if (title) title.textContent = "EMERGENCY CLEARED — CLEARANCE IN PROGRESS";
                if (message) message.textContent =
                    "Please remain stopped while the signal completes yellow and all-red clearance.";
            } else {
                banner.classList.add("d-none");
            }
        }
    }

    signals.forEach(function (signal) {
        const laneMessage = document.getElementById("emergency-lane-message-" + signal.id);
        if (!laneMessage) return;

        if (emergencyActive) {
            laneMessage.classList.remove("d-none", "text-success", "text-secondary", "text-danger");
            if (Number(signal.id) === emergencySignalId) {
                laneMessage.classList.add("text-success");
                laneMessage.textContent = "🚑 EMERGENCY ROUTE — PRIORITY GREEN";
            } else {
                laneMessage.classList.remove("text-success");
                laneMessage.classList.add("text-danger");
                laneMessage.textContent = "⚠ EMERGENCY ACTIVE — PLEASE WAIT";
            }
        } else if (emergencyClearanceInProgress) {
            laneMessage.classList.remove("d-none", "text-success", "text-danger");
            laneMessage.classList.add("text-secondary");
            laneMessage.textContent = "Please wait — safety clearance";
        } else {
            laneMessage.classList.add("d-none");
            laneMessage.textContent = "";
        }
    });
}


/* =========================================================
   STATE REFRESH
========================================================= */

function startStateRefresh() {

    if (refreshTimer !== null) {

        clearInterval(
            refreshTimer
        );
    }


    /*
     * Refresh twice per second.
     *
     * Server itself changes once per second.
     * This makes the browser much less likely
     * to miss a state change.
     */
    refreshTimer =
        setInterval(
            refreshState,
            500
        );
}


/* =========================================================
   GET CURRENT STATE
========================================================= */

function refreshState() {

    if (!CURRENT_JUNCTION_ID) {

        return;
    }


    /*
     * Prevent multiple requests
     * from overlapping.
     */
    if (requestInProgress) {

        return;
    }


    requestInProgress = true;


    fetch(
        CONTEXT_PATH +
        "/simulationState?junctionId=" +
        encodeURIComponent(
            CURRENT_JUNCTION_ID
        ) +
        "&_=" +
        Date.now(),
        {
            method: "GET",

            cache: "no-store",

            headers: {
                "Cache-Control":
                    "no-cache"
            }
        }
    )
    .then(
        function (response) {

            if (!response.ok) {

                throw new Error(
                    "HTTP " +
                    response.status
                );
            }


            return response.json();
        }
    )
    .then(
        function (state) {

            updateSimulationDisplay(
                state
            );
        }
    )
    .catch(
        function (error) {

            console.error(
                "State refresh failed:",
                error
            );
        }
    )
    .finally(
        function () {

            requestInProgress = false;
        }
    );
}


/* =========================================================
   UPDATE COMPLETE DISPLAY
========================================================= */

function updateSimulationDisplay(
    state
) {

    updateAdaptiveStatus(state);
    updateEmergencyAlert(state);

    updateGlobalStatus(
        state
    );


    updateJunctionControls(
        state
    );

    // Hide normal countdown rows during emergency mode. The backend still
    // runs yellow/all-red safety transitions; only their UI countdowns are hidden.
    document.querySelectorAll(".signal-timer-row").forEach(function (row) {
        row.classList.toggle("d-none", Boolean(state.emergencyActive) || String(state.currentPhase || "").toUpperCase() === "NIGHT_FLASH");
    });

    const phase =
        document.getElementById(
            "phase"
        );


    if (phase) {

        if (state.paused) {

            phase.textContent =
                "PAUSED";

        }

        else {

            phase.textContent =
                state.currentPhase;
        }
    }


    const nightFlash = String(state.currentPhase || "").toUpperCase() === "NIGHT_FLASH";
    if (nightFlash && phase && !state.paused) {
        phase.textContent = "NIGHT FLASH — ALL SIGNALS BLINKING YELLOW (12 AM–6 AM)";
    }

    /*
     * First make every signal RED.
     */
    signals.forEach(
        function (signal) {

            setSignalColor(
                signal.id,
                "red"
            );


            setTimer(
                signal.id,
                0
            );
        }
    );


    /*
     * Night mode: every approach blinks yellow together; there is no active
     * green approach or countdown during this period.
     */
    if (nightFlash) {
        signals.forEach(function (signal) {
            setSignalColor(signal.id, "yellow");
            const light = document.getElementById("signal-" + signal.id);
            if (light) light.classList.add("blink-yellow");
            const status = document.getElementById("status-" + signal.id);
            if (status) status.textContent = "BLINKING YELLOW";
            setTimer(signal.id, 0);
        });
        updateTrafficDisplay(state);
        return;
    }

    signals.forEach(function (signal) {
        const light = document.getElementById("signal-" + signal.id);
        if (light) light.classList.remove("blink-yellow");
    });

    /*
     * Activate current signal.
     */
    if (
        state.currentSignalId !== undefined &&
        state.currentSignalId !== null &&
        Number(state.currentSignalId) !== -1
    ) {

        let color =
            String(
                state.currentPhase
            )
            .toLowerCase();


        if (
            color !== "green" &&
            color !== "yellow"
        ) {

            color = "red";
        }


        setSignalColor(
            state.currentSignalId,
            color
        );


        /*
         * THIS IS THE IMPORTANT TIMER UPDATE.
         */
        setTimer(
            state.currentSignalId,
            Number(
                state.phaseTimer
            )
        );
    }


    updateTrafficDisplay(
        state
    );
}


/* =========================================================
   GLOBAL STATUS
========================================================= */

function updateGlobalStatus(
    state
) {

    const status =
        document.getElementById(
            "globalStatus"
        );


    if (!status) {
        return;
    }


    if (state.globalRunning) {

        status.textContent =
            "RUNNING";

        status.className =
            "badge bg-success";

    }

    else {

        status.textContent =
            "STOPPED";

        status.className =
            "badge bg-secondary";
    }
}


/* =========================================================
   JUNCTION STATUS
========================================================= */

function updateJunctionControls(
    state
) {

    const status =
        document.getElementById(
            "junctionStatus"
        );


    const pauseButton =
        document.getElementById(
            "pauseJunctionButton"
        );


    const resumeButton =
        document.getElementById(
            "resumeJunctionButton"
        );


    if (!status) {
        return;
    }


    if (state.paused) {

        status.textContent =
            "PAUSED";

        status.className =
            "badge bg-warning text-dark";


        if (pauseButton) {

            pauseButton.style.display =
                "none";
        }


        if (resumeButton) {

            resumeButton.style.display =
                "inline-block";
        }

    }

    else if (state.globalRunning) {

        status.textContent =
            "RUNNING";

        status.className =
            "badge bg-success";


        if (pauseButton) {

            pauseButton.style.display =
                "inline-block";
        }


        if (resumeButton) {

            resumeButton.style.display =
                "none";
        }

    }

    else {

        status.textContent =
            "STOPPED";

        status.className =
            "badge bg-secondary";


        if (pauseButton) {

            pauseButton.style.display =
                "inline-block";
        }


        if (resumeButton) {

            resumeButton.style.display =
                "none";
        }
    }
}


/* =========================================================
   SIGNAL COLOR
========================================================= */

function setSignalColor(
    signalId,
    color
) {

    const light =
        document.getElementById(
            "signal-" +
            signalId
        );


    const status =
        document.getElementById(
            "status-" +
            signalId
        );


    if (!light) {
        return;
    }


    light.classList.remove(
        "red",
        "green",
        "yellow"
    );


    light.classList.add(
        color
    );


    if (status) {

        status.textContent =
            color.toUpperCase();
    }
}


/* =========================================================
   TIMER
========================================================= */

function setTimer(
    signalId,
    timer
) {

    const element =
        document.getElementById(
            "timer-" +
            signalId
        );


    if (!element) {
        return;
    }


    element.textContent =
        Math.max(
            0,
            Number(timer) || 0
        );
}


/* =========================================================
   TRAFFIC DISPLAY
========================================================= */

function updateTrafficDisplay(
    state
) {

    if (!state.trafficStates) {
        return;
    }


    Object.keys(
        state.trafficStates
    )
    .forEach(
        function (id) {

            const traffic =
                state.trafficStates[id];


            const light =
                document.getElementById(
                    "signal-" +
                    id
                );


            if (!light) {
                return;
            }


            const box =
                light.closest(
                    ".direction-box"
                );


            if (!box) {
                return;
            }


            const values =
                box.querySelectorAll(
                    ".traffic-info strong"
                );


            if (values.length >= 3) {

                values[0].textContent =
                    traffic.vehicleCount;


                values[1].textContent =
                    traffic.waitingTime +
                    "s";


                values[2].textContent =
                    traffic.vehiclesPassed;
            }
        }
    );
}


/* =========================================================
   RADIAL SIGNAL POSITIONING
========================================================= */

function normalizeDirection(direction) {

    return String(direction || "")
        .trim()
        .toUpperCase()
        .replace(/[\s_]+/g, "-");
}


function arrangeSignalsRadially() {

    const area =
        document.querySelector(
            ".junction-area"
        );

    const signalElements =
        document.querySelectorAll(
            ".radial-signal"
        );

    if (
        !area ||
        signalElements.length === 0
    ) {
        return;
    }

    const centerX =
        area.clientWidth / 2;

    const centerY =
        area.clientHeight / 2;

    /*
     * Angles for information boxes in screen coordinates:
     * NORTH is above the center; angles increase clockwise.
     */
    const directionAngles = {
        "NORTH": -90,
        "N": -90,

        "NORTH-EAST": -45,
        "NE": -45,

        "EAST": 0,
        "E": 0,

        "SOUTH-EAST": 45,
        "SE": 45,

        "SOUTH": 90,
        "S": 90,

        "SOUTH-WEST": 135,
        "SW": 135,

        "WEST": 180,
        "W": 180,

        "NORTH-WEST": 225,
        "NW": 225
    };

    /*
     * Keep the existing radial spacing approach, but base each
     * box's position on its actual direction rather than its
     * position/order in the JSP.
     */
    const radius = Math.max(
        140,
        Math.min(centerX, centerY) - 150
    );

    signalElements.forEach(function (signal, index) {

        const direction =
            normalizeDirection(
                signal.dataset.direction
            );

        let angle =
            directionAngles[direction];

        /*
         * Unknown directions use an even fallback layout.
         * Known directions always use their named compass position.
         */
        if (angle === undefined) {
            angle =
                -90 +
                (360 / signalElements.length) * index;
        }

        const radians =
            angle * Math.PI / 180;

        const x =
            centerX +
            radius * Math.cos(radians);

        const y =
            centerY +
            radius * Math.sin(radians);

        signal.style.left = x + "px";
        signal.style.top = y + "px";
    });

    /*
     * Generate a road for each actual direction present in this
     * junction, instead of assigning roads by signal index.
     */
    const directions = [];

    signals.forEach(function (signal) {
        const direction =
            normalizeDirection(signal.direction);

        if (direction && !directions.includes(direction)) {
            directions.push(direction);
        }
    });

    createDynamicRoads(area, directions);
}


/* =========================================================
   DYNAMIC ROADS
   Each road is rotated to match its actual direction.
========================================================= */

function createDynamicRoads(area, directions) {

    const roadContainer =
        document.getElementById(
            "dynamicRoads"
        );

    if (!roadContainer) {
        return;
    }

    roadContainer.innerHTML = "";

    const roadWidth = 120;
    const roadLength = 360;

    /*
     * The unrotated road extends from the junction center toward
     * NORTH. Rotate clockwise to point toward each other direction.
     */
    const directionRotations = {
        "NORTH": 0,
        "N": 0,

        "NORTH-EAST": 45,
        "NE": 45,

        "EAST": 90,
        "E": 90,

        "SOUTH-EAST": 135,
        "SE": 135,

        "SOUTH": 180,
        "S": 180,

        "SOUTH-WEST": 225,
        "SW": 225,

        "WEST": 270,
        "W": 270,

        "NORTH-WEST": 315,
        "NW": 315
    };

    directions.forEach(function (direction) {

        const road =
            document.createElement("div");

        road.className =
            "dynamic-road-arm";

        road.dataset.direction =
            direction;

        road.style.width =
            roadWidth + "px";

        road.style.height =
            roadLength + "px";

        const normalizedDirection =
            normalizeDirection(direction);

        const angle =
            directionRotations[normalizedDirection] !== undefined
                ? directionRotations[normalizedDirection]
                : 0;

        road.style.transform =
            "translate(-50%, -100%) rotate(" +
            angle +
            "deg)";

        roadContainer.appendChild(road);
    });
}



/* =========================================================
   REAL-WORLD CLOCK
   Shows current local time regardless of simulation state.
========================================================= */

let watchClockTimer = null;

function startWatchClock() {
    updateWatchClockDisplay();

    if (watchClockTimer !== null) {
        clearInterval(watchClockTimer);
    }

    watchClockTimer = setInterval(updateWatchClockDisplay, 1000);
}

function updateWatchClockDisplay() {
    const clock = document.getElementById("simulationClock");

    if (!clock) {
        return;
    }

    const now = new Date();

    clock.textContent = now.toLocaleTimeString([], {
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit",
        hour12: true
    });

    const clockContainer = clock.closest(".simulation-clock-corner");
    if (clockContainer) {
        const label = clockContainer.querySelector("small");
        if (label) {
            const hour = now.getHours();
            let period;

            if (hour >= 5 && hour < 12) {
                period = "Morning";
            } else if (hour >= 12 && hour < 16) {
                period = "Afternoon";
            } else if (hour >= 16 && hour < 20) {
                period = "Evening";
            } else {
                period = "Night";
            }

            label.textContent =  "Local Time · " + period;
        }
    }
}

/* =========================================================
   RESIZE
========================================================= */

window.addEventListener(
    "resize",
    function () {

        arrangeSignalsRadially();
    }
);

package com.trafficiq.service;

import com.trafficiq.dao.JunctionDAO;
import com.trafficiq.dao.SignalDAO;
import com.trafficiq.model.Junction;
import com.trafficiq.model.Signal;
import com.trafficiq.model.TrafficState;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class SimulationManager {

    private static final SimulationManager INSTANCE = new SimulationManager();

    public static SimulationManager getInstance() {
        return INSTANCE;
    }

    private final JunctionDAO junctionDAO = new JunctionDAO();
    private final SignalDAO signalDAO = new SignalDAO();
    private final Map<Integer, JunctionSimulation> simulations = new HashMap<>();

    private boolean globalRunning = false;
    private ScheduledExecutorService scheduler;

    private SimulationManager() {
    }

    public synchronized JunctionSimulation getSimulation(int junctionId) {
        JunctionSimulation simulation = simulations.get(junctionId);

        if (simulation == null) {
            List<Signal> signals = signalDAO.getSignalsByJunction(junctionId);
            simulation = new JunctionSimulation(junctionId, signals);
            simulations.put(junctionId, simulation);
        }

        return simulation;
    }

    public synchronized void startAll() {
        if (globalRunning) {
            return;
        }

        List<Junction> junctions = junctionDAO.getAllJunctions();
        if (junctions != null) {
            for (Junction junction : junctions) {
                getSimulation(junction.getJunctionId());
            }
        }

        globalRunning = true;
        scheduler = Executors.newSingleThreadScheduledExecutor();
        scheduler.scheduleAtFixedRate(this::tickAll, 0, 1, TimeUnit.SECONDS);
    }

    public synchronized void stopAll() {
        globalRunning = false;

        if (scheduler != null) {
            scheduler.shutdownNow();
            scheduler = null;
        }

        for (JunctionSimulation simulation : simulations.values()) {
            simulation.setRunning(false);
        }
    }

    public synchronized void pauseJunction(int junctionId) {
        getSimulation(junctionId).setPaused(true);
    }

    public synchronized void resumeJunction(int junctionId) {
        getSimulation(junctionId).setPaused(false);
    }

    public synchronized boolean isGlobalRunning() {
        return globalRunning;
    }

    public synchronized void requestEmergency(int junctionId, int signalId) {
        getSimulation(junctionId).requestEmergency(signalId);
    }

    public synchronized void clearEmergency(int junctionId) {
        getSimulation(junctionId).clearEmergency();
    }

    private synchronized void tickAll() {
        if (!globalRunning) {
            return;
        }

        for (JunctionSimulation simulation : simulations.values()) {
            simulation.tick();
        }
    }

    /** Night flash mode runs from midnight up to (but not including) 6 AM. */
    public static boolean isTrafficClosedNow() {
        return LocalTime.now().getHour() < 6;
    }

    /**
     * Expected per-second arrival probability for each approach. The simulation
     * adds at most one vehicle per approach per second, rather than adding
     * several vehicles to every red approach on every scheduler tick.
     */
    private static double getVehicleArrivalProbability() {
        int hour = LocalTime.now().getHour();

        if (hour < 6) return 0.0;                    // Night flash: freeze queues
        if (hour >= 8 && hour < 11) return 0.35;    // Morning rush
        if (hour >= 18 && hour < 21) return 0.40;   // Evening rush
        if (hour >= 6 && hour < 8) return 0.10;     // Morning
        if (hour >= 11 && hour < 16) return 0.14;   // Afternoon
        if (hour >= 16 && hour < 18) return 0.22;   // Evening
        return 0.06;                                // Night (9 PM–midnight)
    }

    public static int getTrafficRatePerSecond() {
        // Kept for compatibility with any existing callers. This now describes
        // a modest arrival rate instead of adding 3–4 vehicles every second.
        double probability = getVehicleArrivalProbability();
        return probability >= 0.30 ? 1 : 0;
    }

    public static String getTrafficPeriod() {
        int hour = LocalTime.now().getHour();
        if (hour < 6) return "NIGHT_FLASH";
        if (hour < 8) return "MORNING";
        if (hour < 11) return "MORNING_RUSH";
        if (hour < 16) return "AFTERNOON";
        if (hour < 18) return "EVENING";
        if (hour < 21) return "EVENING_RUSH";
        return "NIGHT";
    }

    public static class JunctionSimulation {

        private static final int MIN_GREEN_SECONDS = 25;
        private static final int MAX_GREEN_SECONDS = 75;
        private static final int ALL_RED_CLEARANCE_SECONDS = 1;

        private final int junctionId;
        private final List<Signal> signals;
        private final Map<Integer, TrafficState> trafficStates = new HashMap<>();

        private int currentIndex = 0;
        private String currentPhase = "READY";
        private int phaseTimer = 0;
        private boolean paused = false;
        private boolean running = false;

        private boolean emergencyActive = false;
        private int emergencySignalId = -1;
        private int adaptiveGreenDuration = 0;

        // Set when an emergency request must interrupt the current green phase.
        private boolean emergencyTransitionPending = false;
        private boolean emergencyClearTransitionPending = false;

        public JunctionSimulation(int junctionId, List<Signal> signals) {
            this.junctionId = junctionId;
            this.signals = signals != null ? new ArrayList<>(signals) : new ArrayList<>();

            this.signals.sort((a, b) -> Integer.compare(a.getDisplayOrder(), b.getDisplayOrder()));

            for (Signal signal : this.signals) {
                trafficStates.put(signal.getSignalId(), new TrafficState(signal.getSignalId(), 2));
            }
        }

        public synchronized int getJunctionId() {
            return junctionId;
        }

        public synchronized List<Signal> getSignals() {
            return signals;
        }

        public synchronized Map<Integer, TrafficState> getTrafficStates() {
            return trafficStates;
        }

        public synchronized String getCurrentPhase() {
            return currentPhase;
        }

        public synchronized int getPhaseTimer() {
            return phaseTimer;
        }

        public synchronized boolean isPaused() {
            return paused;
        }

        public synchronized boolean isRunning() {
            return running;
        }

        public synchronized void setRunning(boolean running) {
            this.running = running;
        }

        public synchronized void setPaused(boolean paused) {
            this.paused = paused;
        }

        public synchronized int getCurrentSignalId() {
            if (signals.isEmpty()) return -1;
            return signals.get(currentIndex).getSignalId();
        }

        public synchronized boolean isClosed() {
            return SimulationManager.isTrafficClosedNow() && !emergencyActive;
        }

        public synchronized boolean isEmergencyActive() {
            return emergencyActive;
        }

        public synchronized int getEmergencySignalId() {
            return emergencySignalId;
        }

        public synchronized int getAdaptiveGreenDuration() {
            return adaptiveGreenDuration;
        }

        public synchronized void requestEmergency(int signalId) {
            boolean signalExists = signals.stream()
                    .anyMatch(signal -> signal.getSignalId() == signalId);

            if (!signalExists) {
                throw new IllegalArgumentException("Signal does not belong to this junction");
            }

            emergencySignalId = signalId;
            emergencyActive = true;

            // Emergency priority overrides a paused junction.
            paused = false;

            // If another approach currently has green, begin its yellow phase
            // on the next scheduler tick instead of waiting for its green timer.
            if ("GREEN".equals(currentPhase)
                    && getCurrentSignalId() != signalId) {
                emergencyTransitionPending = true;
            } else {
                emergencyTransitionPending = false;
            }
        }

        public synchronized void clearEmergency() {
            int clearedSignalId = emergencySignalId;
            boolean emergencyApproachIsGreen =
                    "GREEN".equals(currentPhase)
                            && clearedSignalId >= 0
                            && getCurrentSignalId() == clearedSignalId;

            emergencyActive = false;
            emergencySignalId = -1;
            emergencyTransitionPending = false;

            // If the emergency approach currently has green, end it through
            // yellow and all-red clearance before resuming normal rotation.
            emergencyClearTransitionPending = emergencyApproachIsGreen;
        }

        public synchronized void tick() {
            if (!SimulationManager.getInstance().isGlobalRunning() || paused || signals.isEmpty()) {
                return;
            }

            running = true;

            // 12 AM–6 AM: all signals blink yellow. Do not run green/yellow
            // countdowns, alter queues, or let an emergency request restart the cycle.
            if (SimulationManager.isTrafficClosedNow()) {
                currentPhase = "NIGHT_FLASH";
                phaseTimer = 0;
                adaptiveGreenDuration = 0;
                emergencyTransitionPending = false;
                emergencyClearTransitionPending = false;
                return;
            }

            if ("NIGHT_FLASH".equals(currentPhase) || "CLOSED".equals(currentPhase)) {
                currentPhase = "READY";
            }

            if ("READY".equals(currentPhase)) {
                if (emergencyActive) {
                    selectEmergencySignal();
                }
                startGreen();
                return;
            }

            // Interrupt the normal green immediately when an emergency is requested.
            if (emergencyTransitionPending && "GREEN".equals(currentPhase)) {
                emergencyTransitionPending = false;
                startYellow();
                return;
            }

            // When emergency mode is cleared while its approach is green,
            // begin a safe yellow/all-red transition before normal cycling.
            if (emergencyClearTransitionPending && "GREEN".equals(currentPhase)) {
                emergencyClearTransitionPending = false;
                startYellow();
                return;
            }

            // Hold the selected emergency approach green indefinitely while
            // emergency mode is active. Do not run the normal green countdown.
            if (emergencyActive
                    && "GREEN".equals(currentPhase)
                    && getCurrentSignalId() == emergencySignalId) {
                phaseTimer = 0;
                updateTraffic();
                return;
            }

            updateTraffic();

            if (phaseTimer > 0) {
                phaseTimer--;
            }

            if (phaseTimer > 0) {
                return;
            }

            if ("GREEN".equals(currentPhase)) {
                startYellow();
            } else if ("YELLOW".equals(currentPhase)) {
                // Clearance phase: all approaches are red before the next green.
                currentPhase = "ALL_RED";
                phaseTimer = ALL_RED_CLEARANCE_SECONDS;
            } else if ("ALL_RED".equals(currentPhase)) {
                advanceToNextSignal();
                startGreen();
            }
        }

        private void advanceToNextSignal() {
            if (emergencyActive) {
                selectEmergencySignal();
                return;
            }

            currentIndex = (currentIndex + 1) % signals.size();
        }

        private void selectEmergencySignal() {
            for (int i = 0; i < signals.size(); i++) {
                if (signals.get(i).getSignalId() == emergencySignalId) {
                    currentIndex = i;
                    return;
                }
            }
        }

        private void startGreen() {
            Signal signal = signals.get(currentIndex);
            TrafficState traffic = trafficStates.get(signal.getSignalId());

            int queue = traffic == null ? 0 : Math.max(0, traffic.getVehicleCount());
            int wait = traffic == null ? 0 : Math.max(0, traffic.getWaitingTime());

            // Choose one of the requested adaptive levels. Waiting time is also
            // considered so a lane with a long queue cannot be overlooked.
            if (queue >= 35 || wait >= 150) {
                adaptiveGreenDuration = 75;
            } else if (queue >= 25 || wait >= 120) {
                adaptiveGreenDuration = 60;
            } else if (queue >= 15 || wait >= 90) {
                adaptiveGreenDuration = 45;
            } else if (queue >= 7 || wait >= 45) {
                adaptiveGreenDuration = 30;
            } else {
                adaptiveGreenDuration = 25;
            }

            // Emergency green is held until cleared by the existing emergency logic.
            currentPhase = "GREEN";
            phaseTimer = emergencyActive && signal.getSignalId() == emergencySignalId
                    ? 0
                    : adaptiveGreenDuration;
        }

        private void startYellow() {
            Signal signal = signals.get(currentIndex);
            currentPhase = "YELLOW";
            phaseTimer = Math.max(1, signal.getYellowTime());
        }

        private void clearTraffic() {
            for (TrafficState state : trafficStates.values()) {
                state.setVehicleCount(0);
                state.setWaitingTime(0);
            }
        }

        private void updateTraffic() {
            double arrivalProbability = SimulationManager.getVehicleArrivalProbability();

            for (int i = 0; i < signals.size(); i++) {
                Signal signal = signals.get(i);
                TrafficState state = trafficStates.get(signal.getSignalId());
                if (state == null) continue;

                boolean isGreen = i == currentIndex && "GREEN".equals(currentPhase);

                if (isGreen) {
                    // One or two queued vehicles can depart per simulated second.
                    int dischargeCapacity = ThreadLocalRandom.current().nextInt(1, 3);
                    int passing = Math.min(dischargeCapacity, Math.max(0, state.getVehicleCount()));
                    if (passing > 0) {
                        state.setVehicleCount(state.getVehicleCount() - passing);
                        state.setVehiclesPassed(state.getVehiclesPassed() + passing);
                    }
                    state.setWaitingTime(state.getVehicleCount() > 0 ? state.getWaitingTime() + 1 : 0);
                } else {
                    // Arrivals are probabilistic and depend on the time-of-day session.
                    // At low traffic, many seconds pass without a new vehicle arriving.
                    if (ThreadLocalRandom.current().nextDouble() < arrivalProbability) {
                        state.setVehicleCount(state.getVehicleCount() + 1);
                    }
                    if (state.getVehicleCount() > 0) {
                        state.setWaitingTime(state.getWaitingTime() + 1);
                        state.setTotalWaitingTime(state.getTotalWaitingTime() + state.getVehicleCount());
                    } else {
                        state.setWaitingTime(0);
                    }
                }
            }
        }
    }
}

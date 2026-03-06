package dev.ninesliced;

import com.hypixel.hytale.server.core.plugin.JavaPlugin;
import com.hypixel.hytale.server.core.plugin.JavaPluginInit;

import javax.annotation.Nonnull;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.logging.Logger;

/**
 * Main class for the Hycrates mod.
 * Handles initialization, component registration, and event setup.
 */
public class Hycrates extends JavaPlugin {

    private static final Logger LOGGER = Logger.getLogger(Hycrates.class.getName());
    private static Hycrates instance;

    /**
     * Constructor for the Hycrates plugin.
     *
     * @param init Plugin initialization context.
     */
    public Hycrates(@Nonnull JavaPluginInit init) {
        super(init);
    }

    /**
     * Gets the singleton instance of the Hycrates plugin.
     *
     * @return The active Hycrates instance.
     */
    public static Hycrates get() {
        return instance;
    }

    /**
     * Performs the setup logic for the plugin.
     * Registers components, systems, commands, and event listeners.
     */
    @Override
    protected void setup() {
        instance = this;
        LOGGER.info("========================================");
        LOGGER.info("Setting up Crates Plugin");
        LOGGER.info("========================================");
    }

    @Override
    protected void shutdown() {
        LOGGER.info("Shutting down Hycrates plugin...");

        LOGGER.info("Hycrates plugin shutdown complete.");
        super.shutdown();
    }
}

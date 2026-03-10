package dev.xenap;

import com.hypixel.hytale.logger.HytaleLogger;
import com.hypixel.hytale.server.core.plugin.JavaPlugin;
import com.hypixel.hytale.server.core.plugin.JavaPluginInit;

import javax.annotation.Nonnull;

public class MyPlugin extends JavaPlugin {

    private static final HytaleLogger LOGGER = HytaleLogger.forEnclosingClass();
    private static MyPlugin instance;

    public MyPlugin(@Nonnull JavaPluginInit init) {
        super(init);
    }

    public static MyPlugin get() {
        return instance;
    }

    @Override
    protected void setup() {
        instance = this;
        HytaleLogger.Api info_logger = LOGGER.atInfo();
        info_logger.log("========================================");
        info_logger.log("Setting up MyPlugin Plugin");
        info_logger.log("========================================");

        info_logger.log("Registering components...");
        info_logger.log("Registering systems...");
        info_logger.log("Registering commands...");
        info_logger.log("Registering event listeners...");

        info_logger.log("MyPlugin Plugin setup complete.");
    }

    @Override
    protected void shutdown() {
        LOGGER.atInfo().log("Shutting down MyPlugin plugin...");

        LOGGER.atInfo().log("MyPlugin plugin shutdown complete.");
        super.shutdown();
    }
}

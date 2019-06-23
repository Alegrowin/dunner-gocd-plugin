package com.leopardslab.dunner;

import com.leopardslab.dunner.commands.DunnerCommand;
import com.thoughtworks.go.plugin.api.logging.Logger;


public class DunnerTaskExecutor {
    Logger logger = Logger.getLoggerFor(DunnerTaskExecutor.class);

    public Result execute(Config config, Context context) {
        try {
            return runCommand(context, config);
        } catch (Exception ex) {
            logger.error("Error running the command", ex);
            return new Result(false, "Failed while running the task", ex);
        }
    }

    private Result runCommand(Context taskContext, Config taskConfig) throws Exception {
        try {
            new DunnerCommand(taskContext, taskConfig).run();
            return new Result(true, "Finished");
        } catch(Exception ex) {
            logger.error("Error running the command", ex);
            return new Result(false, "Failed", ex);
        }
    }
}
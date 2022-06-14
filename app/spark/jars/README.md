Place your extra jars here (e.g: database driver or spark catalog like delta lake or apache iceberg)
Then use these properties
# spark.executor.extraClassPath    local:///app/spark/jars/*
# spark.driver.extraClassPath      local:///app/spark/jars/*

Don't put jars directly into your spark jars disrtibution directory !!!

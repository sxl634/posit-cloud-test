## Police Recorded Crime Open Data Tables dashboard
If you choose to run this dashboard locally, please use this as a guide to setting this up on your machine to run locally.

If you don't want to use the data provided, you can download the data from here: https://www.gov.uk/government/statistics/police-recorded-crime-open-data-tables

You want the table called Police recorded crime open data Police Force Area tables from year ending March 2013 onwards. It will download as a .ods file. Don't change that.

The shapefile needed can be found here: https://geoportal.statistics.gov.uk/datasets/ons::police-force-areas-december-2022-ew-buc/explore?location=52.947088%2C-0.021147%2C7.00.

For the .ods file, a function is provided in the load data script in the R folder. All you have to do is run the following:

```convert_prc_data_to_rds("filepath-to-ods-file")```

This will create the RDS file in the correct location the dashboard will read in. Don't touch the RDS file.

For the Shapefile, unzip the file into the Data folder and call it Police_Force_Areas_December_2022_EW_BUC. The shapefiles inside that folder should all be called PFA_DEC_2022_EW_BUC_V2 with the various file extensions.

If I've remembered to use renv for this, you'll need to follow these steps:
 * Before opening the project, make sure you have the renv package installed.
 * Open the project
 * Make sure renv is activated (it will say in the console). If not, you may need to activate renv using ```renv::activate()```.
 * Then run ```renv::restore()```. This will install all the  versions of the packages used to develop this dashboard.
 * Run ```renv::status()``` to check everything is fine. It will say something along the lines of lockfile up to date.
 * Do all the data stuff mentioned above if you haven't already, though you should've downloaded this with the data already there.
 * Run the dashboard as usual.
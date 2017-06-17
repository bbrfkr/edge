# edge
EDGE: Elastic Dockerfile Generating Environment

## abstract
EDGE is the environment to develop generic Dockerfile. EDGE will provide the easier method to build container image from Dockerfile and test the Dockerfile. By this method, you can realize TDD(Test Driven Development) of Dockerfile easily.

## download

```
$ git clone https://github.com/bbrfkr/edge
```

## install
1. Install dependent package.

    ```
     # gem install docker-api serverspec inifile activesupport
    ```

2. Change directory to edge repository.

    ```
     $ cd edge
    ```

3. Check `Bin/edge` command is executable.

```
     $ Bin/edge
     edge: Elastic Dockerfile Generating Environment

     === Usage ===
     * Bin/edge [-h] [-v]
         -h : show this help message
         -v : show version

     * Bin/edge list
         show installed project list

     * Bin/edge params PROJECT
         show default parameters of the specified project

     * Bin/edge build PROJECT
         build the specified project

     * Bin/edge spec PROJECT
         test the specified project
```

## usage

### directory architecture
EDGE has the following directory architecture;
```
./edge
|-- Bin
|   `-- edge
|-- Env
|   `-- [project].ini
`-- Projects
    `-- [project]
        |-- Dockerfile
        |-- properties
        |   |-- default.ini
        |   `-- [test case].ini
        `-- spec
            `-- [spec file]_spec.rb
```
The explanation of each directory and file as follow;

* Bin/edge  
  The body of `Bin/edge` command. Through this command, you can build container image from Dockerfile and test Dockerfile.
* Env/[project].ini  
  The ini file which has properties of the project `[project]`.
* Projects/[project]  
  The project `[project]` directory. In EDGE, project is a unit of building container image and testing Dockerfile.
* Projects/[project]/Dockerfile  
  The Dockerfile which belongs to the project `[project]`. For this Dockerfile, container image will be built and test will be executed.
* Projects/[project]/properties/default.ini  
  The ini file which has default parameters of the project `[project]`. All parameters of the project `[project]` should be described in this file.
* Projects/[project]/properties/[test case].ini  
  The ini file which has properties of the project `[project]` for test. The ini files of the directory `Projects/[project]/properties` will be used for test.
* Projects/spec/[spec file]_spec.rb  
  The body of code for test. In EDGE, test is executed by serverspec. Therefore, the test code should be written according to the syntax of serverspec.

### create properties file
Properties file is an ini file used when project is built or tested. Properties file contains the following contents.

```ini:[project].ini
image=[image_name]
[args]
[key]=[value]
[key]=[value]
```

In first entry `image=[image_name]`, describe the name of container image created from Dockerfile when the project is built or tested. In `[args]` section, define key and value used in Dockerfile as arguments.

After creating properties file, if the file is used when project `[project]` is built, put the file in `Env` directory and rename the file `[project].ini`. if the file is used when project `[project]` is tested, put the file in `Projects/[project]/properties` directory.

Each project should have special properties file `default.ini` in directory `Projects/[project]/properties`. the properties of `default.ini` are used as default values when the project is built or tested.

### write test code
Write test code according to the syntax of serverspec, then put the test code in the directory `Projects/[project]/spec`, and rename the test code `*_spec.rb`. In the test code, properties described properties file can be called by writing as `property['args']['[key]']`;

```
describe ("check ruby version") do
  describe command("source /root/.bash_profile && rbenv version") do
    its(:stdout) { should match /^#{ property['args']['RUBY_VER'] }\s/ }
  end
end
```

### execute test and confirm failure
After writing test code, execute test and confirm the test is failed. To do this, execute the following command;

```
Bin/edge spec [project]
```

Note that in the test, properties of the properties file in the directory `Projects/[project]/properties` are used, and for each of properties files test is executed.

### write Dockerfile
Write Dockerfile as to pass the tests of the written test code. Here, properties described properties file are passed via the docker command option `--build-arg`.

### execute test and confirm success
After writing Dockerfile, execute test and confirm the test is succeeded. To do this, execute the following command;

```
Bin/edge spec [project]
```

### build image
After all tests for Dockerfile are passed, build Dockerfile to make container image. To do this, execute the following command;

```
Bin/edge build [project]
```

Note that in the build, properties of the properties file `[project].ini` in the directory `Env` are used.

### run container!
Run a container from the completely tested container image!

### view defined projects
To view the projects defined in EDGE, execute the following command.
```
$ Bin/edge list
```

### show properties defined in project
To show the properties is defined in project `[project]`, execute the following command.

```
$ Bin/edge params [project]
```


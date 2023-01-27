
## Chapter 4 - How to Create Reusable Infrastructure with Terraform Modules
- At the end of chapter 3, we created [this architecture](https://blog.gruntwork.io/how-to-create-reusable-infrastructure-with-terraform-modules-25526d65f73d#:~:text=In%20the%20previous%20post%2C%20you%20deployed%20architecture%20that%20looks%20like%20this) in our `stage` folder, which if we want a `stage` and prod environment, would mean we'd have to copy this code over to the other environment.
    - These environments would be largely identical but with some slight differences, such as possibly having smaller servers in `stage` to save money.
- Like general-purpose programming languages that the idea of reusable *functions*, terraform has `modules` that can be reused throughout your code!
    - For example, if we have a "standard" webserver-cluster in our environments, we can break this out into a module that can then be pulled into the code for each environment and given minor tweaks to fit that environment.
    - This is key to allowing terraform to be reusable, maintainable, and testable!
- **Module Basics**
    - In fact, a `module` in terraform is any set of configuration files within a folder. So in effect, we've actually been creating modules this entire time. But because we're running apply directly on a module, it's considered a `root module`.
        - What we really want to do is create `reusable modules`, those that are *meant* to be used within other modules.
    - Using `stage/services/webserver-cluster`, we're going to explore creating reusable modules.
        - First we want to remove the `provider` definition in `main.tf` as *providers* should be defined in root modules.
        - Modules use the syntax `module "<NAME>" { source = "<SOURCE>" [CONFIG...]} where NAME is how we will refer to this module throughout our code, SOURCE is the path of the module code, and CONFIG is specific arguments
        - Checking the code in this repo, you can see that we've imported the `webserver-cluster` module into both `stage` and a new environment `prod`. Anytime we add a module or modify a module's `source`, we'll want to run `init` before `plan` or `apply`. You can see when we `init` in `prod` for example, one of the console output lines is actually initializing the module we want to import!
- **Module Inputs**
    - Like a programming language's functions can take input variables, so can modules in the form of their parameters. We can also create a `variables.tf` in a module path to define these inputs.
    - At the end of chapter 3, we hardcoded all of the cluster resource names into `main.tf` that we moved to the new module folder, so if we were to run apply in both `stage` and `prod`, we'd have naming conflicts. So we will want to use `var.cluster_name` instead.
    - Since we created these variables in the module's `variables.tf` file, we can pass values in when we import the module in each environment's `main.tf` by passing values for each variable in the module import. In the `module` definition `main.tf` we use `var.variable_name` to pass it back to itself. See the code for how that works!
- **Module Locals**
    - For some values, using variables might lead to issues because their value can be affected elsewhere in the codebase by you or another user. For example, the `cluster_name` variable can change by accident. We might want some values to remain constant, such as the listener port (80) and not be editable, so we can use the concept of `locals`.
    - Locals are only visible within the module and have no impact on others, and they can't be overridden from outside of that individual module. They use the syntax `local.<NAME>`. We will edit some of the network information for our http listener and alb ingress/egress blocks with locals! See the code.
- **Module Outputs**
    - ASGs can be configured to scale up or down on a schedule using `scheduled actions`, which can be a nice feature if you have repeated timeframes of increased traffic.
        - Note that this might not be best defined in a module, since the module is imported into `stage` and `prod`, and scheduled scaling might not be necessary in a staging environment. So far now we will explore this in the prod environment only.
        - When we create an output in the modules `outputs.tf`, they can be accessed in an environment's `outputs.tf` by defining an output and using the `module.<MODULE_NAME>.<OUTPUT_NAME>` syntax.
- **Module Gotchas**
    - We may want to be aware of two things when creating modules: File paths and inline blocks.
    - File Paths - the `user_data.sh` file is now in our modules folder, and terraform's `templatefile` function reads files from the *relative path* on local disk, meaning when we first created the module, neither environment would be able to successfully call it.
        - We can instead user a `path reference` (`path.<TYPE>`) such as `path.module`. In this case it will use the filesystem path of the module *where the expression is defined*.
        - So in our module's `main.tf` where we define the path of our script, we want to prefix with our path type like so: `${path.module}/user_data.sh` so that other environments know this file is located within the module definition path!
    - Inline blocks - some configuration for resources can either be inline block-defined or defined as separate resources. For example, the `ingress` and `egress` definitions we've done for the security group resource can actually be their own separate resources `aws_security_group_rule`.
        - Mixing the two however can lead to conflict errors as they may attempt to overwrite each other, so when creating modules, it may be best to define them as separate resources. This is because the separate resources can be added anywhere whereas the inline block only applies to the module that creates the resource.
        - To further clarify, in our module we originally defined the `ingress` and `egress` in `aws_security_group alb` so users won't be able to add more rules outside of the module.
        - Changing these to their own resources then allows us in an environment `main.tf`, for example in `stage`, to define additional rules if desired when importing the module while retaining the defaults we create in the module `main.tf`
        - Had we left the original inline blocks in the module `main.tf`, creating additional during the module import would have lead to errors in the rules attempting to overwrite one another.
- Important Note: The book, for simplicity, uses on VPC for both `stage` and `prod` environments. This is not recommended or ideal in actual real world production. Misconfigurations in either environment to critical resources (like route tables) could affect traffic to and from the entire VPC affecting all environments.
    - Thus it is recommended to use separate VPCs, or even separate AWS accounts if possible, to achieve isolation between environments.
- **Module Versioning**
    - So far we created one module that is imported into both `stage` and `prod` environments. This causes an issue in that changes to the module will affect both environments, making testing changes in `stage` much more likely to affect production. A better approach would be to use `versioned modules`, with versions applying to separate environments.
    - An easy way to achieve this versioning is to store module code in a separate git repo and setting the `source` parameter of the module imports to that URL.

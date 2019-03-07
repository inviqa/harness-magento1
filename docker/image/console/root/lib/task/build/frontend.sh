#!/bin/bash

function task_build_frontend()
{
    task "npm:install"
    task "gulp:build"
}

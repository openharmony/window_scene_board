#!/bin/bash
# Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
set -e

create_testing_module() {
    declare -A testing_module
    # 与模块下 hvigorfile.ts 中 config#packageConfig#appName保持一致
    testing_module[app_name]=$1
    # 模块相对工程目录的路径，前后均不需要带/
    testing_module[path_related_project]=$2
    # 测试套名，与模块中 Suite.test.ets 中 describe 定义的名称保持一致，与CDE责任田看板上的英文名保持一致
    testing_module[test_suite_name]=$3
    echo "${testing_module[@]}"
}

testing_modules=(
  "$(create_testing_module \
          'liveview' \
          'feature/liveview' \
          'systemui_liveview'\
    )"
  "$(create_testing_module \
          'statusbarcomponent' \
          'feature/statusbarcomponent' \
          'statusbar_for_oh'\
    )"
)

function config_registry() {
    npm config set strict-ssl false
}

function init_params() {
    if [ -n "$1" ]; then
        PIPELINE_NAME=$1
    else
        PIPELINE_NAME=""
    fi
    echo "init_params PIPELINE_NAME is [$PIPELINE_NAME]"
}

function init_env() {
    export NODE_OPTIONS="--max-old-space-size=20000"
    export NODE_HOME="${NODE_HOME%/bin}"
    export IS_DT_IN_LINUX=true
    # 从工程根目录下build.sh调过来时，pwd取到的目录是工程根目录
    PROJECT_PATH=$(pwd -P)
    echo "NODE_HOME: ${NODE_HOME}, HM_SDK_HOME: ${HM_SDK_HOME}, PROJECT_PATH: ${PROJECT_PATH}"
    echo "HOME: ${HOME}, NODE_VERSION: $(node -v), NPM_VERSION: $(npm -v)"
    init_params "$@"
    config_registry
}

function ohpm_install() {
    pushd "$1"
    ohpm install
    popd
}

function ohpm_install_systemui_deps() {
    cd ${PROJECT_PATH}
    ohpm -v

    for module in "${testing_modules[@]}"; do
        read -r app_name path_related_project test_suite_name <<< "$module"
        echo "start ohpm install ${PROJECT_PATH}/${path_related_project}"
        ohpm_install "${PROJECT_PATH}/${path_related_project}/"
        echo "end ohpm install ${PROJECT_PATH}/${path_related_project}"
    done
}

function update_sdk_interface() {
    echo "[OHOS INFO] update_sdk_interface begin"
    node ${PROJECT_PATH}/hvigor/update-sdk-interface.js ${HM_SDK_HOME}/default/openharmony/
    echo "[OHOS INFO] update_sdk_interface end"
}

function before_do_build_dt() {
    config_project_hvigorfile

    if ! grep -q 'lockfile=false' "${HOME}/.npmrc"; then
        echo 'lockfile=false' >> "${HOME}/.npmrc"
    fi

    cd ${PROJECT_PATH}/signature
    sh build.sh

    cd ${PROJECT_PATH}
    update_sdk_interface
    hvigorw clean --no-daemon
}


function copy_source() {
  app_name=$1
  module_path_related_project=$2

  rm -rf build/outputs/${app_name}/source
  mkdir -p build/outputs/${app_name}/source/${module_path_related_project}/src/main
  cp -r ${module_path_related_project}/src/main/* build/outputs/${app_name}/source/${module_path_related_project}/src/main/
}

function config_project_hvigorfile() {
    cd ${PROJECT_PATH}
    cp feature/notification/systemuitest/systemui_root_hvigorfile.ts hvigorfile.ts
    if [ -n "$PIPELINE_NAME" ]; then
       sed -i "s/^[ \t]*templateEngName:.*/  templateEngName:'${PIPELINE_NAME}',/" hvigorfile.ts
       echo "replace template success"
       grep "templateEngName" ./hvigorfile.ts
    fi
}

function package_testing() {
    mode_name=$1
    echo "package_testing for ${mode_name}"
    hvigorw packageTesting \
          --mode module \
          --analyze=normal \
          --parallel \
          --incremental \
          --no-daemon \
          -p isOhosTest=true \
          -p buildMode=test \
          -p ohos-test-coverage=true \
          -p hvigor-obfuscation=false \
          -p module=$mode_name
    echo "package_testing success for ${mode_name}"
}

function filter_testcases_info() {
    select_param=''
    for module in "${testing_modules[@]}"; do
        read -r app_name path_related_project test_suite_name <<< "$module"
        select_param+=".networkScriptName == \"${app_name}#${test_suite_name}\" or "
    done
    select_param=${select_param% or }

    testcases_info_file_name="testcasesInfo_SystemUI_DT_Template"
    if [ -n "${PIPELINE_NAME}" ]; then
        testcases_info_file_name="testcasesInfo_${PIPELINE_NAME}"
    fi

    echo "select_param: [${select_param}], testcases_info_file_name: [${testcases_info_file_name}]"
    jq ".caseList |= map(select(${select_param}))" build/outputs/${testcases_info_file_name}.json \
        > build/outputs/tmp.json \
        && mv -f build/outputs/tmp.json build/outputs/${testcases_info_file_name}.json
}

function do_build_dt() {
    cd ${PROJECT_PATH}
    for module in "${testing_modules[@]}"; do
        read -r app_name path_related_project test_suite_name <<< "$module"
        copy_source $app_name $path_related_project
        package_testing "${app_name}@ohosTest"
    done

    filter_testcases_info
    dtpinpeline_zip
}

function dtpinpeline_zip() {
    # 检查 build/outputs 是否存在
    if [ ! -d "build/outputs" ]; then
        echo "build/outputs is not exist"
        exit 1
    fi

    # 删除已存在的 zip 文件（如果存在）
    if [ -e "build/DTPipeline.zip" ]; then
        echo "build/DTPipeline.zip is exist"
        rm -rf "${PROJECT_PATH}/build/DTPipeline.zip"
    else
        echo "build/DTPipeline.zip is not exist"
    fi

    # 创建新的 zip 文件
    cd build/outputs || exit 1
    zip -r "${PROJECT_PATH}/build/DTPipeline.zip" ./*
    cd "${PROJECT_PATH}" || exit 1
}

function build_dt() {
    echo "start build systemui dt"
    local start_time=$(date '+%s')

    init_env "$@"
    ohpm_install_systemui_deps
    before_do_build_dt
    do_build_dt

    local end_time=$(date '+%s')
    local elapsed_time=$((end_time-start_time))
    echo "build systemui dt spend ${elapsed_time}s"
}

build_dt "$@"
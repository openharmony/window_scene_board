# Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#!/bin/bash

function init_env {
    export NODE_OPTIONS="--max-old-space-size=20000"
    export NODE_HOME="${NODE_HOME%/bin}"
    export IS_DT_IN_LINUX=true

    echo ${NODE_HOME}
    echo "${HM_SDK_HOME}"
    node -v
    npm -v

    # 初始化相关路径
    PROJECT_PATH="`pwd -P`"
    TOOLS_INSTALL_DIR=${PROJECT_PATH}

    # Setup npm
    npm config set strict-ssl false

    echo "hwsdk.dir=${HM_SDK_HOME}"  > ./local.properties
    echo "nodejs.dir=${NODE_HOME}" >> ./local.properties
}

# 安装ohpm, 若镜像中已存在ohpm，则无需重新安装
function init_ohpm {
    # 下载
    cd ${TOOLS_INSTALL_DIR}
    commandlineVersion=2.0.1.0
    ohpmVersion=5.0.2
    OHPM_HOME=${TOOLS_INSTALL_DIR}/oh-command-line-tools
    mkdir -p ${OHPM_HOME}
    unzip -oq ohcommandline-tools-linux.zip

    # 安装ohpm
    cd ${OHPM_HOME}
    unzip -oq ohpm.zip
    export PATH=${OHPM_HOME}/bin:${PATH}
    ohpm -v

    ohpm config set log_level debug

    # 配置仓库地址
    ohpm config set strict_ssl false
}

# 进入package目录安装依赖
function ohpm_install {
    cd $1
    ohpm -v
    ohpm install
}

# 环境适配
function ohpm_install_deps() {
    cd ${PROJECT_PATH}

    ohpm_install "${PROJECT_PATH}"
    ohpm_install "${PROJECT_PATH}/feature/smartthemes"
    ohpm_install "${PROJECT_PATH}/staticcommon/screenlockcommon"
    ohpm_install "${PROJECT_PATH}/feature/appcenter"
    ohpm_install "${PROJECT_PATH}/feature/carcastsource"
    ohpm_install "${PROJECT_PATH}/feature/castengine"
    ohpm_install "${PROJECT_PATH}/feature/devecoviewer"
    ohpm_install "${PROJECT_PATH}/feature/coverthemecomponent"
    ohpm_install "${PROJECT_PATH}/feature/commonscbscreen"
    ohpm_install "${PROJECT_PATH}/feature/controlcentercomponent"
    ohpm_install "${PROJECT_PATH}/feature/desktop/bigfolder"
    ohpm_install "${PROJECT_PATH}/feature/desktop/emergencymode"
    ohpm_install "${PROJECT_PATH}/feature/desktop/desktopedit"
    ohpm_install "${PROJECT_PATH}/feature/desktop/form"
    ohpm_install "${PROJECT_PATH}/feature/desktop/formstack"
    ohpm_install "${PROJECT_PATH}/feature/desktop/numbadge"
    ohpm_install "${PROJECT_PATH}/feature/desktop/pagedesktop"
    ohpm_install "${PROJECT_PATH}/feature/desktop/smallfolder"
    ohpm_install "${PROJECT_PATH}/feature/desktopfilefolder"
    ohpm_install "${PROJECT_PATH}/feature/engineservice"
    ohpm_install "${PROJECT_PATH}/feature/gesturenavigation"
    ohpm_install "${PROJECT_PATH}/feature/immersivekeyguard"
    ohpm_install "${PROJECT_PATH}/feature/liveview/"
    ohpm_install "${PROJECT_PATH}/feature/multiinput"
    ohpm_install "${PROJECT_PATH}/feature/notification/managementcomponent"
    ohpm_install "${PROJECT_PATH}/feature/notification/notificationcomponent"
    ohpm_install "${PROJECT_PATH}/feature/notification/notificationmanagement"
    ohpm_install "${PROJECT_PATH}/feature/recents"
    ohpm_install "${PROJECT_PATH}/feature/screenlockcomponent"
    ohpm_install "${PROJECT_PATH}/feature/smartdock/commonsmartdock"
    ohpm_install "${PROJECT_PATH}/feature/smartdock/pcsmartdock"
    ohpm_install "${PROJECT_PATH}/feature/statusbarcomponent"
    ohpm_install "${PROJECT_PATH}/feature/superprivacy"
    ohpm_install "${PROJECT_PATH}/feature/systemcontrol/brightnesscomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemcontrol/hcastcomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemcontrol/superprivacycomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemcontrol/mediacontrolcomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemcontrol/powercomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemcontrol/eyecomfortcomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemcontrol/superhubtogglecomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemcontrol/powersavingtogglecomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemcontrol/wirelessreversecomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemcontrol/nearlinktogglecomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemcontrol/pcmodetogglecomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemcontrol/meetingtogglecomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemcontrol/keymousesharecomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemcontrol/soundcomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemcontrol/musicservicetogglecomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemcontrol/cameraopencomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemdialog"
    ohpm_install "${PROJECT_PATH}/feature/collaborationfwkdialog"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/airplanecomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/autorotatecomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/batterycomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/bluetoothcomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/cameracomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/cameraindicator"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/capsulecomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/clockcomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/customcomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/darkmodecomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/datetimecomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/earphonecomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/flashlightcomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/hotspotcomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/inputmethodcomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/linkspeedcomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/locationcomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/microphonecomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/mobiledatacomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/nfccomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/plugincomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/ringmodecomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/signalcomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/starflashcomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/statusbarsuperprivacycomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/wificomponent"
    ohpm_install "${PROJECT_PATH}/feature/systemstatus/plugincardcomponent"
    ohpm_install "${PROJECT_PATH}/feature/themecomponent"
    ohpm_install "${PROJECT_PATH}/feature/volume/volumepanel"
    ohpm_install "${PROJECT_PATH}/feature/volume/volumepanelcomponent"
    ohpm_install "${PROJECT_PATH}/feature/togglehome"
    ohpm_install "${PROJECT_PATH}/feature/wallpapercomponent"
    ohpm_install "${PROJECT_PATH}/feature/statusbarextension"
    ohpm_install "${PROJECT_PATH}/product/phone"
    ohpm_install "${PROJECT_PATH}/product/pc"
    ohpm_install "${PROJECT_PATH}/staticcommon/systemuicommon"
    ohpm_install "${PROJECT_PATH}/staticcommon/launchercommon"
    ohpm_install "${PROJECT_PATH}/feature/themeservice/themeservice_base"
    ohpm_install "${PROJECT_PATH}/feature/themeservice/themeservice_inner_api"
    ohpm_install "${PROJECT_PATH}/feature/themeservice/themeservice_core_lem"
    ohpm_install "${PROJECT_PATH}/feature/themeservice/themeservice_kit"
    ohpm_install "${PROJECT_PATH}/feature/themeservice/themeservice_core"
}

# clean任务
function clean() {
    cd ${PROJECT_PATH}
    chmod +x hvigorw
    ./hvigorw clean --no-daemon
}

# 替换脚本
function shell_replace() {
    if [ "${DT_TASK_FLAG}" == "coverage" ] || [ "${DT_TASK_FLAG}" == "fullCoverage" ];then
        node ./shell/Test_withcoverage.build.js
    elif [ "${DT_TASK_FLAG}" == "fullCoverageReboot" ];then 
        node ./shell/Test_cov_reboot.build.js
    fi
}

# 构建任务
function build() {
    cat ${HOME}/.npmrc | grep 'lockfile=false' || echo 'lockfile=false' >> ${HOME}/.npmrc
    cd ${PROJECT_PATH}/signature
    chmod +x build.sh
    ./build.sh

    cd ${PROJECT_PATH}
    chmod +x hvigorw
    ./hvigorw clean --no-daemon
    
    shell_replace

    mkdir build
    mkdir build/outputs
    mkdir build/outputs/SceneBoard
    ./hvigorw assembleHap --mode module -p module=default_notificationmanagement --no-daemon -p debuggable=false -p buildMode=release -p hvigor-obfuscation=false
    ./hvigorw assembleHap --mode module -p module=engineservice --no-daemon -p debuggable=false -p buildMode=release -p hvigor-obfuscation=false
    ./hvigorw assembleHap --mode module -p module=themecomponent --no-daemon -p debuggable=false -p buildMode=release -p hvigor-obfuscation=false
    ./hvigorw assembleHsp --mode module -p module=basecommon@default -p product=default --no-daemon -p debuggable=false -p buildMode=release -p hvigor-obfuscation=false
    cp ./feature/notification/notificationmanagement/build/default/outputs/default/default_notificationmanagement-phone_sceneboard-default-signed.hap ./build/outputs/SceneBoard/SceneBoard_NotificationManagement.hap
    cp ./feature/engineservice/build/default/outputs/default/engineservice-phone_sceneboard-default-signed.hap ./build/outputs/SceneBoard/SceneBoard_EngineService.hap
    cp ./feature/themecomponent/build/default/outputs/default/themecomponent-phone_sceneboard-default-signed.hap ./build/outputs/SceneBoard/SceneBoard_ThemeComponent.hap
    cp ./basecommon/build/default/outputs/default/basecommon-default-signed.hsp ./build/outputs/SceneBoard/basecommon.hsp
    if [ "${DT_TASK_FLAG}" == "fullCoverage" ] || [ "${DT_TASK_FLAG}" == "fullCoverageReboot" ];then
        ./hvigorw assembleHap --mode module -p module=phone_sceneboard --no-daemon -p debuggable=false -p buildMode=release -p ohos-test-coverage=true -p hvigor-obfuscation=false
    else
        ./hvigorw assembleHap --mode module -p module=phone_sceneboard --no-daemon -p debuggable=false -p buildMode=release -p hvigor-obfuscation=false
    fi
    if [ "${DT_TASK_FLAG}" == "coverage" ] || [ "${DT_TASK_FLAG}" == "fullCoverage" ] || [ "${DT_TASK_FLAG}" == "fullCoverageReboot" ];then
        ./hvigorw --mode module -p module=phone_sceneboard@ohosTest packageTesting --no-daemon -p debuggable=false -p buildMode=release -p ohos-test-coverage=true -p hvigor-obfuscation=false
    else
        ./hvigorw --mode module -p module=phone_sceneboard@ohosTest packageTesting --no-daemon -p debuggable=false -p buildMode=release -p hvigor-obfuscation=false
    fi
    if [ -e "build/DTPipeline.zip" ];then
        echo "build/DTPipeline.zip is exist"
        file_size=$(stat -c%s "build/DTPipeline.zip")
        rm -rf ${PROJECT_PATH}/build/DTPipeline.zip
        cd build/outputs
        if [ $? -ne 0 ];then
            echo "build/outputs is not exist"
            exit 1
        fi
        zip -r ${PROJECT_PATH}/build/DTPipeline.zip ./*
        cd ${PROJECT_PATH}
    else
        echo "build/DTPipeline.zip is not exist"
        cd build/outputs
        if [ $? -ne 0 ];then
            echo "build/outputs is not exist"
            exit 1
        fi
        zip -r ${PROJECT_PATH}/build/DTPipeline.zip ./*
        cd ${PROJECT_PATH}
    fi
}

# 构建任务 - pc
function build_pc() {
    cat ${HOME}/.npmrc | grep 'lockfile=false' || echo 'lockfile=false' >> ${HOME}/.npmrc
    cd ${PROJECT_PATH}/signature
    chmod +x build.sh
    ./build.sh

    cd ${PROJECT_PATH}
    chmod +x hvigorw
    ./hvigorw clean --no-daemon
    ./hvigorw assembleHap --mode module -p module=default_notificationmanagement --no-daemon -p debuggable=false -p buildMode=release
    ./hvigorw assembleHsp --mode module -p module=basecommon@default -p product=default --no-daemon -p debuggable=false -p buildMode=release

    mkdir build
    mkdir build/outputs
    mkdir build/outputs/PCDockAndAppCenter
    cp ./feature/notification/notificationmanagement/build/default/outputs/default/default_notificationmanagement-pc_sceneboard-default-signed.hap ./build/outputs/PCDockAndAppCenter/SceneBoard_NotificationManagement.hap
    cp ./basecommon/build/default/outputs/default/basecommon-default-signed.hsp ./build/outputs/PCDockAndAppCenter/basecommon.hsp

    ./hvigorw assembleHap --mode module -p module=pc_sceneboard --no-daemon -p debuggable=false -p buildMode=release
    if [ "${DT_TASK_FLAG}" == "coverage" ];then
        ./hvigorw --mode module -p module=pc_sceneboard@ohosTest packageTesting --no-daemon -p debuggable=false -p buildMode=release -p ohos-test-coverage=true
    else
        ./hvigorw --mode module -p module=pc_sceneboard@ohosTest packageTesting --no-daemon -p debuggable=false -p buildMode=release
    fi
    if [ -e "build/DTPipeline.zip" ];then
        echo "build/DTPipeline.zip is exist"
        file_size=$(stat -c%s "build/DTPipeline.zip")
        if [ $file_size -gt 0 ];then
            echo "DTPipeline.zip is ok"
        else
            rm -rf ${PROJECT_PATH}/build/DTPipeline.zip
            cd build/outputs
            if [ $? -ne 0 ];then
                echo "build/outputs is not exist"
                exit 1
            fi
            zip -r ${PROJECT_PATH}/build/DTPipeline.zip ./*
            cd ${PROJECT_PATH}
        fi
    else
        echo "build/DTPipeline.zip is not exist"
        cd build/outputs
        if [ $? -ne 0 ];then
            echo "build/outputs is not exist"
            exit 1
        fi
        zip -r ${PROJECT_PATH}/build/DTPipeline.zip ./*
        cd ${PROJECT_PATH}
    fi
}

# 构建任务 - themeservice
function build_themeservice() {
	cat ${HOME}/.npmrc | grep 'lockfile=false' || echo 'lockfile=false' >> ${HOME}/.npmrc
    cd ${PROJECT_PATH}/signature
    chmod +x build.sh
    ./build.sh

    cd ${PROJECT_PATH}
    chmod +x hvigorw
    ./hvigorw clean --no-daemon

    mkdir build
    mkdir build/outputs
    mkdir build/outputs/ThemeService


    ./hvigorw assembleHap --mode module -p module=themeservice_core --daemon -p debuggable=false -p buildMode=release -p ohos-test-coverage=true -p hvigor-obfuscation=false

	if [ "${DT_TASK_FLAG}" == "coverage" ] || [ "${DT_TASK_FLAG}" == "fullCoverage" ];then
	    ./hvigorw --mode module -p module=themeservice_core@ohosTest -p debuggable=false -p ohos-test-coverage=true hvigor-obfuscation=false assembleHap packageTesting  --parallel --incremental --no-daemon --stacktrace
    else
        ./hvigorw --mode module -p module=themeservice_core@ohosTest packageTesting --no-daemon -p debuggable=false -p buildMode=release -p
	fi
    if [ -e "build/DTPipeline.zip" ];then
        echo "build/DTPipeline.zip is exist"
        file_size=$(stat -c%s "build/DTPipeline.zip")
        rm -rf ${PROJECT_PATH}/build/DTPipeline.zip
        cd build/outputs
        if [ $? -ne 0 ];then
            echo "build/outputs is not exist"
            exit 1
        fi
        zip -r ${PROJECT_PATH}/build/DTPipeline.zip ./*
        cd ${PROJECT_PATH}
    else
        echo "build/DTPipeline.zip is not exist"
        cd build/outputs
        if [ $? -ne 0 ];then
            echo "build/outputs is not exist"
            exit 1
        fi
        zip -r ${PROJECT_PATH}/build/DTPipeline.zip ./*
        cd ${PROJECT_PATH}
    fi
}

function main {
    local startTime=$(date '+%s')
    init_env
    clean
    init_ohpm
    ohpm_install_deps
    if [ "${DT_DEVICE_FLAG}" == "pc" ];then
        build_pc
    elif [ "${DT_DEVICE_FLAG}" == "themeservice" ];then
        build_themeservice
    else
        build
    fi
    local endTime=$(date '+%s')
    local elapsedTime=$(expr $endTime - $startTime)
    echo "build success in ${elapsedTime}s..."
}

if [ $1 == "clean" ] || [ $1 == "projects" ];then
   echo "do nothing"
else
   DT_TASK_FLAG=$2
   DT_DEVICE_FLAG=$3
   echo "DT_TASK_FLAG is ${DT_TASK_FLAG}, DT_DEVICE_FLAG is ${DT_DEVICE_FLAG}"
   main
fi

/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import systemParameterEnhance from '@ohos.systemParameterEnhance';

/**
 * 统一记录sceneboard使用到的相关ccm配置信息
 */
export default class RoPropConstants {
  // 底部导航条是否使能开关：当前仅供调测使用
  static SUPPORT_SIMPLE_MODE: boolean =
    systemParameterEnhance.getSync('persist.sceneboard.desktop.simple_mode', 'true') === 'true';

  // 设备形态配置信息
  static DEVICE_SCREEN_FLAG: String = systemParameterEnhance.getSync('const.window.foldscreen.type', '0,0,0,0');
}

/**
 * launcher模块使用的相关配置信息
 */
export class LauncherPropConstants {
  // 底部导航条是否使能开关：当前仅供调测使用
  static SCENEBOAR_AIBAR_ENABLE: boolean =
    systemParameterEnhance.getSync('persist.sceneboard.aibar.enable', 'true') === 'true';
}
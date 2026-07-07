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

/**
 * 克隆云备份服务响应消息
 *
 * @since 2023-11-13
 */
export class CloneCloudServiceResponse {
  public static readonly SUCCESS: string = 'OK';

  public static readonly FAIL: string = 'FAIL';

  public static readonly INVALID_METHOD_ERROR: string = 'INVALID METHOD';

  public static readonly UNKNOWN_METHOD_ERROR: string = 'UNKNOWN METHOD';
}

/**
 * 克隆云备份服务请求方法
 *
 * @since 2023-11-13
 */
export const enum CloneCloudRequestMethod {
  /**
   * com.ohos.clouddrive 调用
   */
  RESTORE_LAUNCHER_DATA = 'restoreLauncherData',

  /**
   * 云备份调用
   */
  RESTORE_BUNDLE_INFO = 'syncRestoreBundleInfo',

  /**
   * HwLauncher系统桌面包名
   */
  RESTORE_LAUNCHER_LAYOUT_FROM_HWLAUNCHER = 'com.ohos.sceneboard',

  /**
   * HM系统桌面包名
   */
  RESTORE_LAUNCHER_LAYOUT_FROM_HM = 'com.ohos.sceneboard',

  /**
   * 克隆中途取消桌面回调
   */
  CANCEL_RESTORE_LAUNCHER_DATA = 'cancelRestoreLauncherData',

  /**
   * 更新未鸿蒙化应用签名
   */
  UPDATE_LEGACY_INFO = 'updateLegacyInfo',
}